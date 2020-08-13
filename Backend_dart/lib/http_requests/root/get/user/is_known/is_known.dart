import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/user.dart';
import 'package:tinter_backend/test.dart';

Future<void> isUserKnownGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('IsUserKnownGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);
  try {
    User user = await usersTable.getFromLogin(login: login);

    await req.response
      ..encoding = utf8
      ..statusCode = HttpStatus.ok
      ..write({'isKnown': true})
      ..close();
  } on EmptyResponseToDatabaseQuery {
    await req.response
      ..encoding = utf8
      ..statusCode = HttpStatus.ok
      ..write({'isKnown': false})
      ..close();
  } finally {
    await tinterDatabase.close();
  }

  await tinterDatabase.close();
}