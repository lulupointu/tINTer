import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/user/info/info.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> userGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'info':
      return userInfoGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}