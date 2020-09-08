import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_score_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/matches_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/shared/sessions.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/scolaire/relation_score_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_score_scolaire.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/user.dart';
import 'package:tinter_backend/secret.dart';

Future<void> main() async {
  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final UsersManagementTable usersManagementTable =
  UsersManagementTable(database: tinterDatabase.connection);
  final AssociationsTable associationsTable =
  AssociationsTable(database: tinterDatabase.connection);
  final GoutsMusicauxTable goutsMusicauxTable =
  GoutsMusicauxTable(database: tinterDatabase.connection);
  final MatieresTable matieresTable = MatieresTable(database: tinterDatabase.connection);
  final RelationsScoreAssociatifTable relationsScoreAssociatifTable =
  RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  final RelationsStatusAssociatifTable relationsStatusAssociatifTable =
  RelationsStatusAssociatifTable(database: tinterDatabase.connection);
  final RelationsScoreScolaireTable relationsScoreScolaireTable =
  RelationsScoreScolaireTable(database: tinterDatabase.connection);
  final RelationsStatusScolaireTable relationsStatusScolaireTable =
  RelationsStatusScolaireTable(database: tinterDatabase.connection);
  final MatchesTable matchesTable = MatchesTable(database: tinterDatabase.connection);
  final SessionsTable sessionsTable = SessionsTable(database: tinterDatabase.connection);
  final BinomePairsManagementTable binomePairsManagementTable = BinomePairsManagementTable(
      database: tinterDatabase.connection);
  final RelationsScoreBinomePairsMatchesTable relationsScoreBinomePairsMatchesTable =
  RelationsScoreBinomePairsMatchesTable(database: tinterDatabase.connection);
  final RelationsStatusBinomePairsMatchesTable relationsStatusBinomePairsMatchesTable =
  RelationsStatusBinomePairsMatchesTable(database: tinterDatabase.connection);

  Map<String, BuildUser> allUsers = await usersManagementTable.getAll(year: TSPYear.TSP1A, school: School.TSP);
  for (BuildUser user in allUsers.values) {
    try {
      Map<String,
          RelationStatusScolaire> relationScolaires = await relationsStatusScolaireTable
          .getAllFromLogin(login: user.login);
      List<BuildUser> otherUsersScolaireMissing = allUsers.values.where((BuildUser otherUser) =>
      otherUser != user && !relationScolaires.keys.contains(otherUser.login)).toList();


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