import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/binome/binome.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

Future<void> scolairePostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('scolairePostToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'binomeUpdateRelationStatus':
      return binomeUpdateRelationStatusScolaire(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}