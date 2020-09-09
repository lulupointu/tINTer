import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

Future<void> binomePairGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('BinomePairGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  BinomePairsManagementTable binomePairsManagementTable = BinomePairsManagementTable(database: tinterDatabase.connection);
  try {
    BuildBinomePair binomePair = await binomePairsManagementTable.getFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode(binomePair.toJson()))
      ..close();
  } catch(error) {
    throw error;
  } finally {
    // await tinterDatabase.close();
  }

  // await tinterDatabase.close();
}