import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/associatif/user/create/user_create.dart';
import 'package:tinter_backend/http_requests/root/post/associatif/user/update/user_update.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> userPostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserPostToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'create':
      return userCreate(req, segments, login);
    case 'update':
      return userUpdate(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}

