import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/user/user.dart';
import 'package:tinter_backend/http_requests/root/post/match/match.dart';
import 'package:tinter_backend/http_requests/root/post/user/user.dart';
import 'package:tinter_backend/models/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> postToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('postToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userPostToNextSegment(req, segments, login);
    case 'matchUpdateRelationStatus':
      return matchUpdateRelationStatus(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}