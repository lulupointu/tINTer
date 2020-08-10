import 'package:tinter_backend/http_requests/root/get/user/user.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> getToNextSegment(HttpRequest req, List<String> segments) async {
  printReceivedSegments('getToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userGet(req, segments);
    default:
      throw UnknownRequestError();
  }
}