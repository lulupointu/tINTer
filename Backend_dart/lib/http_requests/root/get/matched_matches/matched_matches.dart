import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/matches_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/match.dart';
import 'package:tinter_backend/test.dart';

Future<void> matchedMatchesGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('MatchedMatchesGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  MatchesTable matchesTable = MatchesTable(
    database: tinterDatabase.connection,
  );

  List<Match> matchedMatches = await matchesTable.getMatchedMatchesFromLogin(login: login);

  req.response
    ..encoding = utf8
    ..statusCode = HttpStatus.ok
    ..write(matchedMatches.map((Match match) => json.encode(match.toJson())))
    ..close();

  await tinterDatabase.close();
}
