import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/internal_errors.dart';
import 'package:tinter_backend/models/relation_score.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:tinter_backend/models/user.dart';

Future<void> userCreate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserCreate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  User user;
  try {
    user = User.fromJson(jsonDecode(await utf8.decodeStream(req)));
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
    StaticProfileTable staticProfileTable = StaticProfileTable(database: tinterDatabase.connection);
    staticProfileTable.update(staticProfile: StaticStudent.fromJson(user.toJson()));

    await Future.wait([
      userAdd(user, tinterDatabase),
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


Future<void> userAdd(User user, TinterDatabase tinterDatabase) {
  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  return usersTable.add(user: user);
}

Future<void> scoresAdd(User user, TinterDatabase tinterDatabase) async {
  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  Map<String, User> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(login: user.login, primoEntrant: !user.primoEntrant);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);
  GoutsMusicauxTable goutsMusicauxTable =
  GoutsMusicauxTable(database: tinterDatabase.connection);

  int numberMaxOfAssociations = (await associationsTable.getAll()).length;
  int numberMaxOfGoutsMusicaux = (await goutsMusicauxTable.getAll()).length;

  Map<String, RelationScore> mapUserToListRelationScore =
  RelationScore.getScoreBetweenMultiple(
      user,
      [for (String login in mapUserLoginToUsers.keys) mapUserLoginToUsers[login]],
      numberMaxOfAssociations,
      numberMaxOfGoutsMusicaux);

  RelationsScoreTable relationsScoreTable =
  RelationsScoreTable(database: tinterDatabase.connection);
  return relationsScoreTable.addMultiple(listRelationScore: [
    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScore[login]
  ]);
}

Future<void> statusAdd(User user, TinterDatabase tinterDatabase) async {
  RelationsStatusTable relationsStatusTable =
  RelationsStatusTable(database: tinterDatabase.connection);
  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  Map<String, User> otherUsers = await usersTable.getAllExceptOneFromLogin(login: user.login, primoEntrant: !user.primoEntrant);

  return relationsStatusTable.addMultiple(listRelationStatus: [
    for (String otherLogin in otherUsers.keys) ...[
      RelationStatus(
          login: user.login, otherLogin: otherLogin, status: EnumRelationStatus.none),
      RelationStatus(
          login: otherLogin, otherLogin: user.login, status: EnumRelationStatus.none)
    ]
  ]);
}

Future<void> userRemove(String login, TinterDatabase tinterDatabase) {
  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  return usersTable.remove(login: login);
}

Future<void> scoresRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsScoreTable relationsScoreTable =
  RelationsScoreTable(database: tinterDatabase.connection);
  return relationsScoreTable.removeAllFromLogin(login: login);
}

Future<void> statusRemove(String login, TinterDatabase tinterDatabase) async {
  RelationsStatusTable relationsStatusTable =
  RelationsStatusTable(database: tinterDatabase.connection);
  return relationsStatusTable.removeLogin(login: login);
}