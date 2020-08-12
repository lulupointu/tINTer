import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:meta/meta.dart';

List<RelationStatus> fakeListRelationStatus = [
  RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[1].login,
    status: EnumRelationStatus.liked,
  ),
  RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[2].login,
    status: EnumRelationStatus.none,
  ),
  RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[3].login,
    status: EnumRelationStatus.ignored,
  ),
  RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[4].login,
    status: EnumRelationStatus.askedParrain,
  ),
  RelationStatus(
    login: fakeStaticStudents[1].login,
    otherLogin: fakeStaticStudents[0].login,
    status: EnumRelationStatus.askedParrain,
  ),
  RelationStatus(
    login: fakeStaticStudents[2].login,
    otherLogin: fakeStaticStudents[0].login,
    status: EnumRelationStatus.ignored,
  ),
  RelationStatus(
    login: fakeStaticStudents[3].login,
    otherLogin: fakeStaticStudents[0].login,
    status: EnumRelationStatus.acceptedParrain,
  ),
  RelationStatus(
    login: fakeStaticStudents[4].login,
    otherLogin: fakeStaticStudents[0].login,
    status: EnumRelationStatus.refusedParrain,
  ),
];

class RelationsStatusTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_status';
  final PostgreSQLConnection database;

  RelationsStatusTable({@required this.database});

  Future<void> create() async {
    final String statusTypeCreationQuery = """
    CREATE TYPE status 
    AS ENUM ('none', 'ignored', 'liked', 'askedParrain', 'acceptedParrain', 'refusedParrain')
    """;
    final String creationQuery = """
    CREATE TABLE $name (
      login Text NOT NULL REFERENCES ${StaticProfileTable.name} (login),
      \"otherLogin\" Text NOT NULL REFERENCES ${StaticProfileTable.name} (login),
      status Text NOT NULL,
      PRIMARY KEY (login, \"otherLogin\"),
      CHECK (login <> \"otherLogin\")
    );
    """;

    await database.query(statusTypeCreationQuery);
    return database.query(creationQuery);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (RelationStatus relationStatus in fakeListRelationStatus)
        database.query("INSERT INTO $name VALUES (@login, @otherLogin, @status);",
            substitutionValues: relationStatus.toJson())
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name;"),
      database.query("DROP TYPE IF EXISTS status;"),
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required RelationStatus relationStatus}) async {
    final String query = "INSERT INTO $name VALUES (@login, @otherLogin, @status);";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> addMultiple({@required List<RelationStatus> listRelationStatus}) async {
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationStatus.length; index++)
            "(@login$index, @otherLogin$index, @status$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatus.length; index++)
        ...listRelationStatus[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update({@required RelationStatus relationStatus}) async {
    final String query =
        "UPDATE $name SET status=@status WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> updateMultiple({@required List<RelationStatus> listRelationStatus}) async {
    final String query = "UPDATE $name AS old SET status=new.status "
            "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationStatus.length; index++)
            "(@login$index, @otherLogin$index, @status$index)"
        ].join(',') +
        ") AS new(login, \"otherLogin\", status)"
            "WHERE (old.login=new.login AND old.\"otherLogin\"=new.\"otherLogin\");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatus.length; index++)
        ...listRelationStatus[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<RelationStatus> getFromLogins({@required String login, @required String otherLogin}) async {
    final String query =
        "SELECT * FROM $name WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
      'otherLogin': otherLogin,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
                'One relationStatus requested (between $login and $otherLogin) but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
                'One relationStatus requested (between $login and $otherLogin) but got ${sqlResults.length}');
      }

      return RelationStatus.fromJson(sqlResults[0][name]);
    });
  }

  Future<Map<String, RelationStatus>> getAllFromLogin({@required String login}) async {
    final String query = """
    SELECT * FROM $name WHERE login=@login;
    """;

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(error: 'No relationStatus were found for this user');
      }

      return {
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          result[name]['otherLogin']: RelationStatus.fromJson(result[name])
      };
    });
  }

  Future<List<RelationStatus>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map((Map<String, Map<String, dynamic>> result) => RelationStatus.fromJson(result[name]))
          .toList();
    });
  }

  Future<void> remove({@required RelationStatus relationStatus}) async {
    final String query =
        "DELETE FROM $name WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> removeMultiple({@required List<RelationStatus> listRelationStatus}) async {
    final String query = "DELETE FROM $name WHERE (login, \"otherLogin\") IN (" +
        [
          for (int index = 0; index < listRelationStatus.length; index++)
            '(@login$index, @otherLogin$index)'
        ].join(',') +
        ");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatus.length; index++) ...{
        'login$index': listRelationStatus[index].login,
        'otherLogin$index': listRelationStatus[index].otherLogin,
      }
    });
  }

  Future<void> removeLogin({@required String login}) async {
    final String query = "DELETE FROM $name WHERE login=@login OR \"otherLogin\"=@login;";

    return database.query(query, substitutionValues: {'login': login});
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

Future<void> main() async {
  final tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final relationStatusTable = RelationsStatusTable(database: tinterDatabase.connection);
  await relationStatusTable.delete();
  await relationStatusTable.create();
  await relationStatusTable.populate();

  // Test getters
  print(await relationStatusTable.getAll());
  print(await relationStatusTable.getFromLogins(
      login: fakeStaticStudents[0].login, otherLogin: fakeStaticStudents[1].login));
  print(await relationStatusTable.getAllFromLogin(login: fakeStaticStudents[0].login));

  // Test removers
  await relationStatusTable.remove(relationStatus: fakeListRelationStatus[0]);
  print(await relationStatusTable.getAll());
  await relationStatusTable.removeMultiple(listRelationStatus: [fakeListRelationStatus[1], fakeListRelationStatus[2]]);
  print(await relationStatusTable.getAll());
  await relationStatusTable.removeAll();
  print(await relationStatusTable.getAll());

  // Test adders
  await relationStatusTable.add(relationStatus: fakeListRelationStatus[0]);
  print(await relationStatusTable.getAll());
  await relationStatusTable.addMultiple(listRelationStatus: [fakeListRelationStatus[1], fakeListRelationStatus[2]]);
  print(await relationStatusTable.getAll());

  // Test update
  final newRelation = RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[1].login,
    status: EnumRelationStatus.none,
  );
  await relationStatusTable.update(relationStatus: newRelation);
  print(await relationStatusTable.getAll());
  final newRelation1 = RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[2].login,
    status: EnumRelationStatus.acceptedParrain,
  );
  final newRelation2 = RelationStatus(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[3].login,
    status: EnumRelationStatus.refusedParrain,
  );
  await relationStatusTable.updateMultiple(listRelationStatus: [newRelation1, newRelation2]);
  print(await relationStatusTable.getAll());

  await tinterDatabase.close();
}
