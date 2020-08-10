import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:tinter_backend/models/school_name.dart';
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
