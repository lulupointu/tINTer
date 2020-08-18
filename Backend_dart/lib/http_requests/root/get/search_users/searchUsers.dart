import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/searched_user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/searched_user.dart';

Future<void> searchUsersGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('SearchUsersGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  SearchedUserTable searchedUserTable = SearchedUserTable(database: tinterDatabase.connection);

  try {
    Map<String, SearchedUser> searchedUsers = await searchedUserTable.getAllExceptOneFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode([for (SearchedUser searchedUser in searchedUsers.values) searchedUser.toJson()]))
      ..close();
  } finally {
    await tinterDatabase.close();
  }
}

