import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binomes_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> discoverBinomePairsGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('DiscoverBinomePairsGet', segments);

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

    BinomePairsProfilesTable binomesTable = BinomePairsTable(database: tinterDatabase.connection);
    List<BuildBinome> matchedBinomePairs = await binomesTable.getXDiscoverBinomePairsFromLogin(
      login: login,
      limit: limit,
      offset: offset,
    );

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode(matchedBinomePairs.map((BuildBinome binome) => binome.toJson()).toList()))
      ..close();

    await tinterDatabase.close();
  } catch (e) {
    throw e;
  }
}
