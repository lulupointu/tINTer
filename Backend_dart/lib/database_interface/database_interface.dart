import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/users_horaires_de_travail.dart';
import 'package:tinter_backend/database_interface/scolaire/users_matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/users_scolaire_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/associatif/matches_table.dart';
import 'package:tinter_backend/database_interface/associatif/users_associatifs_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/shared/sessions.dart';
import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
import 'package:tinter_backend/database_interface/shared/user_shared_part_table.dart';
import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:tinter_backend/models/scolaire/user_scolaire.dart';
import 'package:tinter_backend/models/shared/user_shared_part.dart';
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

  final UsersTable usersTable = UsersTable(database: tinterDatabase.connection);
  final AssociationsTable associationsTable =
      AssociationsTable(database: tinterDatabase.connection);
  final GoutsMusicauxTable goutsMusicauxTable =
      GoutsMusicauxTable(database: tinterDatabase.connection);
  final MatieresTable matieresTable = MatieresTable(database: tinterDatabase.connection);
  final UsersAssociationsTable usersAssociationsTable =
      UsersAssociationsTable(database: tinterDatabase.connection);
  final UsersHorairesDeTravailTable usersHorairesDeTravailTable =
      UsersHorairesDeTravailTable(database: tinterDatabase.connection);
  final UsersMatieresTable usersMatieresTable =
      UsersMatieresTable(database: tinterDatabase.connection);
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable =
      UsersGoutsMusicauxTable(database: tinterDatabase.connection);
  final UsersAssociatifsTable usersAssociatifsTable =
      UsersAssociatifsTable(database: tinterDatabase.connection);
  final UsersSharedPartTable usersSharedPartTable =
      UsersSharedPartTable(database: tinterDatabase.connection);
  final UsersScolairesTable usersScolairesTable =
      UsersScolairesTable(database: tinterDatabase.connection);
  final RelationsScoreAssociatifTable relationsScoreTable =
      RelationsScoreAssociatifTable(database: tinterDatabase.connection);
  final RelationsStatusAssociatifTable relationsStatusTable =
      RelationsStatusAssociatifTable(database: tinterDatabase.connection);
  final MatchesTable matchesTable = MatchesTable(database: tinterDatabase.connection);
  final SessionsTable sessionsTable = SessionsTable(database: tinterDatabase.connection);

  // Delete
  await sessionsTable.delete();
  await usersAssociationsTable.delete();
  await usersGoutsMusicauxTable.delete();
  await usersMatieresTable.delete();
  await usersHorairesDeTravailTable.delete();
  await usersTable.delete();
  await associationsTable.delete();
  await goutsMusicauxTable.delete();
  await matieresTable.delete();
  await relationsStatusTable.delete();
  await relationsScoreTable.delete();

  // Create
  await usersTable.create();
  await associationsTable.create();
  await goutsMusicauxTable.create();
  await matieresTable.create();
  await usersAssociationsTable.create();
  await usersGoutsMusicauxTable.create();
  await usersMatieresTable.create();
  await usersHorairesDeTravailTable.create();
  await relationsStatusTable.create();
  await relationsScoreTable.create();
  await sessionsTable.create();

  // Populate
  await goutsMusicauxTable.populate();
  await associationsTable.populate();
  await matieresTable.populate();
  await usersSharedPartTable.populate();
  await relationsStatusTable.populate();
  await relationsScoreTable.populate();
  await sessionsTable.populate();
  await usersTable.update(userJson: {
    'login': fakeUsersSharedPart[0].login,
    'primoEntrant': true,
  });
  await usersTable.update(userJson: {
    'login': fakeUsersSharedPart[1].login,
    'primoEntrant': true,
  });
  await usersTable.update(userJson: {
    'login': fakeUsersSharedPart[2].login,
    'primoEntrant': false,
  });
  await usersTable.update(userJson: {
    'login': fakeUsersSharedPart[3].login,
    'primoEntrant': true,
  });
  await usersTable.update(userJson: {
    'login': fakeUsersSharedPart[4].login,
    'primoEntrant': false,
  });
  await usersAssociatifsTable.populate();
  await usersScolairesTable.populate();

  // Tests
  print(await usersScolairesTable.getAllExceptOneFromLogin(
      login: fakeUsersScolaires[0].login, year: TSPYear.TSP3A));
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

  tinterDatabase.close();
}
