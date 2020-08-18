import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/internal_errors.dart';
import 'package:tinter_backend/models/relation_score.dart';
import 'package:tinter_backend/models/user.dart';

Future<void> userUpdateProfilePicture(
    HttpRequest req, List<String> segments, String login) async {
  final String profilePictureBasePath = '/home/lulupointu/Desktop/ProfilePictures';
  printReceivedSegments('UserUpdateProfilePicture', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  await File('$profilePictureBasePath/$login.jpg').writeAsBytes(
    await req.first,
    mode: FileMode.writeOnly,
  );
}
