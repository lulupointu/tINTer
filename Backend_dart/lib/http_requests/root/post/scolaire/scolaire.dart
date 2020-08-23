import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/binome/binome.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/user/user.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> scolairePostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('scolairePostToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userPostToNextSegment(req, segments, login);
    case 'matchUpdateRelationStatusAssociatif':
      return matchUpdateRelationStatusScolaire(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}