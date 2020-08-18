import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';

Future<void> userUpdateProfilePicture(
    HttpRequest req, List<String> segments, String login) async {
  final String profilePictureBasePath = '/home/lulupointu/Desktop/ProfilePictures';
  printReceivedSegments('UserUpdateProfilePicture', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  var sink = File('$profilePictureBasePath/$login.jpg').openWrite();
  await sink.addStream(req.asBroadcastStream());
  await sink.close();
}
