import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/matches_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/associatif/match.dart';
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

  List<BuildMatch> matchedMatches = await matchesTable.getMatchedMatchesFromLogin(login: login);

  req.response
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(matchedMatches.map((BuildMatch match) => match.toJson()).toList()))
    ..close();

  await tinterDatabase.close();
}
