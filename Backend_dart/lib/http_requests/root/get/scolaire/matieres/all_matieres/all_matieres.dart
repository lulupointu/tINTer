import 'dart:convert';
import 'dart:typed_data';

import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

Future<void> allMatieresGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('AllMatieresGet', segments);

  if (segments.length != 0) {
    return UnknownRequestedPathError(req.uri.path);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  MatieresTable associationsTable = MatieresTable(database: tinterDatabase.connection);

  List<String> allMatieres = await associationsTable.getAll();

  await req.response
    ..statusCode = HttpStatus.ok
    ..write(json.encode(allMatieres))
    ..close();


  await tinterDatabase.close();
}