import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/matches_table.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/database_interface/sessions.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/database_interface/users_associations_table.dart';
import 'package:tinter_backend/database_interface/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:tinter_backend/models/user.dart';
import 'package:tinter_backend/secret.dart';
import 'package:tinter_backend/models/match.dart';

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

  final StaticProfileTable staticProfileTable =
      StaticProfileTable(database: tinterDatabase.connection);
  final AssociationsTable associationsTable =
      AssociationsTable(database: tinterDatabase.connection);
  final GoutsMusicauxTable goutsMusicauxTable =
      GoutsMusicauxTable(database: tinterDatabase.connection);
  final UsersAssociationsTable usersAssociationsTable =
      UsersAssociationsTable(database: tinterDatabase.connection);
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable =
      UsersGoutsMusicauxTable(database: tinterDatabase.connection);
  final UsersTable usersTable = UsersTable(database: tinterDatabase.connection);
  final RelationsScoreTable relationsScoreTable =
      RelationsScoreTable(database: tinterDatabase.connection);
  final RelationsStatusTable relationsStatusTable =
      RelationsStatusTable(database: tinterDatabase.connection);
  final MatchesTable matchesTable = MatchesTable(database: tinterDatabase.connection);
  final SessionsTable sessionsTable = SessionsTable(database: tinterDatabase.connection);

  // Delete
  await sessionsTable.delete();
  await usersAssociationsTable.delete();
  await usersGoutsMusicauxTable.delete();
  await usersTable.delete();
  await associationsTable.delete();
  await goutsMusicauxTable.delete();
  await relationsStatusTable.delete();
  await relationsScoreTable.delete();
  await staticProfileTable.delete();

  // Create
  await staticProfileTable.create();
  await associationsTable.create();
  await goutsMusicauxTable.create();
  await usersAssociationsTable.create();
  await usersGoutsMusicauxTable.create();
  await usersTable.create();
  await relationsStatusTable.create();
  await relationsScoreTable.create();
  await sessionsTable.create();

  // Populate
  await staticProfileTable.populate();
  await goutsMusicauxTable.populate();
  await associationsTable.populate();
  await usersTable.populate();
  await relationsStatusTable.populate();
  await relationsScoreTable.populate();
  await sessionsTable.populate();  await staticProfileTable.updateMultiple(staticProfiles: [
    StaticStudent(
      login: fakeStaticStudents[0].login,
      name: fakeStaticStudents[0].name,
      surname: fakeStaticStudents[0].surname,
      email: fakeStaticStudents[0].email,
      primoEntrant: false,
    ),
    StaticStudent(
      login: fakeStaticStudents[1].login,
      name: fakeStaticStudents[1].name,
      surname: fakeStaticStudents[1].surname,
      email: fakeStaticStudents[1].email,
      primoEntrant: true,
    ),
    StaticStudent(
      login: fakeStaticStudents[2].login,
      name: fakeStaticStudents[2].name,
      surname: fakeStaticStudents[2].surname,
      email: fakeStaticStudents[2].email,
      primoEntrant: true,
    ),
    StaticStudent(
      login: fakeStaticStudents[3].login,
      name: fakeStaticStudents[3].name,
      surname: fakeStaticStudents[3].surname,
      email: fakeStaticStudents[3].email,
      primoEntrant: true,
    ),
    StaticStudent(
      login: fakeStaticStudents[4].login,
      name: fakeStaticStudents[4].name,
      surname: fakeStaticStudents[4].surname,
      email: fakeStaticStudents[4].email,
      primoEntrant: true,
    )
  ]);

  // Tests
//  await relationsStatusTable.update(
//    relationStatus: RelationStatus(
//      login: fakeListRelationStatus[0].login,
//      otherLogin: fakeListRelationStatus[0].otherLogin,
//      status: EnumRelationStatus.ignored,
//    ),
//  );

//  try {
//    await relationsStatusTable.updateMultiple(listRelationStatus: [
//      RelationStatus(
//        login: fakeStaticStudents[0].login,
//        otherLogin: fakeStaticStudents[1].login,
//        status: EnumRelationStatus.askedParrain,
//      ),
//    RelationStatus(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[2].login,
//      status: EnumRelationStatus.none,
//    ),
//    RelationStatus(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[3].login,
//      status: EnumRelationStatus.none,
//    ),
//    RelationStatus(
//      login: fakeStaticStudents[0].login,
//      otherLogin: fakeStaticStudents[4].login,
//      status: EnumRelationStatus.none,
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
