import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/user.dart';

Future<void> userUpdate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserUpdate', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  BuildUser user;
  try {
    user = BuildUser.fromJson(jsonDecode(await utf8.decodeStream(req)));
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

  UsersManagementTable usersManagementTable =
      UsersManagementTable(database: tinterDatabase.connection);

  // Save all user info
  try {
    await usersManagementTable.update(user: user);
  } catch (error) {
    throw error;
  }

  // update associative relation score tables
  try {
    // Grab all other users
    Map<String, BuildUser> otherUsers = await usersManagementTable.getAllExceptOneFromLogin(
        login: login, primoEntrant: user.primoEntrant);

    // Get the number of associations and gouts musicaux
    int numberMaxOfAssociations =
        (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
    int numberMaxOfGoutsMusicaux =
        (await GoutsMusicauxTable(database: tinterDatabase.connection).getAll()).length;

    // Get the scores
    Map<String, RelationScoreAssociatif> scores =
        RelationScoreAssociatif.getScoreBetweenMultiple(
            user, otherUsers.values.toList(), numberMaxOfAssociations, numberMaxOfGoutsMusicaux);


    // Update the database with all relevant scores
    RelationsScoreAssociatifTable relationsScoreAssociatifTable =
        RelationsScoreAssociatifTable(database: tinterDatabase.connection);
    await relationsScoreAssociatifTable.updateMultiple(listRelationScoreAssociatif: scores.values.toList());
  } catch (error) {
    throw error;
  }

  // Update scolaire relation score tables
  try {
    // Grab all other users
    Map<String, BuildUser> otherUsersScolaire= await usersManagementTable.getAllExceptOneFromLogin(
        login: login, year: user.year);

    // Get the number of associations and gouts musicaux
    int numberMaxOfAssociations =
        (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
    int numberMaxOfMatieres =
        (await MatieresTable(database: tinterDatabase.connection).getAll()).length;

    // Get the scores
    Map<String, RelationScoreScolaire> scores =
    RelationScoreScolaire.getScoreBetweenMultiple(user, otherUsersScolaire.values.toList(),
        numberMaxOfAssociations, numberMaxOfMatieres);

    // Update the database with all relevant scores
    RelationsScoreScolaireTable relationsScoreScolaireTable =
    RelationsScoreScolaireTable(database: tinterDatabase.connection);
    await relationsScoreScolaireTable.updateMultiple(
        listRelationScoreScolaire: scores.values.toList());

  } catch (error) {
    throw error;
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
