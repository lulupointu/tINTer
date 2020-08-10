import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/http_requests/root/root.dart';

Future<void> main() async {
  Stream<HttpRequest> server;

  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }

  await for (HttpRequest req in server) {
    List<String> segments = req.uri.path.split('/');

    // The first element is an empty string, remove it
    segments.removeAt(0);

    try {
      await rootToGetOrPost(req, segments);
    } on UnknownRequestError {
      print('(UnknownRequestError) path ${req.uri.path} could not be resolved.');
    } on RangeError {
      print('(RangeError) path ${req.uri.path} could not be resolved.');
    } on MissingQueryParameterError catch(error) {
      print('(WrongQueryParameterError) with path ${req.uri.path}:  expected parameter ${error.expectedParameter}');
  } on WrongQueryParameterTypeError catch(error) {
      print('(WrongQueryParameterError) with path ${req.uri.path}: ${error.error}');
    } on InvalidQueryParameterError catch(error) {
      print('(WrongQueryParameterError) with path ${req.uri.path}: ${error.error}');
    }
    req.response.close();

  }
}

// TODO: check for error in the uri


void printReceivedSegments(String functionName, List<String> segments) {
  print('($functionName) Recieved segment: $segments');
}

class UnknownRequestError implements Exception {}

class MissingQueryParameterError implements Exception {
  final String expectedParameter;

  MissingQueryParameterError({@required this.expectedParameter});
}

class WrongQueryParameterTypeError implements Exception {
  final TypeError error;

  WrongQueryParameterTypeError({@required this.error});
}

class InvalidQueryParameterError implements Exception {
  final String error;

  InvalidQueryParameterError({@required this.error});
}
