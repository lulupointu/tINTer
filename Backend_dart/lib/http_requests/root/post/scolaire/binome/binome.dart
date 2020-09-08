import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_score_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_score_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:postgres/src/connection.dart';
import 'package:tinter_backend/models/shared/internal_errors.dart';
import 'package:tinter_backend/models/shared/user.dart';
import 'package:built_collection/built_collection.dart';


Future<void> binomeUpdateRelationStatusScolaire(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('BinomeUpdateRelationStatusScolaire', segments);

  if (segments.length != 0) {
    throw UnknownRequestedPathError(req.uri.path);
  }

  RelationStatusScolaire relationStatus;
  try {
    Map<String, dynamic> relationStatusJson = jsonDecode(await utf8.decodeStream(req));
    relationStatusJson['login'] = login;
    relationStatus = RelationStatusScolaire.fromJson(relationStatusJson);
  } catch(error) {
    throw error;
  }

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  RelationsStatusScolaireTable relationsStatusTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);

  try {
    await relationsStatusTable.update(relationStatus: relationStatus);
  } on PostgreSQLException catch (error) {
    // Error 22023 is the error intentionally emitted when a
    // change from one status to another is not possible.
    if (error.code == 22023) {
      await tinterDatabase.close();
      throw InvalidQueryParameterError(error.message, true);
    } else {
      await tinterDatabase.close();
      throw InternalDatabaseError(error);
    }
  }

  // If the updated situation lead to having a binome
  // We start the search for a binome of binome.
  try {
    if (relationStatus.statusScolaire == EnumRelationStatusScolaire.acceptedBinome) {
      await setupBinomeOfBinomeTables(
          database: tinterDatabase.connection, relationStatusScolaire: relationStatus);
    }
  } catch(error) {
    print(error);
    await tinterDatabase.close();
    throw InternalDatabaseError(error);
  }

  await req.response
    ..statusCode = HttpStatus.ok
    ..close();

  await tinterDatabase.close();
}

Future<void> setupBinomeOfBinomeTables({@required PostgreSQLConnection database, @required RelationStatusScolaire relationStatusScolaire}) async {
  // Get the users composing the binome
  UsersManagementTable usersManagementTable = UsersManagementTable(database: database);
  Map<String, BuildUser> users = await usersManagementTable.getMultipleFromLogins(logins: [relationStatusScolaire.login, relationStatusScolaire.otherLogin]);
  print("Got both users $users");

  // Calculate the BinomePair profile
  // It is a union and intersection of the attributes
  // of the two user composing the binome
  BuildBinomePair binomePair = BuildBinomePair.getFromUsers(users.values.toList()[0], users.values.toList()[1]);
  print("Got binome pair from binome");


  BinomePairsManagementTable binomePairsManagementTable = BinomePairsManagementTable(database: database);

  // Save the binome pair to its table
  await binomePairsManagementTable.add(binomePair: binomePair);
  print("Save the binome pair to its table");

  // Get the binome pair id
  BinomePairsProfilesTable binomePairsProfilesTable = BinomePairsProfilesTable(database: database);
  int binomePairId = await binomePairsProfilesTable.getBinomePairIdFromLogin(login: relationStatusScolaire.login);
  print("Get the binome pair id");

  // Add the binome pair id to the binome pair
  binomePair = binomePair.rebuild((b) => b..binomePairId = binomePairId);
  print("Add the binome pair id to the binome pair");

  // Grab all other binome paire
  Map<int, BuildBinomePair> otherBinomePairs= await binomePairsManagementTable.getAllExceptOneFromLogin(
      login: relationStatusScolaire.login);
  print("Grab all other binome paire");

  // Get the number of associations and matieres
  int numberMaxOfAssociations =
      (await AssociationsTable(database: database).getAll()).length;
  int numberMaxOfMatieres =
      (await MatieresTable(database: database).getAll()).length;
  print('Get the number of associations and matieres');

  // Get the scores
  Map<int, RelationScoreBinomePair> scores =
  RelationScoreBinomePair.getScoreBetweenMultiple(binomePair, otherBinomePairs.values.toList(),
      numberMaxOfAssociations, numberMaxOfMatieres);
  print('Get the scores');

  // Update the database with all relevant scores
  RelationsScoreBinomePairsMatchesTable relationsScoreScolaireTable =
  RelationsScoreBinomePairsMatchesTable(database: database);
  await relationsScoreScolaireTable.addMultiple(
      listRelationScoreBinomePair: scores.values.toList());
  print('Update the database with all relevant scores');

  // Update the database with status none
  RelationsStatusBinomePairsMatchesTable relationsStatusScolaireTable =
  RelationsStatusBinomePairsMatchesTable(database: database);
  await relationsStatusScolaireTable.addMultiple(listRelationStatusBinomePair: [
    for (int otherBinomePairId in otherBinomePairs.keys) ...[
      RelationStatusBinomePair((b) => b
        ..binomePairId = binomePairId
        ..otherBinomePairId = otherBinomePairId
        ..status = EnumRelationStatusBinomePair.none),
      RelationStatusBinomePair((b) => b
        ..binomePairId = otherBinomePairId
        ..otherBinomePairId = binomePairId
        ..status = EnumRelationStatusBinomePair.none),
    ]
  ]);
  print("Update the database with status none");

}

