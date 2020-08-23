import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';

Future<void> matchUpdateRelationStatusAssociatif(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('matchUpdateRelationStatusAssociatif', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  RelationStatusAssociatif relationStatus;
  try {
    Map<String, dynamic> relationStatusJson = jsonDecode(await utf8.decodeStream(req));
    relationStatusJson['login'] = login;
    relationStatus = RelationStatusAssociatif.fromJson(relationStatusJson);
  } catch(error) {
    throw error;
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  RelationsStatusAssociatifTable relationsStatusTable =
      RelationsStatusAssociatifTable(database: tinterDatabase.connection);

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