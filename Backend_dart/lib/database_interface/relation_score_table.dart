import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/relation_score.dart';

List<RelationScore> fakeListRelationScore = [
  RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[1].login,
    score: 78,
  ),
  RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[2].login,
    score: 98,
  ),
  RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[3].login,
    score: 74,
  ),
  RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[4].login,
    score: 45,
  ),
  RelationScore(
    login: fakeStaticStudents[1].login,
    otherLogin: fakeStaticStudents[2].login,
    score: 98,
  ),
  RelationScore(
    login: fakeStaticStudents[1].login,
    otherLogin: fakeStaticStudents[3].login,
    score: 74,
  ),
  RelationScore(
    login: fakeStaticStudents[1].login,
    otherLogin: fakeStaticStudents[4].login,
    score: 25,
  ),
];

class RelationsScoreTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_scores';
  final PostgreSQLConnection database;

  RelationsScoreTable({@required this.database});

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      loginA Text NOT NULL REFERENCES ${StaticProfileTable.name} (login),
      loginB Text NOT NULL REFERENCES ${StaticProfileTable.name} (login),
      score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
      PRIMARY KEY (loginA, loginB),
      CHECK (loginA < loginB)
    );
    """;

    return database.query(query);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (RelationScore relationScore in fakeListRelationScore)
        database.query("INSERT INTO $name VALUES (@loginA, @loginB, @score);",
            substitutionValues: (relationScore.login.compareTo(relationScore.otherLogin) < 0)
                ? {
                    'loginA': relationScore.login,
                    'loginB': relationScore.otherLogin,
                    'score': relationScore.score,
                  }
                : {
                    'loginA': relationScore.otherLogin,
                    'loginB': relationScore.login,
                    'score': relationScore.score,
                  })
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required RelationScore relationScore}) async {
    final String query = "INSERT INTO $name VALUES (@loginA, @loginB, @score);";

    return database.query(query,
        substitutionValues: (relationScore.login.compareTo(relationScore.otherLogin) < 0)
            ? {
                'loginA': relationScore.login,
                'loginB': relationScore.otherLogin,
                'score': relationScore.score,
              }
            : {
                'loginA': relationScore.otherLogin,
                'loginB': relationScore.login,
                'score': relationScore.score,
              });
  }

  Future<void> addMultiple({@required List<RelationScore> listRelationScore}) async {
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationScore.length; index++)
            "(@loginA$index, @loginB$index, @score$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScore.length; index++)
        ...(listRelationScore[index].login.compareTo(listRelationScore[index].otherLogin) < 0)
            ? {
                'loginA$index': listRelationScore[index].login,
                'loginB$index': listRelationScore[index].otherLogin,
                'score$index': listRelationScore[index].score,
              }
            : {
                'loginA$index': listRelationScore[index].otherLogin,
                'loginB$index': listRelationScore[index].login,
                'score$index': listRelationScore[index].score,
              }
    });
  }

  Future<void> update({@required RelationScore relationScore}) async {
    final String query =
        "UPDATE $name SET score=@score WHERE loginA=@loginA AND loginB=@loginB;";

    return database.query(query,
        substitutionValues: (relationScore.login.compareTo(relationScore.otherLogin) < 0)
            ? {
                'loginA': relationScore.login,
                'loginB': relationScore.otherLogin,
                'score': relationScore.score,
              }
            : {
                'loginA': relationScore.otherLogin,
                'loginB': relationScore.login,
                'score': relationScore.score,
              });
  }

  Future<void> updateMultiple({@required List<RelationScore> listRelationScore}) async {
    final String query = "UPDATE $name AS old SET score=new.score "
            "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationScore.length; index++)
            "(@loginA$index, @loginB$index, @score$index::integer)"
        ].join(',') +
        ") AS new(loginA, loginB, score)"
            "WHERE old.loginA=new.loginA AND old.loginB=new.loginB;";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScore.length; index++)
        ...(listRelationScore[index].login.compareTo(listRelationScore[index].otherLogin) < 0)
            ? {
                'loginA$index': listRelationScore[index].login,
                'loginB$index': listRelationScore[index].otherLogin,
                'score$index': listRelationScore[index].score,
              }
            : {
                'loginA$index': listRelationScore[index].otherLogin,
                'loginB$index': listRelationScore[index].login,
                'score$index': listRelationScore[index].score,
              }
    });
  }

  Future<RelationScore> getFromLogins({@required String login, @required otherLogin}) async {
    final String query = "SELECT * FROM $name WHERE loginA=@loginA AND loginB=@loginB;";

    return database
        .mappedResultsQuery(query,
            substitutionValues: (login.compareTo(otherLogin) < 0)
                ? {
                    'loginA': login,
                    'loginB': otherLogin,
                  }
                : {
                    'loginA': otherLogin,
                    'loginB': login,
                  })
        .then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error: 'One pair of login expected but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One pair of login expected but got ${sqlResults.length}');
      }

      return RelationScore.fromJson(sqlResults[0][name]);
    });
  }

  Future<List<RelationScore>> getAllFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name WHERE loginA=@login OR loginB=@login";

    return database
        .mappedResultsQuery(query, substitutionValues: {'login': login}).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScore.fromJson(result[name])
      ];
    });
  }

  Future<List<RelationScore>> getAll() {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScore.fromJson(result[name])
      ];
    });
  }

  Future<void> removeFromLogins({@required String login, @required otherLogin}) async {
    final String query = "DELETE FROM $name WHERE loginA=@loginA AND loginB=@loginB;";

    return database.query(query,
        substitutionValues: (login.compareTo(otherLogin) < 0)
            ? {
                'loginA': login,
                'loginB': otherLogin,
              }
            : {
                'loginA': otherLogin,
                'loginB': login,
              });
  }

  Future<void> removeAllFromLogin({@required String login}) async {
    final String query = "DELETE FROM $name WHERE loginA=@login OR loginB=@login;";

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

  final relationTable = RelationsScoreTable(database: tinterDatabase.connection);
  await relationTable.delete();
  await relationTable.create();
  await relationTable.populate();

  // Test getters
  print(await relationTable.getAll());
  print(await relationTable.getFromLogins(
      login: fakeStaticStudents[0].login, otherLogin: fakeStaticStudents[1].login));
  print(await relationTable.getAllFromLogin(login: fakeStaticStudents[0].login));

  // Test removers
  await relationTable.removeFromLogins(
      login: fakeListRelationScore[1].login, otherLogin: fakeListRelationScore[2].login);
  print(await relationTable.getAll());
  await relationTable.removeAllFromLogin(login: fakeListRelationScore[0].login);
  print(await relationTable.getAll());
  await relationTable.removeAll();
  print(await relationTable.getAll());

  // Test adders
  await relationTable.add(relationScore: fakeListRelationScore[0]);
  print(await relationTable.getAll());
  await relationTable
      .addMultiple(listRelationScore: [fakeListRelationScore[1], fakeListRelationScore[2]]);
  print(await relationTable.getAll());

  // Test update
  final newRelationStatus = RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[1].login,
    score: 99,
  );
  await relationTable.update(relationScore: newRelationStatus);
  print(await relationTable.getAll());
  final newRelationStatus1 = RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[2].login,
    score: 12,
  );
  final newRelationStatus2 = RelationScore(
    login: fakeStaticStudents[0].login,
    otherLogin: fakeStaticStudents[3].login,
    score: 85,
  );
  await relationTable
      .updateMultiple(listRelationScore: [newRelationStatus1, newRelationStatus2]);
  print(await relationTable.getAll());

  await tinterDatabase.close();
}
