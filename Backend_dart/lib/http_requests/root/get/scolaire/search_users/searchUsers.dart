import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/searched_user_scolaire_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('searchUsersScolairesGet');

Future<void> searchUsersScolairesGet(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments('SearchUsersScolairesGet', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  SearchedUserScolaireTable searchedUserTable = SearchedUserScolaireTable(database: tinterDatabase.connection);

  try {
    Map<String, SearchedUserScolaire> searchedUsers = await searchedUserTable.getAllExceptOneFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode([for (SearchedUserScolaire searchedUser in searchedUsers.values) searchedUser.toJson()]))
      ..close();
  } finally {
    // await tinterDatabase.close();
  }
}

