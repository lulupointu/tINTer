import 'dart:convert';

import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

Future<void> allAssociationsGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('AllAssociationsGet', segments);

  if (segments.length != 0) {
    return UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);

  List<Association> allAssociations = await associationsTable.getAll();

  await req.response
    ..statusCode = HttpStatus.ok
    ..write(json.encode(allAssociations.map((Association association) => association.toJson()).toList()))
    ..close();


  // await tinterDatabase.close();
}