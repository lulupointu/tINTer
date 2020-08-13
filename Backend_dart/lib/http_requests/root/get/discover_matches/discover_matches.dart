import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/matches_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/match.dart';
import 'package:tinter_backend/test.dart';
import 'package:meta/meta.dart';

Future<void> discoverMatchesGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('DiscoverMatchesGet', segments);

  // There should be only one segment left
  if (segments.length != 1) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // This segment should follow the form
  // {'offset': X, 'limit': Y} where X and Y are int
  try {
    Map<String, dynamic> offsetAndLimit = jsonDecode(await utf8.decodeStream(req));

    if (!(offsetAndLimit.containsKey('limit') && offsetAndLimit.containsKey('offset'))) {
      throw WrongFormatError(
          error: "The format should be {'offset': X, 'limit': Y}, not ${segments[0]}",
          shouldSend: true);
    } else if (!(offsetAndLimit['limit'] is int && offsetAndLimit['limit'] is int)) {
      throw WrongFormatError(
          error: "Limit and offset should be int. Here"
              "    - Limit is ${offsetAndLimit['limit'].runtimeType}"
              "    - Offset is ${offsetAndLimit['offset'].runtimeType}",
          shouldSend: true);
    }

    TinterDatabase tinterDatabase = TinterDatabase();
    await tinterDatabase.open();

    MatchesTable matchesTable = MatchesTable(database: tinterDatabase.connection);
    List<Match> matchedMatches = await matchesTable.getXDiscoverMatchesFromLogin(
      login: login,
      limit: offsetAndLimit['limit'],
      offset: offsetAndLimit['offset'],
    );

    await req.response
      ..encoding = utf8
      ..statusCode = HttpStatus.ok
      ..write(utf8.encode(matchedMatches.map((Match match) => match.toJson()).toString()))
      ..close();

    await tinterDatabase.close();
  } catch (e) {
    throw e;
  }
}
