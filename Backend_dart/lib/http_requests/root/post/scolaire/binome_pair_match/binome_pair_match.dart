import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';

Future<void> binomePairMatchUpdateRelationStatus(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('BinomePairMatchUpdateRelationStatus', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  RelationStatusBinomePair relationStatus;
  try {
    Map<String, dynamic> relationStatusJson = jsonDecode(await utf8.decodeStream(req));
    relationStatusJson['login'] = login;
    relationStatus = RelationStatusBinomePair.fromJson(relationStatusJson);
  } catch(error) {
    throw error;
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  RelationsStatusBinomePairsMatchesTable relationsStatusTable =
  RelationsStatusBinomePairsMatchesTable(database: tinterDatabase.connection);

  try {
    await relationsStatusTable.update(relationStatus: relationStatus);
  } on PostgreSQLException catch (error) {
    // Error 22023 is the error intentionally emitted when a
    // change from one status to another is not possible.
    if (error.code == 22023) {
      throw InvalidQueryParameterError(error.message, true);
    } else {
      throw InternalDatabaseError(error);
    }
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
