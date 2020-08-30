import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/searched_binome_pair_table.dart';
import 'package:tinter_backend/database_interface/scolaire/searched_user_scolaire_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/searched_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> searchBinomePairGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('SearchBinomePairGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  SearchedBinomePairsTable searchedBinomePairsTable = SearchedBinomePairsTable(database: tinterDatabase.connection);

  try {
    Map<String, SearchedBinomePair> searchedBinomePairs = await searchedBinomePairsTable.getAllExceptOneFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode([for (SearchedBinomePair searchedUser in searchedBinomePairs.values) searchedUser.toJson()]))
      ..close();
  } finally {
    await tinterDatabase.close();
  }
}

