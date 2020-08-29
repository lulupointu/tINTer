import 'dart:io';
import 'package:tinter_backend/http_requests/authentication_check.dart';

Future<void> main() async {
  Stream<HttpRequest> server;

  try {
    server = await HttpServer.bind(InternetAddress.anyIPv4, 443);
  } catch (e) {
    print("Couldn't bind to port 443: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {

      await authenticationCheckThenRoute(req);
      req.response.close();
  }
}
