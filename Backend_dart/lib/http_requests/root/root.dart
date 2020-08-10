import 'dart:io';

import 'package:tinter_backend/http_requests/root/get/get.dart';
import 'package:tinter_backend/http_requests/root/post/post.dart';
import 'package:tinter_backend/test.dart';

Future<void> rootToGetOrPost(HttpRequest req, List<String> segments) async {
  printReceivedSegments('rootToGetOrPost', segments);

  print(req.method);

  switch (req.method) {
    case 'GET':
      return getToNextSegment(req, segments);
    case 'POST':
      return postToNextSegment(req, segments);
    default:
      throw UnknownRequestError();
  }
}