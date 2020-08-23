import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:tinter_backend/test.dart';

Future<void> isUserKnownGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('IsUserKnownGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  UsersAssociatifsTable usersTable = UsersAssociatifsTable(database: tinterDatabase.connection);
  try {
    UserAssociatif user = await usersTable.getFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'isKnown': true}))
      ..close();
  } on EmptyResponseToDatabaseQuery {
    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'isKnown': false}))
      ..close();
  } finally {
    await tinterDatabase.close();
  }

  await tinterDatabase.close();
}