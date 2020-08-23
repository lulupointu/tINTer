import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binomes_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/associatif/match.dart';
import 'package:tinter_backend/test.dart';
import 'package:meta/meta.dart';

Future<void> discoverBinomesGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('DiscoverBinomesGet', segments);

  // There should be only one segment left
  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // This queryParameters should follow the form
  // {'offset': X, 'limit': Y} where X and Y are int
  try {
    if (!(req.uri.queryParameters.containsKey('limit') && req.uri.queryParameters.containsKey('offset'))) {
      throw WrongFormatError(
          error: "The format should be {'offset': X, 'limit': Y}, not ${segments[0]}",
          shouldSend: true);
    } else if (!(req.uri.queryParameters['limit'] is int && req.uri.queryParameters['limit'] is int)) {

    }

    int limit, offset;
    try {
      limit = int.parse(req.uri.queryParameters['limit']);
      offset = int.parse(req.uri.queryParameters['offset']);
    } on FormatException {
      throw WrongFormatError(
          error: "Limit and offset should be parsable to int. Here"
              "    - Limit is ${req.uri.queryParameters['limit']}"
              "    - Offset is ${req.uri.queryParameters['offset']}",
          shouldSend: true);
    }

    TinterDatabase tinterDatabase = TinterDatabase();
    await tinterDatabase.open();

    BinomesTable binomesTable = BinomesTable(database: tinterDatabase.connection);
    List<BuildBinome> matchedBinomes = await binomesTable.getXDiscoverBinomesFromLogin(
      login: login,
      limit: limit,
      offset: offset,
    );

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode(matchedBinomes.map((BuildBinome binome) => binome.toJson()).toList()))
      ..close();

    await tinterDatabase.close();
  } catch (e) {
    throw e;
  }
}