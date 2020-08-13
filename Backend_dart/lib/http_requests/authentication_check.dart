import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/ldap_connection.dart' as ldap;
import 'package:tinter_backend/database_interface/sessions.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/root/root.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/session.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:meta/meta.dart';

Future<void> authenticationCheckThenRoute(HttpRequest req) async {
  // The segment are the different part of the uri
  List<String> segments = utf8.decode(base64Decode(req.uri.path)).split('/');
  // The first element is an empty string, remove it
  segments.removeAt(0);

  // if login then use ldap to check for credentials
  if (segments[0] == 'login') {
    await tryLogin(httpRequest: req);
    return;
  }

  // Else this means that the student is already authenticated and that
  // a session token is attached to the request.
  String login;
  try {
    login = await checkSessionTokenAndGetLogin(httpRequest: req);
  } catch (error) {
    print('Error caught: $error');
    return;
  }

  try {
    await rootToGetOrPost(req, segments, login);
  } on UnknownRequestedPathError {
    await req.response
      ..statusCode = HttpStatus.badRequest
      ..write('Request method should be GET or POST, not ${req.method}')
      ..close();
    return;
  } on HttpError catch (error) {
    if (error.shouldSend)
      await req.response
        ..statusCode = HttpStatus.badRequest
        ..write(error)
        ..close();
    return;
  } catch (error) {
    print('An unexpected error happened: $error');
    req.response.close();
    return;
  }
}

Future<String> checkSessionTokenAndGetLogin({@required HttpRequest httpRequest}) async {
  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  SessionsTable sessionsTable = SessionsTable(database: tinterDatabase.connection);

  try {
    // Check if the token is in the session table, if not a EmptyResponseToDatabaseQuery is raised
    final String _token = httpRequest.headers.value(HttpHeaders.wwwAuthenticateHeader);
    final Session session = await sessionsTable.getFromToken(token: _token);
    final String login = session.login;

    // If the token is in the database but invalid, it must be an attack
    // So we invalid all token from the given login and throw an InvalidTokenError
    if (!session.isValid) {
      await sessionsTable.invalidAllFromLogin(login: session.login);
      throw InvalidTokenError();
    }

    // If the token is more than Session.MaximumLifeTime old, the token is expired and should not be used
    // So we set isValid to false and throw an ExpiredTokenError.
    if (session.creationDate.add(Session.MaximumLifeTime).compareTo(DateTime.now()) > 0) {
      await sessionsTable.update(
          session: Session(
        token: session.token,
        login: session.login,
        creationDate: session.creationDate,
        isValid: false,
      ));
      throw ExpiredTokenError();
    }

    // If the token is more than Session.MaximumTimeBeforeRefresh old,
    // we accept the authentication and give a new refreshed token.
    // Else we accept and send back the same token.
    if (session.creationDate.add(Session.MaximumTimeBeforeRefresh).compareTo(DateTime.now()) >
        0) {
      final String _newToken = generateNewToken();
      await sessionsTable.update(
          session: Session(
        token: session.token,
        login: session.login,
        creationDate: session.creationDate,
        isValid: false,
      ));
      await sessionsTable.add(
          session: Session(
        token: _newToken,
        login: session.login,
        creationDate: DateTime.now(),
        isValid: true,
      ));
      await httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
    } else {
      await httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, session.token);
    }
    return login;
  } on EmptyResponseToDatabaseQuery {
    await httpRequest.response
      ..statusCode = HttpStatus.forbidden
      ..write('The given token is unknown.')
      ..close();
    await tinterDatabase.close();
    throw UnknownTokenError();
  } on InvalidTokenError {
    await httpRequest.response
      ..statusCode = HttpStatus.forbidden
      ..write('The given token is invalid.')
      ..close();
    await tinterDatabase.close();
    throw InvalidTokenError();
  } on ExpiredTokenError {
    await httpRequest.response
      ..statusCode = HttpStatus.forbidden
      ..write('The given token is expired.')
      ..close();
    await tinterDatabase.close();
    throw ExpiredTokenError;
  } finally {
    await tinterDatabase.close();
  }
}

Future<void> tryLogin({@required HttpRequest httpRequest}) async {
  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  StaticStudent ldapStaticStudent;
  StaticProfileTable staticProfileTable = StaticProfileTable(
    database: tinterDatabase.connection,
  );
  SessionsTable sessionsTable = SessionsTable(
    database: tinterDatabase.connection,
  );

  // Get login and password from request header
  final String _loginPassword =
      utf8.decode(base64Decode(httpRequest.headers.value(HttpHeaders.wwwAuthenticateHeader)));
  final int splitIndex = _loginPassword.indexOf(':');
  if (splitIndex == -1) {
    throw InvalidCredentialsFormatException('Login or password format is incorrect.\nPlease write in the form login:password', true);
  }
  final String _login = _loginPassword.substring(0, splitIndex);
  final String _password = _loginPassword.substring(splitIndex);

  try {
    // Get static student info from ldap. If authentication failed, InvalidCredentialsException is raised
    ldapStaticStudent = await ldap.getStaticStudent(login: _login, password: _password);

    // Get static student info from database, If unknown EmptyResponseToDatabaseQuery is raised
    await staticProfileTable.getFromLogin(login: _login);

    // Generate a new token, store it, and send it in the header
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      token: _newToken,
      login: _login,
      creationDate: DateTime.now(),
      isValid: true,
    ));
    httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
  } on ldap.InvalidCredentialsException {
    httpRequest.response
      ..statusCode = HttpStatus.forbidden
      ..write('Login or password incorrect.')
      ..close();
  } on EmptyResponseToDatabaseQuery {
    // This means that it is the first authentication, therefore we save the static profile
    staticProfileTable.add(staticProfile: ldapStaticStudent);

    // Generate a new token, store it, and send it in the header
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      token: _newToken,
      login: _login,
      creationDate: DateTime.now(),
      isValid: true,
    ));
    httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
  } finally {
    await tinterDatabase.close();
  }
}


void printReceivedSegments(String functionName, List<String> segments) {
  print('($functionName) Recieved segment: $segments');
}


