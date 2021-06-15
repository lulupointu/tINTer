import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/shared/sessions.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/session.dart';
import 'package:xml/xml.dart' as xml;

Logger _logger = Logger('loginWithCAS');

Future<void> loginWithCAS(HttpRequest req, String ticket) async {
  UsersTable usersTable = UsersTable(
    database: tinterDatabase.connection,
  );
  SessionsTable sessionsTable = SessionsTable(
    database: tinterDatabase.connection,
  );
  _logger.info('Try authenticating with CAS');

  // Get information from the CAS
  final response = await http.get(
    Uri.parse(
      'https://cas.imtbs-tsp.eu/cas/serviceValidate?service=https%3A%2F%2Fdfvps.telecom-sudparis.eu%3A443%2Fcas&ticket=${ticket}',
    ),
  );

  // This response contains information about the user
  final xmlResponse = xml.XmlDocument.parse(response.body);
  final username = xmlResponse.findAllElements('cas:uid').first.text;
  final email = xmlResponse.findAllElements('cas:mail').first.text;
  final firstName = xmlResponse.findAllElements('cas:givenName').first.text;
  final lastName = xmlResponse.findAllElements('cas:sn').first.text;

  _logger.info('Authenticated user $username with CAS');

  try {
    _logger.info(
        'Get static student info from database, If unknown EmptyResponseToDatabaseQuery is raised');
    await usersTable.getFromLogin(login: username);

    _logger.info('Generate a new token, store it, and send it');
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      (b) => b
        ..token = _newToken
        ..login = username
        ..creationDate = DateTime.now().toUtc()
        ..isValid = true,
    ));

    req.response
      ..headers.add('Content-Type', 'text/html; charset=UTF-8')
      ..write(successfulHTML(cookie: _newToken))
      ..close();
  } on EmptyResponseToDatabaseQuery {
    _logger.info(
        'Got EmptyResponseToDatabaseQuery, this means that it is the first authentication, therefore we save the static profile');
    await usersTable.addBasicInfo(
      basicUserInfo: BasicUserInfo(
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: username,
      ),
    );

    _logger.info('Generate a new token, store it, and send it');
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      (b) => b
        ..token = _newToken
        ..login = username
        ..creationDate = DateTime.now().toUtc()
        ..isValid = true,
    ));

    req.response
      ..headers.add('Content-Type', 'text/html; charset=UTF-8')
      ..write(successfulHTML(cookie: _newToken))
      ..close();
  }
}

String successfulHTML({@required String cookie}) {
  return """
<style>
  html,
  body {
    height: 100%;
  }

  html {
    display: table;
    width: 100%;
  }

  body {
    display: table-cell;
    text-align: center;
    vertical-align: middle;
  }

</style>
<cookie hidden=" ">$cookie</cookie>
<p class="content">
  Connexion réussie
</p>
""";
}
