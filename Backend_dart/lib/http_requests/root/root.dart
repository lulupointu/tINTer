import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/get.dart';
import 'package:tinter_backend/http_requests/root/post/post.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/test.dart';

Future<void> rootToGetOrPost(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('rootToGetOrPost', segments);


  switch (req.method) {
    case 'GET':
      return getToNextSegment(req, segments, login);
    case 'POST':
      return postToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}