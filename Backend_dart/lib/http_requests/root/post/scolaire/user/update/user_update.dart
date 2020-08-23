import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/users_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/user_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';

Future<void> userUpdate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserUpdate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  BuildUserScolaire user;
  try {
    user = BuildUserScolaire.fromJson(json.decode(await utf8.decodeStream(req)));
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

  UsersScolairesTable usersTable = UsersScolairesTable(database: tinterDatabase.connection);

  await usersTable.update(userScolaire: user);

  Map<String, BuildUserScolaire> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(login: login, year: user.year);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  // TODO: update users scores
//  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);
//  GoutsMusicauxTable goutsMusicauxTable =
//  GoutsMusicauxTable(database: tinterDatabase.connection);
//
//  int numberMaxOfAssociations = (await associationsTable.getAll()).length;
//  int numberMaxOfGoutsMusicaux = (await goutsMusicauxTable.getAll()).length;
//
//  Map<String, RelationScoreScolaire> mapUserToListRelationScoreScolaire =
//  RelationScoreScolaire.getScoreBetweenMultiple(
//      user,
//      [for (String login in mapUserLoginToUsers.keys) mapUserLoginToUsers[login]],
//      numberMaxOfAssociations,
//      numberMaxOfGoutsMusicaux);
//
//  RelationsScoreScolaireTable relationsScoreTable =
//  RelationsScoreScolaireTable(database: tinterDatabase.connection);
//  await relationsScoreTable.updateMultiple(listRelationScoreScolaire: [
//    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScoreScolaire[login]
//  ]);

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
