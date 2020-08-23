import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:tinter_backend/test.dart';

Future<void> userInfoGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserInfoGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  UsersAssociatifsTable usersTable = UsersAssociatifsTable(database: tinterDatabase.connection);

  try {
    BuildUserAssociatif user = await usersTable.getFromLogin(login: login);

    await req.response
    ..statusCode = HttpStatus.ok
    ..write(json.encode(user.toJson()))
    ..close();
  } on EmptyResponseToDatabaseQuery {
    await tinterDatabase.close();
    throw UserNotFound('The user with login $login was not found.', true);
  } finally {
    await tinterDatabase.close();
  }
}
