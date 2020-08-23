import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/shared/delete/delete_account.dart';
import 'package:tinter_backend/http_requests/root/post/shared/updateProfilePicture/user_update_profile_picture.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> sharedPostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('sharedPostToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'updateProfilePicture':
      return userUpdateProfilePicture(req, segments, login);
    case 'deleteAccount':
      return userDeleteAccount(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}

