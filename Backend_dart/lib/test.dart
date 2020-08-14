import 'dart:io';
import 'package:tinter_backend/http_requests/authentication_check.dart';

Future<void> main() async {
  Stream<HttpRequest> server;

  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {

      await authenticationCheckThenRoute(req);
      req.response.close();
  }
}
