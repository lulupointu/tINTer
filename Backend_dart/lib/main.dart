import 'dart:convert';
import 'dart:io';
import 'package:fcm_api/fcm_api.dart';
import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';

TinterDatabase tinterDatabase = TinterDatabase();

FcmAPI fcmAPI = FcmAPI();

Logger _serverLogger = Logger('Server');

Future<void> main() async {
  Stream<HttpRequest> server;

  File _logFile = File('/home/df/logs');
  IOSink _logFileSink = _logFile.openWrite(mode: FileMode.append);

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    _logFileSink.writeln(
        '[${record.loggerName}] | ${record.level.name} | ${record.time} : ${record.message} | ${record.error ?? ''} | ${record.stackTrace ?? ''}');
  });

  try {
    server = await HttpServer.bind(InternetAddress.anyIPv4, 443);
  } catch (e) {
    _serverLogger.log(Level.SHOUT, "Couldn't bind to port 443: $e", e);
    await _logFileSink.close();
    exit(-1);
  }

  _serverLogger.info('Binded successfully on port 433');

  _serverLogger.info('Opening database connexion');
  tinterDatabase.open();

  _serverLogger.info('Connecting to notification server (Firebase Cloud messaging)');
  fcmAPI.initializeApp(
      secret: jsonDecode(File('/home/df/tinter-2c20c-firebase-adminsdk-miqgz-8935722edb.json')
          .readAsStringSync()));
  try {
    await for (HttpRequest req in server) {
      try {
        await authenticationCheckThenRoute(req);
        req.response.close();
      } catch (e) {
        _serverLogger.shout('Error crashed the server: $e');
      }
    }
  } catch (e) {
    _serverLogger.shout('Error crashed the server: $e');
  } finally {
    _serverLogger.info('Closing database connexion');
    tinterDatabase.close();
    _serverLogger.info('Closing FCM connexion');
    fcmAPI.close();
  }

  await _logFileSink.close();
}
