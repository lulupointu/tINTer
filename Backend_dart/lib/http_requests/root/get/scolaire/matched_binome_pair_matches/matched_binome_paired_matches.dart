import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_matches_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/scolaire/binome_pair_match.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> matchedBinomePairMatchesGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('MatchedBinomePairMatchesGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  BinomePairsMatchesTable binomePairsMatchesTable = BinomePairsMatchesTable(
    database: tinterDatabase.connection,
  );

  List<BuildBinomePairMatch> matchedBinomePairMatches = await binomePairsMatchesTable.getMatchedBinomesFromLogin(login: login);

  req.response
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(matchedBinomePairMatches.map((BuildBinomePairMatch match) => match.toJson()).toList()))
    ..close();

  // await tinterDatabase.close();
}
