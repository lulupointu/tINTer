import 'dart:io';
import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';

Logger _serverLogger = Logger('Server');

Future<void> main() async {
  Stream<HttpRequest> server;

  File _logFile = File('/home/df/logs');
  IOSink _logFileSink = _logFile.openWrite();

  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    _logFileSink.writeln('[${record.loggerName}] | ${record.level.name} | ${record.time} : ${record.message} | ${record.error ?? ''} | ${record.stackTrace ?? ''}');
  });


  try {
    server = await HttpServer.bind(InternetAddress.anyIPv4, 443);
  } catch (e) {
    _serverLogger.log(Level.SHOUT, "Couldn't bind to port 443: $e", e);
    exit(-1);
  }

  _serverLogger.info('Binded successfully on port 433');

  await for (HttpRequest req in server) {

      await authenticationCheckThenRoute(req);
      req.response.close();
  }

 await  _logFileSink.close();

}
