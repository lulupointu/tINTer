import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/user/user.dart';
import 'package:tinter_backend/models/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> getToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('getToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userGet(req, segments, login);
    case 'discoverMatches':
      return;
    case 'matchedMatches':
      return;
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}