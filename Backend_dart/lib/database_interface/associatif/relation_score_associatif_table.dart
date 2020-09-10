import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/relation_score_associatif.dart';


List<RelationScoreAssociatif> fakeListRelationScoreAssociatif = [
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[1].login
      ..score = 78,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[2].login
      ..score = 98,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[3].login
      ..score = 74,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[4].login
      ..score = 45,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[1].login
      ..otherLogin = fakeUsers[2].login
      ..score = 98,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[1].login
      ..otherLogin = fakeUsers[3].login
      ..score = 74,
  ),
  RelationScoreAssociatif(
    (r) => r
      ..login = fakeUsers[1].login
      ..otherLogin = fakeUsers[4].login
      ..score = 25,
  ),
];

final _logger = Logger('RelationsScoreAssociatifTable');

class RelationsScoreAssociatifTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_scores_associatif';
  final PostgreSQLConnection database;

  RelationsScoreAssociatifTable({@required this.database});

  Future<void> create() {
    _logger.info('Executing function create.');

    final String query = """
    CREATE TABLE $name (
      loginA Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      loginB Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
      PRIMARY KEY (loginA, loginB),
      CHECK (loginA < loginB)
    );
    """;

    return database.query(query);
  }

  Future<void> populate() {
    _logger.info('Executing function populate.');

    var queries = <Future>[
      for (RelationScoreAssociatif relationScore in fakeListRelationScoreAssociatif)
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
    _logger.info('Executing function delete.');

    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required RelationScoreAssociatif relationScore}) async {
    _logger.info('Executing function add with args: relationScore=${relationScore}');

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

  Future<void> addMultiple(
      {@required List<RelationScoreAssociatif> listRelationScoreAssociatif}) async {
    _logger.info('Executing function addMultiple with args: listRelationScoreAssociatif=${listRelationScoreAssociatif}');

    if (listRelationScoreAssociatif.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationScoreAssociatif.length; index++)
            "(@loginA$index, @loginB$index, @score$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScoreAssociatif.length; index++)
        ...(listRelationScoreAssociatif[index]
                    .login
                    .compareTo(listRelationScoreAssociatif[index].otherLogin) <
                0)
            ? {
                'loginA$index': listRelationScoreAssociatif[index].login,
                'loginB$index': listRelationScoreAssociatif[index].otherLogin,
                'score$index': listRelationScoreAssociatif[index].score,
              }
            : {
                'loginA$index': listRelationScoreAssociatif[index].otherLogin,
                'loginB$index': listRelationScoreAssociatif[index].login,
                'score$index': listRelationScoreAssociatif[index].score,
              }
    });
  }

  Future<void> update({@required RelationScoreAssociatif relationScore}) async {
    _logger.info('Executing function update with args: relationScore=${relationScore}');

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

  Future<void> updateMultiple(
      {@required List<RelationScoreAssociatif> listRelationScoreAssociatif}) async {
    _logger.info('Executing function updateMultiple with args: listRelationScoreAssociatif=${listRelationScoreAssociatif}');

    if (listRelationScoreAssociatif.length == 0) return;
    final String query = "UPDATE $name AS old SET score=new.score "
            "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationScoreAssociatif.length; index++)
            "(@loginA$index, @loginB$index, @score$index::integer)"
        ].join(',') +
        ") AS new(loginA, loginB, score)"
            "WHERE old.loginA=new.loginA AND old.loginB=new.loginB;";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScoreAssociatif.length; index++)
        ...(listRelationScoreAssociatif[index]
                    .login
                    .compareTo(listRelationScoreAssociatif[index].otherLogin) <
                0)
            ? {
                'loginA$index': listRelationScoreAssociatif[index].login,
                'loginB$index': listRelationScoreAssociatif[index].otherLogin,
                'score$index': listRelationScoreAssociatif[index].score,
              }
            : {
                'loginA$index': listRelationScoreAssociatif[index].otherLogin,
                'loginB$index': listRelationScoreAssociatif[index].login,
                'score$index': listRelationScoreAssociatif[index].score,
              }
    });
  }

  Future<RelationScoreAssociatif> getFromLogins(
      {@required String login, @required otherLogin}) async {
    _logger.info('Executing function getFromLogins with args: login=${login}, otherLogin=${otherLogin}');

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

      return RelationScoreAssociatif.fromJson(sqlResults[0][name]);
    });
  }

  Future<List<RelationScoreAssociatif>> getAllFromLogin({@required String login}) async {
    _logger.info('Executing function getAllFromLogin with args: login=${login}');

    final String query = "SELECT * FROM $name WHERE loginA=@login OR loginB=@login";

    return database
        .mappedResultsQuery(query, substitutionValues: {'login': login}).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScoreAssociatif.fromJson(result[name])
      ];
    });
  }

  Future<List<RelationScoreAssociatif>> getAll() {
    _logger.info('Executing function getAll.');

    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScoreAssociatif.fromJson(result[name])
      ];
    });
  }

  Future<void> removeFromLogins({@required String login, @required otherLogin}) async {
    _logger.info('Executing function removeFromLogins with args: login=${login}, otherLogin=${otherLogin}');

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
    _logger.info('Executing function removeAllFromLogin with args: login=${login}');

    final String query = "DELETE FROM $name WHERE loginA=@login OR loginB=@login;";

    return database.query(query, substitutionValues: {'login': login});
  }

  Future<void> removeAll() {
    _logger.info('Executing function removeAll.');

    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

//Future<void> main() async {
//  final tinterDatabase = TinterDatabase();
//  await tinterDatabase.open();
//
//  final relationTable = RelationsScoreAssociatifTable(database: tinterDatabase.connection);
//  await relationTable.delete();
//  await relationTable.create();
//  await relationTable.populate();
//
//  // Test getters
//  print(await relationTable.getAll());
//  print(await relationTable.getFromLogins(
//      login: fakeStaticStudents[0].login, otherLogin: fakeStaticStudents[1].login));
//  print(await relationTable.getAllFromLogin(login: fakeStaticStudents[0].login));
//
//  // Test removers
//  await relationTable.removeFromLogins(
//      login: fakeListRelationScoreAssociatif[1].login, otherLogin: fakeListRelationScoreAssociatif[2].login);
//  print(await relationTable.getAll());
//  await relationTable.removeAllFromLogin(login: fakeListRelationScoreAssociatif[0].login);
//  print(await relationTable.getAll());
//  await relationTable.removeAll();
//  print(await relationTable.getAll());
//
//  // Test adders
//  await relationTable.add(relationScore: fakeListRelationScoreAssociatif[0]);
//  print(await relationTable.getAll());
//  await relationTable
//      .addMultiple(listRelationScoreAssociatif: [fakeListRelationScoreAssociatif[1], fakeListRelationScoreAssociatif[2]]);
//  print(await relationTable.getAll());
//
//  // Test update
//  final newRelationStatusAssociatif = RelationScoreAssociatif(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[1].login,
//    score: 99,
//  );
//  await relationTable.update(relationScore: newRelationStatusAssociatif);
//  print(await relationTable.getAll());
//  final newRelationStatusAssociatif1 = RelationScoreAssociatif(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[2].login,
//    score: 12,
//  );
//  final newRelationStatusAssociatif2 = RelationScoreAssociatif(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[3].login,
//    score: 85,
//  );
//  await relationTable
//      .updateMultiple(listRelationScoreAssociatif: [newRelationStatusAssociatif1, newRelationStatusAssociatif2]);
//  print(await relationTable.getAll());
//
//  await tinterDatabase.close();
//}
