import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
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
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/shared/user.dart';
import 'package:tinter_backend/secret.dart';

class TinterDatabase {
  var connection = new PostgreSQLConnection(
    MyPostgresDatabase.host,
    MyPostgresDatabase.port,
    MyPostgresDatabase.dbname,
    username: MyPostgresDatabase.user,
    password: MyPostgresDatabase.password,
  );

  Future<void> open() {
    return connection.open();
  }

  Future<void> close() {
    return connection.close();
  }
}

class InvalidResponseToDatabaseQuery implements Exception {
  final String error;

  InvalidResponseToDatabaseQuery({@required this.error});

  @override
  String toString() => '(${this.runtimeType}) $error';
}

class EmptyResponseToDatabaseQuery implements Exception {
  final String error;

  EmptyResponseToDatabaseQuery({@required this.error});

  @override
  String toString() => '(${this.runtimeType}) $error';
}

class UnknownAttributeError implements Exception {
  final String error;

  UnknownAttributeError({@required this.error});

  @override
  String toString() => '(${this.runtimeType}) $error';
}

main() async {
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
  final BinomePairsManagementTable binomePairsManagementTable = BinomePairsManagementTable(database: tinterDatabase.connection);
  final RelationsScoreBinomePairsMatchesTable relationsScoreBinomePairsMatchesTable =
  RelationsScoreBinomePairsMatchesTable(database: tinterDatabase.connection);
  final RelationsStatusBinomePairsMatchesTable relationsStatusBinomePairsMatchesTable =
  RelationsStatusBinomePairsMatchesTable(database: tinterDatabase.connection);

//  // Delete
//  await binomePairsManagementTable.delete();
//  await sessionsTable.delete();
//  await usersManagementTable.delete();
//  await associationsTable.delete();
//  await goutsMusicauxTable.delete();
//  await matieresTable.delete();
//  await relationsStatusAssociatifTable.delete();
//  await relationsScoreAssociatifTable.delete();
//  await relationsStatusScolaireTable.delete();
//  await relationsScoreScolaireTable.delete();
//  await relationsScoreBinomePairsMatchesTable.delete();
//  await relationsStatusBinomePairsMatchesTable.delete();
//
//  // Create;
//  await associationsTable.create();
//  await goutsMusicauxTable.create();
//  await matieresTable.create();
//  await usersManagementTable.create();
//  await relationsStatusAssociatifTable.create();
//  await relationsScoreAssociatifTable.create();
//  await relationsStatusScolaireTable.create();
//  await relationsScoreScolaireTable.create();
//  await sessionsTable.create();
//  await binomePairsManagementTable.create();
//  await relationsScoreBinomePairsMatchesTable.create();
//  await relationsStatusBinomePairsMatchesTable.create();
//
//  // Populate
//  await goutsMusicauxTable.populate();
//  await associationsTable.populate();
//  await matieresTable.populate();
//  await usersManagementTable.populate();
//  await relationsStatusAssociatifTable.populate();
//  await relationsScoreAssociatifTable.populate();
//  await relationsStatusScolaireTable.populate();
//  await relationsScoreScolaireTable.populate();
//  await sessionsTable.populate();
//  await usersManagementTable.update(
//      user: fakeUsers[0].rebuild(
//    (b) => b
//      ..primoEntrant = true
//      ..year = TSPYear.TSP1A,
//  ));
//  await usersManagementTable.update(
//      user: fakeUsers[1].rebuild(
//    (b) => b
//      ..primoEntrant = false
//      ..year = TSPYear.TSP1A,
//  ));
//  await usersManagementTable.update(
//      user: fakeUsers[2].rebuild(
//    (b) => b
//      ..primoEntrant = false
//      ..year = TSPYear.TSP3A,
//  ));
//  await usersManagementTable.update(
//      user: fakeUsers[3].rebuild(
//    (b) => b
//      ..primoEntrant = true
//      ..year = TSPYear.TSP2A,
//  ));
//  await binomePairsManagementTable.populate();

  // Tests
//  await relationsStatusTable.update(
//    relationStatus: RelationStatusAssociatif(
//      login: fakeListRelationStatusAssociatif[0].login,
//      otherLogin: fakeListRelationStatusAssociatif[0].otherLogin,
//      status: EnumRelationStatusAssociatif.ignored,
//    ),
//  );

//  try {
//    await relationsStatusTable.updateMultiple(listRelationStatusAssociatif: [
//      RelationStatusAssociatif(
//        login: fakeStaticStudents[0].login,
//        otherLogin: fakeStaticStudents[1].login,
//        status: EnumRelationStatusAssociatif.askedParrain,
//      ),
//    RelationStatusAssociatif(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[2].login,
//      status: EnumRelationStatusAssociatif.none,
//    ),
//    RelationStatusAssociatif(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[3].login,
//      status: EnumRelationStatusAssociatif.none,
//    ),
//    RelationStatusAssociatif(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[4].login,
//      status: EnumRelationStatusAssociatif.none,
//    ),
//    ]);

//
//  final List<Match> matches = (await matchesTable.getXDiscoverMatchesFromLogin(
//  login: fakeStaticStudents[0].login, limit: 2));
//
//  for (Match match in matches){
//    print('match login: ${match.login}');
//    print('match name: ${match.name}');
//    print('match surname: ${match.surname}');
//    print('match email: ${match.email}');
//    print('match score: ${match.score}');
//    print('match status: ${match.status}');
//    print('match primoEntrant: ${match.primoEntrant}');
//    print('match associations: ${match.associations}');
//    print('match attiranceVieAsso: ${match.attiranceVieAsso}');
//    print('match feteOuCours: ${match.feteOuCours}');
//    print('match aideOuSortir: ${match.aideOuSortir}');
//    print('match organisationEvenements: ${match.organisationEvenements}');
//    print('match goutsMusicaux: ${match.goutsMusicaux}');
//  }

  associationsTable.updateMultiple(associations: allAssociations);

  tinterDatabase.close();
}
