import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fcm_api/fcm_api.dart';
import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/cas_login.dart';

TinterDatabase tinterDatabase = TinterDatabase();

FcmAPI fcmAPI = FcmAPI();

Logger _serverLogger = Logger('Server');

int i = 0;

Future<void> main() async {
  while (true) {
    HttpServer server;
    try {
      File _logFile = File('/home/df/logs');
      IOSink _logFileSink = _logFile.openWrite(mode: FileMode.append);

      Logger.root.level = Level.ALL; // defaults to Level.INFO
      Logger.root.onRecord.listen((record) {
        _logFileSink.writeln(
            '[${record.loggerName}] | ${record.level.name} | ${record.time} : ${record.message} ${(record.error == null) ? '' : ' | ${record.error ?? ''} | ${record.stackTrace ?? ''}'}');
      });

      // Setup https
      SecurityContext context = new SecurityContext();
      var chain = Platform.script
          .resolve('/home/df/certificates/STG-df_telecom-sudparis_eu_cert.cer')
          .toFilePath();
      var key = Platform.script
          .resolve('/home/df/certificates/STG-df.telecom-sudparis.eu-nop.key')
          .toFilePath();
      context.useCertificateChain(chain);
      context.usePrivateKey(key);

      try {
        server = await HttpServer.bindSecure(InternetAddress.anyIPv4, 443, context);
        // server = await HttpServer.bind(InternetAddress.anyIPv4, 443);
      } catch (e) {
        _serverLogger.log(Level.SHOUT, "Couldn't bind to port 443: $e", e);
        await _logFileSink.close();
        exit(-1);
      }

      _serverLogger.info('Binded successfully on port 433');

      _serverLogger.info('Opening database connexion');
      await tinterDatabase.open();

      _serverLogger.info('Connecting to notification server (Firebase Cloud messaging)');
      await fcmAPI.initializeApp(
          secret: jsonDecode(
              File('/home/df/tinter-2c20c-firebase-adminsdk-miqgz-8935722edb.json')
                  .readAsStringSync()));

      i++;
      if (i < 5) throw 'SOME RANDOM ARTIFICIAL ERROR';
      await for (HttpRequest req in server) {
        await runZonedGuarded(
          () async {
            // The segment are the different part of the uri
            List<String> segments = req.uri.path.split('/');
            // The first element is an empty string, remove it
            if (segments.isNotEmpty) segments.removeAt(0);

            final rootSegment = segments.isNotEmpty ? segments.first : null;
            switch (rootSegment) {
              case 'cas':
                if (!req.uri.queryParameters.containsKey('ticket'))
                  throw Exception(
                    "A CAS https request should contain the 'ticket' query parameter",
                  );
                _serverLogger.info('New authentication request from CAS');
                await loginWithCAS(req, req.uri.queryParameters['ticket']);
                break;

              case 'tinter_mobile_app':
                _serverLogger.info('New https request from tinter_mobile_app');
                await authenticationCheckThenRoute(req, segments);
                break;

              default:
                _serverLogger
                    .warning('Got request with uri ${req.uri}, but this uri is not handled');
            }

            req.response.close();
          },
          (e, stacktrace) => _serverLogger.shout(
            'Request error could have crashed the server: $e. \nStacktrace:\n$stacktrace',
          ),
        );
      }

      _serverLogger.info('Closing database connexion');
      await tinterDatabase.close();
      _serverLogger.info('Closing FCM connexion');
      fcmAPI.close();
      server.close();

      await _logFileSink.close();
    } catch (e, stacktrace) {
      _serverLogger.info('Closing database connexion');
      await tinterDatabase.close();
      _serverLogger.info('Closing FCM connexion');
      fcmAPI.close();
      server.close();

      _serverLogger.shout(
        'Unknown error could have crashed the server: $e.\nStacktrace:\n$stacktrace',
      );
    }
  }
}
