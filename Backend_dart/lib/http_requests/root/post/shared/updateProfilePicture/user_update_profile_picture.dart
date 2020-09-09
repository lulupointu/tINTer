import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('userUpdateProfilePicture');

Future<void> userUpdateProfilePicture(
    HttpRequest req, List<String> segments, String login) async {
  final String profilePictureBasePath = '/home/df/tINTerPictures/ProfilePictures';
  _logger.info(printReceivedSegments('UserUpdateProfilePicture', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  var sink = File('$profilePictureBasePath/$login.jpg').openWrite();
  await sink.addStream(req.asBroadcastStream());
  await sink.close();
}
