import 'package:tinter_backend/http_requests/root/get/user/user.dart';
import 'package:tinter_backend/http_requests/root/post/user/user.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> postToNextSegment(HttpRequest req, List<String> segments) async {
  printReceivedSegments('postToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userUpdate(req, segments);
    default:
      throw UnknownRequestError();
  }
}