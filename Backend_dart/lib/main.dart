import 'dart:convert';
import 'dart:io';
import 'package:fcm_api/fcm_api.dart';
import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;



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
        '[${record.loggerName}] | ${record.level.name} | ${record.time} : ${record.message} ${(record.error == null) ? '' : ' | ${record.error ?? ''} | ${record.stackTrace ?? ''}'}');
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
        _serverLogger.info(
            'New http request. uri: ${req.uri}, path: ${req.uri.path}, header: ${req.headers}, cookies: ${req.cookies}');
        if (req.uri.path == '/' && req.uri.queryParameters.containsKey('ticket')) {
          _serverLogger.info('New authentication request from CAS');
          final response = await http.get(Uri.parse('https://cas.imtbs-tsp.eu/cas/serviceValidate?service=http%3A%2F%2Fdfvps.telecom-sudparis.eu%3A443&ticket=${req.uri.queryParameters['ticket']}'));
          _serverLogger.info('REPONSE FROM CAS. body: ${response.body}');
          final xmlResponse = xml.XmlDocument.parse(response.body);
          print('xmlResponse.children: ${xmlResponse.children}');

          final xmlUserAttributes = xmlResponse.getAttributeNode('serviceResponse').getAttributeNode('authenticationSuccess').getAttributeNode('user').getAttributeNode('attributes'); // serviceResponse/authenticationSuccess/user/attributes
          final username = xmlUserAttributes.getAttribute('uid');
          _serverLogger.info('username: ${username}');
          // final email = ;
          // final firstName ;
          // final lastName ;
        } else {
          await authenticationCheckThenRoute(req);
        }
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
