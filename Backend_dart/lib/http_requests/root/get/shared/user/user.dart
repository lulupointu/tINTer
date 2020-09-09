import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/shared/user/info/info.dart';
import 'package:tinter_backend/http_requests/root/get/shared/user/profile_picture/profile_picture.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';


final _logger = Logger('userSharedGetToNextSegment');

Future<void> userSharedGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'userSharedGetToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'info':
      return userSharedInfoGet(req, segments, login);
    case 'profilePicture':
      return userProfilePictureGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}



