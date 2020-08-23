import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/users_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/scolaire/user_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';

Future<void> userCreate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserCreate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  BuildUserScolaire user;
  try {
    user = BuildUserScolaire.fromJson(jsonDecode(await utf8.decodeStream(req)));
  } catch (error) {
    throw InvalidQueryParameterError(error, false);
  }

  if (user.login != login) {
    throw InvalidQueryParameterError(
        'The given user has a different login than the one associated with the given token.',
        true);
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  try {
    // First update primoEntrant
    UsersTable usersTable = UsersTable(database: tinterDatabase.connection);
    usersTable.update(userJson: user.toJson());

    await Future.wait([
      scoresAdd(user, tinterDatabase),
      statusAdd(user, tinterDatabase),
    ]);
  } catch (error) {
    await Future.wait([
      userRemove(user.login, tinterDatabase),
      scoresRemove(user.login, tinterDatabase),
      statusRemove(user.login, tinterDatabase),
    ]);
    throw error;
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}


Future<void> scoresAdd(BuildUserScolaire user, TinterDatabase tinterDatabase) async {
  UsersScolairesTable usersTable = UsersScolairesTable(database: tinterDatabase.connection);

  Map<String, BuildUserScolaire> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(login: user.login, year: user.year);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);
  GoutsMusicauxTable goutsMusicauxTable =
  GoutsMusicauxTable(database: tinterDatabase.connection);

  int numberMaxOfAssociations = (await associationsTable.getAll()).length;
  int numberMaxOfGoutsMusicaux = (await goutsMusicauxTable.getAll()).length;

//  Map<String, RelationScoreScolaire> mapUserToListRelationScoreScolaire =
//  RelationScoreScolaire.getScoreBetweenMultiple(
//      user,
//      [for (String login in mapUserLoginToUsers.keys) mapUserLoginToUsers[login]],
//      numberMaxOfAssociations,
//      numberMaxOfGoutsMusicaux);
//
//  RelationsScoreScolaireTable relationsScoreTable =
//  RelationsScoreScolaireTable(database: tinterDatabase.connection);
//  return relationsScoreTable.addMultiple(listRelationScoreScolaire: [
//    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScoreScolaire[login]
//  ]);
}

Future<void> statusAdd(BuildUserScolaire user, TinterDatabase tinterDatabase) async {
  RelationsStatusScolaireTable relationsStatusTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);
  UsersScolairesTable usersTable = UsersScolairesTable(database: tinterDatabase.connection);

  Map<String, BuildUserScolaire> otherUsers = await usersTable.getAllExceptOneFromLogin(login: user.login, year: user.year);

  return relationsStatusTable.addMultiple(listRelationStatusScolaire: [
    for (String otherLogin in otherUsers.keys) ...[
      RelationStatusScolaire(
          login: user.login, otherLogin: otherLogin, status: EnumRelationStatusScolaire.none),
      RelationStatusScolaire(
          login: otherLogin, otherLogin: user.login, status: EnumRelationStatusScolaire.none)
    ]
  ]);
}

Future<void> userRemove(String login, TinterDatabase tinterDatabase) {
  UsersScolairesTable usersTable = UsersScolairesTable(database: tinterDatabase.connection);

  return usersTable.removeFromLogin(login);
}

Future<void> scoresRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsScoreScolaireTable relationsScoreTable =
  RelationsScoreScolaireTable(database: tinterDatabase.connection);
  return relationsScoreTable.removeAllFromLogin(login: login);
}

Future<void> statusRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsStatusScolaireTable relationsStatusTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);
  return relationsStatusTable.removeLogin(login: login);
}