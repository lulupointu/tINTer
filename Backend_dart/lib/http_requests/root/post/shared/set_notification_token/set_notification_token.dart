import 'dart:convert';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/shared/notification_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

final _logger = Logger('setNotificationToken');

Future<void> setNotificationToken(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'setNotificationToken', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  String notificationToken;
  try {
    notificationToken = jsonDecode(await utf8.decodeStream(req))['notificationToken'];
  } catch (error) {
    throw InvalidQueryParameterError(error, false);
  }

  NotificationTable notificationTable = NotificationTable(database: tinterDatabase.connection);

  // Save user notification token
  try {
    await notificationTable.add(login: login, token: notificationToken);
  } catch (error) {
    throw error;
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();
}
