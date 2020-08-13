import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/test.dart';

Future<void> userGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'isKnown':
      return;
    case 'StaticInfo':
      return;
    case 'Info':
      return;
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}