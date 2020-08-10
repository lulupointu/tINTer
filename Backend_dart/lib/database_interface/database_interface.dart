import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/database_interface/users_associations_table.dart';
import 'package:tinter_backend/database_interface/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:tinter_backend/models/school_name.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:tinter_backend/models/user.dart';
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

class ProfilesTable {
  final String name = 'profiles';
  final PostgreSQLConnection database;

  ProfilesTable({@required this.database});

  Future<void> createTable() async {
    final String query = """
    CREATE TABLE Employees (
      login Text PRIMARY KEY,
      name VARCHAR (100) NOT NULL,
      surname VARCHAR (100) NOT NULL,
      email VARCHAR (100) NOT NULL,
      school SCHOOL NOT NULL,
      primoEntrant BOOLEAN NOT NULL,
      associations ASSOCIATION [] NOT NULL,
    );
    """;

    await createTypes();

    return database
        .query(query, substitutionValues: {"TSP": SchoolName.TSP, "IMTBS": SchoolName.IMTBS});
  }

  Future<void> createTypes() async {
    String createSchoolTypeQuery = """
        CREATE TYPE SCHOOL AS ENUM (@TSP, @IMTBS);
    """;

    var futures = <Future>[
      database.query(createSchoolTypeQuery,
          substitutionValues: {"TSP": SchoolName.TSP, "IMTBS": SchoolName.IMTBS}),
    ];

    return Future.wait(futures);
  }
}

class SessionsTable {
  final String name = 'sessions';
  final PostgreSQLConnection database;

  SessionsTable({@required this.database});
}

class RelationsTable {
  final String name = 'relations';
  final PostgreSQLConnection database;

  RelationsTable({@required this.database});
}

class InvalidResponseToDatabaseQuery implements Exception {
  final String error;

  InvalidResponseToDatabaseQuery({@required this.error});
}

class EmptyResponseToDatabaseQuery implements Exception {
  final String error;

  EmptyResponseToDatabaseQuery({@required this.error});
}

class UnknownAttributeError implements Exception {
  final String error;

  UnknownAttributeError({@required this.error});
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
  final UsersAssociationsTable usersAssociationsTable = UsersAssociationsTable(
      database: tinterDatabase.connection, associationsTable: associationsTable);
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable = UsersGoutsMusicauxTable(
      database: tinterDatabase.connection, goutsMusicauxTable: goutsMusicauxTable);
  final UsersTable usersTable = UsersTable(
      database: tinterDatabase.connection,
      staticProfileTable: staticProfileTable,
      usersGoutsMusicauxTable: usersGoutsMusicauxTable,
      usersAssociationsTable: usersAssociationsTable);

  // Delete
  await usersAssociationsTable.delete();
  await usersGoutsMusicauxTable.delete();
  await usersTable.delete();
  await associationsTable.delete();
  await goutsMusicauxTable.delete();
  await staticProfileTable.delete();

  // Create
  await staticProfileTable.create();
  await associationsTable.create();
  await goutsMusicauxTable.create();
  await usersAssociationsTable.create();
  await usersGoutsMusicauxTable.create();
  await usersTable.create();

  // Populate
  await staticProfileTable.populate();
  await goutsMusicauxTable.populate();
  await associationsTable.populate();
  await usersTable.populate();

  // Tests
  print((await usersTable.getMultipleFromLogin(logins: [fakeUsers[0].login, fakeUsers[1].login])).map((User user) => user.name));

  tinterDatabase.close();
}
