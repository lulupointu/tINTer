import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/shared/create/create.dart';
import 'package:tinter_backend/http_requests/root/post/shared/delete/delete.dart';
import 'package:tinter_backend/http_requests/root/post/shared/set_notification_token/set_notification_token.dart';
import 'package:tinter_backend/http_requests/root/post/shared/update/update.dart';
import 'package:tinter_backend/http_requests/root/post/shared/updateProfilePicture/user_update_profile_picture.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('sharedPostToNextSegment');

Future<void> sharedPostToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'sharedPostToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'updateProfilePicture':
      return userUpdateProfilePicture(req, segments, login);
    case 'delete':
      return userDelete(req, segments, login);
    case 'create':
      return userCreate(req, segments, login);
    case 'update':
      return userUpdate(req, segments, login);
    case 'setNotificationToken':
      return setNotificationToken(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}

