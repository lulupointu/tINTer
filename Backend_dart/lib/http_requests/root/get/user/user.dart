import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> userGet(HttpRequest req, List<String> segments) async {
  printReceivedSegments('UserGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'isKnown':
      return;
    case 'BasicInfo':
      return;
    case 'Info':
      return;
    default:
      throw UnknownRequestError();
  }
}