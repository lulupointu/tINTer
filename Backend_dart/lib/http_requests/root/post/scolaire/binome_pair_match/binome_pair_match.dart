import 'dart:convert';
import 'dart:io';

import 'package:fcm_api/fcm_api.dart' as fmc;
import 'package:built_collection/built_collection.dart';
import 'package:logging/logging.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/notification_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/main.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_body.dart';
import 'package:tinter_backend/models/shared/notification_relation_status_types/notification_relation_status_title.dart';

final _logger = Logger('binomePairMatchUpdateRelationStatus');

Future<void> binomePairMatchUpdateRelationStatus(
    HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'BinomePairMatchUpdateRelationStatus', segments));

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  // TinterDatabase tinterDatabase = TinterDatabase();
  // await tinterDatabase.open();

  RelationStatusBinomePair relationStatus;
  try {
    Map<String, dynamic> relationStatusJson = jsonDecode(await utf8.decodeStream(req));
    BinomePairsProfilesTable binomePairsProfilesTable =
        BinomePairsProfilesTable(database: tinterDatabase.connection);
    int binomePairId = await binomePairsProfilesTable.getBinomePairIdFromLogin(login: login);
    relationStatusJson['binomePairId'] = binomePairId;
    relationStatus = RelationStatusBinomePair.fromJson(relationStatusJson);
  } catch (error) {
    throw error;
  }

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
      print(error);
      throw InternalDatabaseError(error);
    }
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  // // Get logins to notify from otherBinomePairId
  // BinomePairsProfilesTable binomePairsProfilesTable =
  //     BinomePairsProfilesTable(database: tinterDatabase.connection);
  // Map<String, dynamic> binomePairInfo = await binomePairsProfilesTable.getFromBinomePairId(
  //     binomePairId: relationStatus.otherBinomePairId);
  //
  // // Get devices to notify
  // NotificationTable notificationTable = NotificationTable(database: tinterDatabase.connection);
  // List<String> notificationTokens = (await notificationTable
  //         .getFromLogins(logins: [binomePairInfo['login'], binomePairInfo['otherLogin']]))
  //     .values
  //     .fold([], (List<String> previousValue, List<String> element) => previousValue + element);
  //
  // // Send the notifications
  // await fcmAPI.sendAll(notificationTokens
  //     .map((String token) => fmc.Message((b) => b
  //       ..token = token
  //       ..data = BuiltMap<String, String>.from({
  //         'title': NotificationRelationStatusTitle.relationStatusBinomeUpdate.serialize(),
  //         'body': jsonEncode(
  //             NotificationRelationStatusBody((b) => b..relationStatus = relationStatus)
  //                 .toJson()),
  //       }).toBuilder()))
  //     .toList());

  // await tinterDatabase.close();
}
