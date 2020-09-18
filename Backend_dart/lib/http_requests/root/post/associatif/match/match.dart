import 'dart:convert';
import 'dart:io';

import 'package:fcm_api/fcm_api.dart' as fmc;
import 'package:built_collection/built_collection.dart';
import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/shared/notification_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_body.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_title.dart';
import 'package:tinter_backend/models/shared/relation_status.dart';
import 'package:tinter_backend/models/shared/user.dart';

final _logger = Logger('matchUpdateRelationStatusAssociatif');

Future<void> matchUpdateRelationStatusAssociatif(
    HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'matchUpdateRelationStatusAssociatif', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  RelationStatusAssociatif relationStatus;
  try {
    Map<String, dynamic> relationStatusJson = jsonDecode(await utf8.decodeStream(req));
    relationStatusJson['login'] = login;
    relationStatus = RelationStatusAssociatif.fromJson(relationStatusJson);
  } catch (error) {
    throw error;
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

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

  if (relationStatus.otherLogin == 'delsol_l') {

  // Get match information
  UsersManagementTable usersManagementTable =
      UsersManagementTable(database: tinterDatabase.connection);
  BuildUser matchProfile =
      await usersManagementTable.getFromLogin(login: relationStatus.otherLogin);
  RelationStatusAssociatif otherRelationStatus = await relationsStatusTable.getFromLogins(
      login: relationStatus.otherLogin, otherLogin: relationStatus.login);

  // If the otherRelationStatus is none or ignored, do not send a notification
  switch (otherRelationStatus.status) {
    case EnumRelationStatusAssociatif.none:
    case EnumRelationStatusAssociatif.ignored:
      break;
  }

  // Get devices to notify
  NotificationTable notificationTable = NotificationTable(database: tinterDatabase.connection);
  List<String> notificationTokens =
      await notificationTable.getFromLogin(login: relationStatus.otherLogin);

  // Send the notifications
  await fcmAPI.sendAll(notificationTokens
      .map((String token) => fmc.Message((b) => b
        ..token = token
        ..data = BuiltMap<String, String>.from({
          'title': NotificationRelationStatusTitle.relationStatusAssociatifUpdate.serialize(),
          'relationStatus': jsonEncode(
              NotificationRelationStatusBody((b) => b..relationStatus = relationStatus)
                  .toJson()),
          'matchName': matchProfile.name,
          'matchSurname': matchProfile.surname,
        }).toBuilder()))
      .toList());
  }
}
