import 'dart:io';
import 'dart:typed_data';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> userProfilePictureGet(
    HttpRequest req, List<String> segments, String login) async {
  final String profilePictureBasePath = '/home/df/tINTerPictures/ProfilePictures';
  printReceivedSegments('UserProfilePictureGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  if (!(req.uri.queryParameters.containsKey('login'))) {
    throw MissingQueryParameterError('The parameter \'login\' is needed', true);
  }

  final profilePictureLogin = req.uri.queryParameters['login'];

  File file;
  if (FileSystemEntity.typeSync('$profilePictureBasePath/$profilePictureLogin.jpg') !=
      FileSystemEntityType.notFound) {
    file = File('$profilePictureBasePath/$profilePictureLogin.jpg');
  } else {
    file = File('$profilePictureBasePath/default.jpg');
  }

  Future<Uint8List> picture = file.readAsBytes();
  req.response.statusCode = HttpStatus.ok;
  req.response.headers.contentType = ContentType.parse("image/png");
  await req.response.addStream(picture.asStream());
  await req.response.close();

  await tinterDatabase.close();
}
