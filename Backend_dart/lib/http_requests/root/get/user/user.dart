import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/user/info/info.dart';
import 'package:tinter_backend/http_requests/root/get/user/is_known/is_known.dart';
import 'package:tinter_backend/http_requests/root/get/user/static_info/static_info.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/test.dart';

Future<void> userGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'isKnown':
      return isUserKnownGet(req, segments, login);
    case 'staticInfo':
      return staticUserInfoGet(req, segments, login);
    case 'info':
      return userInfoGet(req, segments, login);
//    case 'profilePicture':
//      return userProfilePictureGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}