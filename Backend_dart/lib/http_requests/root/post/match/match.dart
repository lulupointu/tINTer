import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/internal_errors.dart';
import 'package:tinter_backend/models/relation_status.dart';

Future<void> matchUpdate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('matchUpdate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  RelationStatus relationStatus;
  try {
    relationStatus = RelationStatus.fromJson(jsonDecode(await utf8.decodeStream(req)));
  } catch(error) {
    throw error;
  }

  if (relationStatus.login != login) {
    throw InvalidQueryParameterError(
        'The given relationStatus has a different login than the one associated with the given token.',
        true);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  RelationsStatusTable relationsStatusTable =
      RelationsStatusTable(database: tinterDatabase.connection);

  try {
    relationsStatusTable.update(relationStatus: relationStatus);
  } on PostgreSQLException catch (error) {
    // Error 22023 is the error intentionally emitted when a
    // change from one status to another is not possible.
    if (error.code == 22023) {
      throw InvalidQueryParameterError(error.message, true);
    } else {
      throw InternalDatabaseError(error);
    }
  }

  req.response
    ..encoding = utf8
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
