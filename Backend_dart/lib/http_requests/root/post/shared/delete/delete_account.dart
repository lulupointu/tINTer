import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';

Future<void> userDeleteAccount(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserDeleteAccount', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }


  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  try {
    await usersTable.remove(login: login);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
