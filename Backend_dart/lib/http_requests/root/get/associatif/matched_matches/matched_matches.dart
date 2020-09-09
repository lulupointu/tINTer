import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/matches_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/associatif/match.dart';

final _logger = Logger('matchedMatchesGet');
Future<void> matchedMatchesGet(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments('MatchedMatchesGet', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  MatchesTable matchesTable = MatchesTable(
    database: tinterDatabase.connection,
  );

  List<BuildMatch> matchedMatches = await matchesTable.getMatchedMatchesFromLogin(login: login);

  req.response
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(matchedMatches.map((BuildMatch match) => match.toJson()).toList()))
    ..close();

  // await tinterDatabase.close();
}
