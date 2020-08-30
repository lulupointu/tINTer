import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> hasBinomePairGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('hasBinomePairGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  BinomePairsProfilesTable binomePairsTable = BinomePairsProfilesTable(database: tinterDatabase.connection);
  try {
    bool hasBinomePair = await binomePairsTable.isKnownFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'hasBinomePair': hasBinomePair}))
      ..close();
  } on EmptyResponseToDatabaseQuery {
    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'hasBinomePair': false}))
      ..close();
  } finally {
    await tinterDatabase.close();
  }

  await tinterDatabase.close();
}