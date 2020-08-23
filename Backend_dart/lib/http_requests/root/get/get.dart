import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/associatif/associations/associations.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';


Future<void> getToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('getToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'associatif':
      return associationsGetToNextSegment(req, segments, login);
//    case 'scolaire':
//      return scolaireGetToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}