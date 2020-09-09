import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binomes_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('matchedBinomesGet');

Future<void> matchedBinomesGet(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'MatchedBinomesGet', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  BinomesTable binomesTable = BinomesTable(
    database: tinterDatabase.connection,
  );

  List<BuildBinome> matchedBinomes = await binomesTable.getMatchedBinomesFromLogin(login: login);

  req.response
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(matchedBinomes.map((BuildBinome match) => match.toJson()).toList()))
    ..close();

  // await tinterDatabase.close();
}
