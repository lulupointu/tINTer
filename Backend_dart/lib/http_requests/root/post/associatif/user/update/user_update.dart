import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';

Future<void> userUpdate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserUpdate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  BuildUserAssociatif user;
  try {
    user = BuildUserAssociatif.fromJson(json.decode(await utf8.decodeStream(req)));
  } catch (error) {
    throw error;
  }

  if (user.login != login) {
    throw InvalidQueryParameterError(
        'The given user has a different login than the one associated with the given token.',
        true);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  UsersAssociatifsTable usersTable = UsersAssociatifsTable(database: tinterDatabase.connection);

  await usersTable.update(userAssociatif: user);

  Map<String, BuildUserAssociatif> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(login: login, primoEntrant: user.primoEntrant);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);
  GoutsMusicauxTable goutsMusicauxTable =
  GoutsMusicauxTable(database: tinterDatabase.connection);

  int numberMaxOfAssociations = (await associationsTable.getAll()).length;
  int numberMaxOfGoutsMusicaux = (await goutsMusicauxTable.getAll()).length;

  Map<String, RelationScoreAssociatif> mapUserToListRelationScoreAssociatif =
  RelationScoreAssociatif.getScoreBetweenMultiple(
      user,
      [for (String login in mapUserLoginToUsers.keys) mapUserLoginToUsers[login]],
      numberMaxOfAssociations,
      numberMaxOfGoutsMusicaux);

  RelationsScoreAssociatifTable relationsScoreTable =
  RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  await relationsScoreTable.updateMultiple(listRelationScoreAssociatif: [
    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScoreAssociatif[login]
  ]);

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
