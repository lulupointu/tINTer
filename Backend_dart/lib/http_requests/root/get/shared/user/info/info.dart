import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/user.dart';


final _logger = Logger('userSharedInfoGet');

Future<void> userSharedInfoGet(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments('userSharedInfoGet', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  UsersManagementTable usersManagementTable = UsersManagementTable(database: tinterDatabase.connection);

  try {
    BuildUser user = await usersManagementTable.getFromLogin(login: login);

    await req.response
      ..statusCode = HttpStatus.ok
      ..write(json.encode(user.toJson()))
      ..close();
  } on EmptyResponseToDatabaseQuery {
    // await tinterDatabase.close();
    throw UserNotFound('The user with login $login was not found.', true);
  } finally {
    // await tinterDatabase.close();
  }
}

