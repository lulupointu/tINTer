import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('isUserKnownGet');
Future<void> isUserKnownGet(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments(login, 'IsUserKnownGet', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);
  try {
    bool isKnown = await usersTable.isKnown(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'isKnown': isKnown}))
      ..close();
  } on EmptyResponseToDatabaseQuery {
    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode({'isKnown': false}))
      ..close();
  } finally {
    // await tinterDatabase.close();
  }

  // await tinterDatabase.close();
}