import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:tinter_backend/models/user.dart';
import 'package:tinter_backend/test.dart';

Future<void> staticUserInfoGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('StaticUserInfoGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  StaticProfileTable staticProfileTable = StaticProfileTable(database: tinterDatabase.connection);
  try {
    StaticStudent staticStudent = await staticProfileTable.getFromLogin(login: login);

    await req.response
      ..encoding = utf8
      ..statusCode = HttpStatus.ok
      ..write(staticStudent.toJson())
      ..close();
  } on EmptyResponseToDatabaseQuery {
    await tinterDatabase.close();
    throw UserNotFound('The static profile with login $login was not found.', true);
  } finally {
    await tinterDatabase.close();
  }


  await tinterDatabase.close();
}