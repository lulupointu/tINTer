import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';
import 'package:tinter_backend/models/internal_errors.dart';
import 'package:tinter_backend/models/relation_score.dart';
import 'package:tinter_backend/models/user.dart';

Future<void> userUpdate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserUpdate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  User user;
  try {
    user = User.fromJson(json.decode(await utf8.decodeStream(req)));
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

  UsersTable usersTable = UsersTable(database: tinterDatabase.connection);

  await usersTable.update(user: user);

  Map<String, User> mapUserLoginToUsers;
  try {
    mapUserLoginToUsers = await usersTable.getAllExceptOneFromLogin(login: login);
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
  await relationsScoreTable.updateMultiple(listRelationScore: [
    for (String login in mapUserLoginToUsers.keys) mapUserToListRelationScore[login]
  ]);

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
