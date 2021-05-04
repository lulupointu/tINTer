import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/shared/ldap_connection.dart' as ldap;
import 'package:tinter_backend/database_interface/shared/sessions.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/root/root.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/session.dart';
import 'package:meta/meta.dart';

Logger _authenticationLogger = Logger('authenticationCheckThenRoute');

Future<void> authenticationCheckThenRoute(HttpRequest req) async {
  // The segment are the different part of the uri
  List<String> segments = req.uri.path.split('/');
  // The first element is an empty string, remove it
  if (segments.length > 0) segments.removeAt(0);

  // if login then use ldap to check for credentials
  if (segments[0] == 'login') {
    try {
      await tryLogin(httpRequest: req);
    } on HttpError catch (error) {
      _authenticationLogger.fine("", error);
      if (error.shouldSend)
        await req.response
          ..statusCode = error.errorCode ?? HttpStatus.badRequest
          ..write(error)
          ..close();
      return;
    } catch (error) {
      _authenticationLogger.warning("Unexpected error caught", error);
      await req.response
        ..statusCode = HttpStatus.badRequest
        ..close();
      return;
    }
    return;
  }

  // Else this means that the student is already authenticated and that
  // a session token is attached to the request.
  String login;
  try {
    login = await checkSessionTokenAndGetLogin(httpRequest: req);
  } on HttpError catch (error) {
    _authenticationLogger.fine("", error);
    if (error.shouldSend)
      await req.response
        ..statusCode = error.errorCode ?? HttpStatus.badRequest
        ..write(error)
        ..close();
    return;
  } catch (error) {
    _authenticationLogger.warning("Unexpected error caught", error);
    await req.response
      ..statusCode = HttpStatus.badRequest
      ..close();
    return;
  }

  if (segments[0] == 'authenticate') {
    await req.response.close();
    return;
  }

//  if (segments[0] == 'picture.png') {
//    print('SERVE IMAGE');
//    var file = File('/home/df/tINTerPictures/logo_tinter.png');
//
//    Future<Uint8List> picture = file.readAsBytes();
//    req.response.statusCode = HttpStatus.ok;
//    req.response.headers.contentType = ContentType.parse("image/png");
//    await req.response.addStream(picture.asStream());
//    await req.response.close();
//    return;
//  }

  try {
    await rootToGetOrPost(req, segments, login);
  } on HttpError catch (error) {
    _authenticationLogger.fine("", error);
    if (error.shouldSend)
      await req.response
        ..statusCode = error.errorCode ?? HttpStatus.badRequest
        ..write(error)
        ..close();
    return;
  } catch (error) {
    _authenticationLogger.warning("Unexpected error caught", error);
    await req.response
      ..statusCode = HttpStatus.badRequest
      ..close();
    return;
  }
}

Logger _checkSessionLogger = Logger('checkSessionTokenAndGetLogin');

Future<String> checkSessionTokenAndGetLogin({@required HttpRequest httpRequest}) async {
  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  SessionsTable sessionsTable = SessionsTable(database: tinterDatabase.connection);

  try {
    _checkSessionLogger.info(
        "Check if the token is in the session table, if not a EmptyResponseToDatabaseQuery is raised");
    final String _token = httpRequest.headers.value(HttpHeaders.wwwAuthenticateHeader);

    final Session session = await sessionsTable.getFromToken(token: _token);
    final String login = session.login;

    // If the token is in the database but invalid, it must be an attack
    // So we invalid all token from the given login and throw an InvalidTokenError
    if (!session.isValid) {
      await sessionsTable.invalidAllFromLogin(login: session.login);
      throw InvalidTokenError(error: 'The given token is invalid', shouldSend: true);
    }

    // If the token is more than Session.MaximumLifeTime old, the token is expired and should not be used
    // So we set isValid to false and throw an ExpiredTokenError.
    if (session.creationDate.add(Session.MaximumLifeTime).compareTo(DateTime.now().toUtc()) <
        0) {
      await sessionsTable.update(
          session: Session(
        (b) => b
          ..token = session.token
          ..login = session.login
          ..creationDate = session.creationDate
          ..isValid = false,
      ));
      throw ExpiredTokenError(
          error: 'Your token is too old, you need to authenticate again', shouldSend: true);
    }

    // Check if the token should be refreshed if needed, default to false
    bool shouldRefresh;
    try {
      shouldRefresh = httpRequest.uri.queryParameters['shouldRefresh'].toLowerCase() == 'true';
    } catch (_) {
      shouldRefresh = false;
    }

    if (shouldRefresh) {
      // If the token is more than Session.MaximumTimeBeforeRefresh old,
      // we accept the authentication and give a new refreshed token.
      // Else we accept and send back the same token.
      if (session.creationDate
              .add(Session.MaximumTimeBeforeRefresh)
              .compareTo(DateTime.now().toUtc()) <
          0) {
        final String _newToken = generateNewToken();
        await sessionsTable.update(
            session: Session(
          (b) => b
            ..token = session.token
            ..login = session.login
            ..creationDate = session.creationDate
            ..isValid = false,
        ));
        await sessionsTable.add(
            session: Session(
          (b) => b
            ..token = _newToken
            ..login = session.login
            ..creationDate = DateTime.now().toUtc()
            ..isValid = true,
        ));
        await httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
      } else {
        await httpRequest.response.headers
            .add(HttpHeaders.wwwAuthenticateHeader, session.token);
      }
    }
    return login;
  } on EmptyResponseToDatabaseQuery {
    // await tinterDatabase.close();
    throw UnknownTokenError(error: 'The given token is unknown.', shouldSend: true);
  } on InvalidTokenError {
    // await tinterDatabase.close();
    throw InvalidTokenError(error: 'The given token is invalid.', shouldSend: true);
  } on ExpiredTokenError {
    // await tinterDatabase.close();
    throw ExpiredTokenError(error: 'The given token is expired.', shouldSend: true);
  } finally {
    // await tinterDatabase.close();
  }
}

Logger _tryLoginLogger = Logger('tryLogin');

Future<void> tryLogin({@required HttpRequest httpRequest}) async {
  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  UsersTable usersTable = UsersTable(
    database: tinterDatabase.connection,
  );
  SessionsTable sessionsTable = SessionsTable(
    database: tinterDatabase.connection,
  );

  _tryLoginLogger.info('Get login and password from request header');
  final String _loginPassword = utf8
      .decode(base64Url.decode(httpRequest.headers.value(HttpHeaders.wwwAuthenticateHeader)));

  final int splitIndex = _loginPassword.indexOf(':');
  if (splitIndex == -1) {
    throw InvalidCredentialsFormatException(
        'Login or password format is incorrect.\nPlease write in the form login:password',
        true);
  }
  final String _login = _loginPassword.substring(0, splitIndex);
  final String _password = _loginPassword.substring(splitIndex + 1);

  Map<String, String> userBasicInfoJson;
  try {
    _tryLoginLogger.info('Try authenticating with LDAP');

    _tryLoginLogger.info(
        'Get static student info from ldap. If authentication failed, InvalidCredentialsException is raised');
    userBasicInfoJson = await ldap.getUserInfoFromLDAP(login: _login, password: _password);

    _tryLoginLogger.info(
        'Get static student info from database, If unknown EmptyResponseToDatabaseQuery is raised');
    await usersTable.getFromLogin(login: _login);

    _tryLoginLogger.info('Generate a new token, store it, and send it in the header');
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      (b) => b
        ..token = _newToken
        ..login = _login
        ..creationDate = DateTime.now().toUtc()
        ..isValid = true,
    ));
    httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
  } on InvalidCredentialsException catch (error) {
    throw error;
  } on EmptyResponseToDatabaseQuery {
    _tryLoginLogger.info(
        'This means that it is the first authentication, therefore we save the static profile');
    await usersTable.addBasicInfo(userJson: userBasicInfoJson);

    _tryLoginLogger.info('Generate a new token, store it, and send it in the header');
    String _newToken = generateNewToken();
    await sessionsTable.add(
        session: Session(
      (b) => b
        ..token = _newToken
        ..login = _login
        ..creationDate = DateTime.now().toUtc()
        ..isValid = true,
    ));
    httpRequest.response.headers.add(HttpHeaders.wwwAuthenticateHeader, _newToken);
  } finally {
    // await tinterDatabase.close();
  }
}

String printReceivedSegments(String login, String functionName, List<String> segments) {
  return '$login ($functionName): Recieved segment: $segments';
}
