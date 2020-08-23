import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/associatif/match/match.dart';
import 'package:tinter_backend/http_requests/root/post/associatif/user/user.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> associatifPostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('AssociatifPostToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userPostToNextSegment(req, segments, login);
    case 'matchUpdateRelationStatusAssociatif':
      return matchUpdateRelationStatusAssociatif(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}