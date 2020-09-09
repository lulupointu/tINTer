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
    removingFalseRelationsAssociatif(),
  ]);
}

Future<void> removingFalseRelationsAssociatif() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final UsersManagementTable usersManagementTable =
  UsersManagementTable(database: tinterDatabase.connection);
  final RelationsScoreAssociatifTable relationsScoreAssociatifTable =
  RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  final RelationsStatusAssociatifTable relationsStatusAssociatifTable =
  RelationsStatusAssociatifTable(database: tinterDatabase.connection);

  Map<String, BuildUser> allUsersPrimoEntrant = await usersManagementTable.getAll(primoEntrant: false);
  Map<String, BuildUser> allUsersNotPrimoEntrant = await usersManagementTable.getAll(primoEntrant: true);

  print('Removing false relations users associatifs primoEntrant');
  for (BuildUser user in allUsersPrimoEntrant.values) {
    try {
      Map<String,
          RelationStatusAssociatif> relationsAssociatif = await relationsStatusAssociatifTable
          .getAllFromLogin(login: user.login);
      List<RelationStatusAssociatif> falseRelationsAssociatif = relationsAssociatif.values.where((RelationStatusAssociatif relationStatusAssociatif) =>
      allUsersPrimoEntrant.containsKey(relationStatusAssociatif.otherLogin)
      ).toList();

      print('${user.login} is having false relation with ${falseRelationsAssociatif.map((RelationStatusAssociatif relationStatusAssociatif) => relationStatusAssociatif.otherLogin).toList()}');

      relationsStatusAssociatifTable.removeMultiple(listRelationStatusAssociatif: falseRelationsAssociatif);
    } catch (e) {
      print('Error with user ${user.login}: $e');
    }
  }


  print('Removing false relations users associatifs not primoEntrant');
  for (BuildUser user in allUsersNotPrimoEntrant.values) {
    try {
      Map<String,
          RelationStatusAssociatif> relationsAssociatif = await relationsStatusAssociatifTable
          .getAllFromLogin(login: user.login);
      List<RelationStatusAssociatif> falseRelationsAssociatif = relationsAssociatif.values.where((RelationStatusAssociatif relationStatusAssociatif) =>
          allUsersNotPrimoEntrant.containsKey(relationStatusAssociatif.otherLogin)
      ).toList();

      print('${user.login} is having false relation with ${falseRelationsAssociatif.map((RelationStatusAssociatif relationStatusAssociatif) => relationStatusAssociatif.otherLogin).toList()}');

      relationsStatusAssociatifTable.removeMultiple(listRelationStatusAssociatif: falseRelationsAssociatif);
    } catch (e) {
      print('Error with user ${user.login}: $e');
    }
  }

  tinterDatabase.close();
}