import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';

Future<void> userCreate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserCreate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  BuildUserAssociatif user;
  try {
    user = BuildUserAssociatif.fromJson(jsonDecode(await utf8.decodeStream(req)));
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
    UsersAssociatifsTable usersAssociatifsTable =
        UsersAssociatifsTable(database: tinterDatabase.connection);
    usersAssociatifsTable.update(userAssociatif: user);

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

Future<void> scoresAdd(UserAssociatif user, TinterDatabase tinterDatabase) async {
  UsersAssociatifsTable usersTable =
      UsersAssociatifsTable(database: tinterDatabase.connection);

  Map<String, UserAssociatif> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(
        login: user.login, primoEntrant: user.primoEntrant);
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
  return relationsScoreTable.addMultiple(listRelationScoreAssociatif: [
    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScoreAssociatif[login]
  ]);
}

Future<void> statusAdd(UserAssociatif user, TinterDatabase tinterDatabase) async {
  RelationsStatusAssociatifTable relationsStatusTable =
      RelationsStatusAssociatifTable(database: tinterDatabase.connection);
  UsersAssociatifsTable usersTable =
      UsersAssociatifsTable(database: tinterDatabase.connection);

  Map<String, BuildUserAssociatif> otherUsers = await usersTable.getAllExceptOneFromLogin(
      login: user.login, primoEntrant: user.primoEntrant);

  return relationsStatusTable.addMultiple(listRelationStatusAssociatif: [
    for (String otherLogin in otherUsers.keys) ...[
      RelationStatusAssociatif((b) => b
        ..login = user.login
        ..otherLogin = otherLogin
        ..status = EnumRelationStatusAssociatif.none),
      RelationStatusAssociatif((b) => b
        ..login = otherLogin
        ..otherLogin = user.login
        ..status = EnumRelationStatusAssociatif.none)
    ]
  ]);
}

Future<void> userRemove(String login, TinterDatabase tinterDatabase) {
  UsersAssociatifsTable usersTable =
      UsersAssociatifsTable(database: tinterDatabase.connection);

  return usersTable.removeFromLogin(login);
}

Future<void> scoresRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsScoreAssociatifTable relationsScoreTable =
      RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  return relationsScoreTable.removeAllFromLogin(login: login);
}

Future<void> statusRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsStatusAssociatifTable relationsStatusTable =
      RelationsStatusAssociatifTable(database: tinterDatabase.connection);
  return relationsStatusTable.removeLogin(login: login);
}
