import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/searched_user_associatif_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/associatif/searched_user_associatif.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('searchUsersAssociatifsGet');
Future<void> searchUsersAssociatifsGet(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'SearchUsersAssociatifsGet', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  SearchedUserAssociatifTable searchedUserTable = SearchedUserAssociatifTable(database: tinterDatabase.connection);

  try {
    Map<String, SearchedUserAssociatif> searchedUsers = await searchedUserTable.getAllExceptOneFromLogin(login: login);


    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode([for (SearchedUserAssociatif searchedUser in searchedUsers.values) searchedUser.toJson()]))
      ..close();
  } finally {
    // await tinterDatabase.close();
  }
}

