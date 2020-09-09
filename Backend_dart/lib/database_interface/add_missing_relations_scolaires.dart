import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/user.dart';

main() async {
  Future.wait([
    addMissingScolaire(),
    addMissingAssociatif(),
  ]);
}

Future<void> addMissingScolaire() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final UsersManagementTable usersManagementTable =
  UsersManagementTable(database: tinterDatabase.connection);
  final RelationsStatusScolaireTable relationsStatusScolaireTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);

  Map<String, BuildUser> allUsers = await usersManagementTable.getAll(year: TSPYear.TSP1A, school: School.TSP);
  print('Adding missing users scolaire');
  for (BuildUser user in allUsers.values) {
    try {
      Map<String,
          RelationStatusScolaire> relationScolaires = await relationsStatusScolaireTable
          .getAllFromLogin(login: user.login);
      List<BuildUser> otherUsersScolaireMissing = allUsers.values.where((BuildUser otherUser) =>
      otherUser != user && !relationScolaires.keys.contains(otherUser.login)).toList();

      print('${user.login} is missing ${otherUsersScolaireMissing.map((BuildUser user) => user.login).toList()}');


      // Get the number of associations and gouts musicaux
      int numberMaxOfAssociations =
          (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
      int numberMaxOfMatieres =
          (await MatieresTable(database: tinterDatabase.connection).getAll()).length;

      // Get the scores
      Map<String, RelationScoreScolaire> scores =
      RelationScoreScolaire.getScoreBetweenMultiple(user, otherUsersScolaireMissing,
          numberMaxOfAssociations, numberMaxOfMatieres);

      // Update the database with all relevant scores
      RelationsScoreScolaireTable relationsScoreScolaireTable =
      RelationsScoreScolaireTable(database: tinterDatabase.connection);
      await relationsScoreScolaireTable.addMultiple(
          listRelationScoreScolaire: scores.values.toList());

      // Update the database with status none
      await relationsStatusScolaireTable.addMultiple(listRelationStatusScolaire: [
        for (String otherLogin in otherUsersScolaireMissing.map((BuildUser user) => user.login).toList()) ...[
          RelationStatusScolaire((b) => b
            ..login = user.login
            ..otherLogin = otherLogin
            ..statusScolaire = EnumRelationStatusScolaire.none),
          RelationStatusScolaire((b) => b
            ..login = otherLogin
            ..otherLogin = user.login
            ..statusScolaire = EnumRelationStatusScolaire.none)
        ]
      ]);
    } catch (e) {
      print('Error with user ${user.login}: $e');
    }
  }

  tinterDatabase.close();
}

Future<void> addMissingAssociatif() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final UsersManagementTable usersManagementTable =
  UsersManagementTable(database: tinterDatabase.connection);
  final RelationsScoreAssociatifTable relationsScoreAssociatifTable =
  RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  final RelationsStatusAssociatifTable relationsStatusAssociatifTable =
  RelationsStatusAssociatifTable(database: tinterDatabase.connection);

  Map<String, BuildUser> allUsersPrimoEntrant = await usersManagementTable.getAll(primoEntrant: false);
  print('Adding missing users associatifs primoEntrant');
  for (BuildUser user in allUsersPrimoEntrant.values) {
    try {
      Map<String,
          RelationStatusAssociatif> relationsAssociatif = await relationsStatusAssociatifTable
          .getAllFromLogin(login: user.login);
      List<BuildUser> otherUsersAssociatifMissing = allUsersPrimoEntrant.values.where((BuildUser otherUser) =>
      otherUser != user && !relationsAssociatif.keys.contains(otherUser.login)).toList();

      print('${user.login} is missing ${otherUsersAssociatifMissing.map((BuildUser user) => user.login).toList()}');

      // Get the number of associations and gouts musicaux
      int numberMaxOfAssociations =
          (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
      int numberMaxOfGoutsMusicaux =
          (await GoutsMusicauxTable(database: tinterDatabase.connection).getAll()).length;

      // Get the scores
      Map<String, RelationScoreAssociatif> scores =
      RelationScoreAssociatif.getScoreBetweenMultiple(user, otherUsersAssociatifMissing,
          numberMaxOfAssociations, numberMaxOfGoutsMusicaux);

      // Update the database with all relevant scores
      await relationsScoreAssociatifTable.addMultiple(
          listRelationScoreAssociatif: scores.values.toList());

      // Update the database with status none
      await relationsStatusAssociatifTable.addMultiple(listRelationStatusAssociatif: [
        for (String otherLogin in otherUsersAssociatifMissing.map((BuildUser user) => user.login).toList()) ...[
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

    } catch (e) {
      print('Error with user ${user.login}: $e');
    }
  }


  Map<String, BuildUser> allUsersNotPrimoEntrant = await usersManagementTable.getAll(primoEntrant: true);
  print('Adding missing users associatifs not primoEntrant');
  for (BuildUser user in allUsersNotPrimoEntrant.values) {
    try {
      Map<String,
          RelationStatusAssociatif> relationsAssociatif = await relationsStatusAssociatifTable
          .getAllFromLogin(login: user.login);
      List<BuildUser> otherUsersAssociatifMissing = allUsersNotPrimoEntrant.values.where((BuildUser otherUser) =>
      otherUser != user && !relationsAssociatif.keys.contains(otherUser.login)).toList();

      print('${user.login} is missing ${otherUsersAssociatifMissing.map((BuildUser user) => user.login).toList()}');

      // Get the number of associations and gouts musicaux
      int numberMaxOfAssociations =
          (await AssociationsTable(database: tinterDatabase.connection).getAll()).length;
      int numberMaxOfGoutsMusicaux =
          (await GoutsMusicauxTable(database: tinterDatabase.connection).getAll()).length;

      // Get the scores
      Map<String, RelationScoreAssociatif> scores =
      RelationScoreAssociatif.getScoreBetweenMultiple(user, otherUsersAssociatifMissing,
          numberMaxOfAssociations, numberMaxOfGoutsMusicaux);

      // Update the database with all relevant scores
      await relationsScoreAssociatifTable.addMultiple(
          listRelationScoreAssociatif: scores.values.toList());

      // Update the database with status none
      await relationsStatusAssociatifTable.addMultiple(listRelationStatusAssociatif: [
        for (String otherLogin in otherUsersAssociatifMissing.map((BuildUser user) => user.login).toList()) ...[
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

    } catch (e) {
      print('Error with user ${user.login}: $e');
    }
  }

  tinterDatabase.close();
}