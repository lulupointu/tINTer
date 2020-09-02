import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_score_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/binome/binome.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_score_binome_pair.dart';
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

  // If user is part of binome pair, update this as well
  BinomePairsProfilesTable binomePairsProfilesTable = BinomePairsProfilesTable(database: tinterDatabase.connection);
  if (await binomePairsProfilesTable.isKnownFromLogin(login: login)) {
    // Get the other login
    String otherLogin = await binomePairsProfilesTable.getOtherLoginFromLogin(login: login);

    // Get the otherLogin profile
    UsersManagementTable usersManagementTable = UsersManagementTable(database: tinterDatabase.connection);
    BuildUser otherUser = await usersManagementTable.getFromLogin(login: otherLogin);

    // Get the binomePair from the two users
    BuildBinomePair binomePair = BuildBinomePair.getFromUsers(user, otherUser);

    // Get the binome pair id
    int binomePairId = await binomePairsProfilesTable.getBinomePairIdFromLogin(login: login);

    // Add the binome pair id to the binome pair
    binomePair = binomePair.rebuild((b) => b..binomePairId = binomePairId);

    // Update the binomePair
    BinomePairsManagementTable binomePairsManagementTable = BinomePairsManagementTable(database: tinterDatabase.connection);
    await binomePairsManagementTable.update(binomePair: binomePair);


    // Update scolaire relation score tables

    // Grab all other binomePair
    Map<int, BuildBinomePair> otherBinomePairs = await binomePairsManagementTable.getAllExceptOneFromLogin(
        login: login);

    // Get the number of associations and gouts musicaux
    int numberMaxOfAssociations =
        (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
    int numberMaxOfMatieres =
        (await MatieresTable(database: tinterDatabase.connection).getAll()).length;

    // Get the scores
    Map<int, RelationScoreBinomePair> scores =
    RelationScoreBinomePair.getScoreBetweenMultiple(binomePair, otherBinomePairs.values.toList(),
        numberMaxOfAssociations, numberMaxOfMatieres);

    // Update the database with all relevant scores
    RelationsScoreBinomePairsMatchesTable relationsStatusBinomePairsMatchesTable =
    RelationsScoreBinomePairsMatchesTable(database: tinterDatabase.connection);
    await relationsStatusBinomePairsMatchesTable.updateMultiple(
        listRelationScoreBinomePair: scores.values.toList());
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}
