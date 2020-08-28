import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matieres/all_matieres/all_matieres.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';


Future<void> matieresGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('MatieresGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'allMatieres':
      return allMatieresGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}
