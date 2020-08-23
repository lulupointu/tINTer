import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/shared/associations/associations.dart';
import 'package:tinter_backend/http_requests/root/get/shared/user/info/info.dart';
import 'package:tinter_backend/http_requests/root/get/shared/user/user.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> sharedGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('SharedGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userSharedGetToNextSegment(req, segments, login);
    case 'associations':
      return associationsGetToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}



