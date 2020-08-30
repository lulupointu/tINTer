import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/shared/user.dart';

Future<void> userCreate(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('UserCreate', segments);

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

  // Save all user info
  UsersManagementTable usersManagementTable =
      UsersManagementTable(database: tinterDatabase.connection);
  try {
    await usersManagementTable.update(user: user);
  } catch (error) {
    throw error;
  }

  // Create associative relation (score and status) tables
  try {
    // Grab all other users
    Map<String, BuildUser> otherUsersAssociatif = await usersManagementTable.getAllExceptOneFromLogin(
        login: login, primoEntrant: user.primoEntrant);

    // Get the number of associations and gouts musicaux
    int numberMaxOfAssociations =
        (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
    int numberMaxOfGoutsMusicaux =
        (await GoutsMusicauxTable(database: tinterDatabase.connection).getAll()).length;

    // Get the scores
    Map<String, RelationScoreAssociatif> scores =
        RelationScoreAssociatif.getScoreBetweenMultiple(user, otherUsersAssociatif.values.toList(),
            numberMaxOfAssociations, numberMaxOfGoutsMusicaux);

    // Update the database with all relevant scores
    RelationsScoreAssociatifTable relationsScoreAssociatifTable =
        RelationsScoreAssociatifTable(database: tinterDatabase.connection);
    await relationsScoreAssociatifTable.addMultiple(
        listRelationScoreAssociatif: scores.values.toList());

    // Update the database with status none
    RelationsStatusAssociatifTable relationsStatusAssociatifTable =
        RelationsStatusAssociatifTable(database: tinterDatabase.connection);
    await relationsStatusAssociatifTable.addMultiple(listRelationStatusAssociatif: [
      for (String otherLogin in otherUsersAssociatif.keys) ...[
        RelationStatusAssociatif((b) => b
          ..login = login
          ..otherLogin = otherLogin
          ..status = EnumRelationStatusAssociatif.none),
        RelationStatusAssociatif((b) => b
          ..login = otherLogin
          ..otherLogin = login
          ..status = EnumRelationStatusAssociatif.none)
      ]
    ]);
  } catch (error) {
    throw InternalDatabaseError(error);
  }


  // Create scolaire relation (score and status) tables
  try {
    // Grab all other users
    Map<String, BuildUser> otherUsersScolaire= await usersManagementTable.getAllExceptOneFromLogin(
        login: login, year: user.year, school: School.TSP);

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
    await relationsScoreScolaireTable.addMultiple(
        listRelationScoreScolaire: scores.values.toList());

    // Update the database with status none
    RelationsStatusScolaireTable relationsStatusScolaireTable =
    RelationsStatusScolaireTable(database: tinterDatabase.connection);
    await relationsStatusScolaireTable.addMultiple(listRelationStatusScolaire: [
      for (String otherLogin in otherUsersScolaire.keys) ...[
        RelationStatusScolaire((b) => b
          ..login = login
          ..otherLogin = otherLogin
          ..statusScolaire = EnumRelationStatusScolaire.none),
        RelationStatusScolaire((b) => b
          ..login = otherLogin
          ..otherLogin = login
          ..statusScolaire = EnumRelationStatusScolaire.none)
      ]
    ]);
  } catch (error) {
    throw InternalDatabaseError(error);
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
