import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/matieres.dart';

class MatieresTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'matieres';
  final PostgreSQLConnection database;

  MatieresTable({@required this.database});

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      id SERIAL PRIMARY KEY,
      name Text UNIQUE NOT NULL
    );
    """;

    return database.query(query);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (String matiere in allMatieres)
        database.query("INSERT INTO $name VALUES (DEFAULT, @name);", substitutionValues: {
          'name': matiere,
        })
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE IF EXISTS $name CASCADE;
    """;

    return database.query(query);
  }


  Future<void> add({@required String matiere}) async {
    final String query = "INSERT INTO $name VALUES (DEFAULT, @name);";

    return database.query(query, substitutionValues: {
      'name': matiere,
    });
  }

  Future<void> addMultiple({@required List<String> matieres}) async {
    if (matieres.length==0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < matieres.length; index++)
            "(DEFAULT, @name$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < matieres.length; index++)
        'name$index': matieres[index]
    });
  }

  Future<void> update(
      {@required String oldMatiere, @required String matiere}) async {
    final String query =
        "UPDATE $name SET name=@name WHERE name=@old_name;";

    return database.query(query, substitutionValues: {
      'name': matiere,
      'old_name': oldMatiere,
    });
  }

  Future<int> getIdFromName({@required String matiere}) async {
    final String query = "SELECT id FROM $name WHERE name=@name;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'name': matiere,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
            'One matiere requested (${matiere} but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
            'One matiere requested (${matiere} but got ${sqlResults.length}');
      }

      return sqlResults[0][name]['id'];
    });
  }

  Future<List<int>> getMultipleIdFromName({@required List<String> matieres}) async {
    if (matieres==0) return [];
    final String query = """
    SELECT id FROM $name WHERE name IN (
    """ +
        [for (int index = 0; index < matieres.length; index++) '@$index'].join(',') +
        ");";

    return database
        .mappedResultsQuery(
      query,
      substitutionValues: matieres.asMap().map(
              (int key, String matiere) => MapEntry(key.toString(), matiere)),
    )
        .then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: '${matieres.length} matiere requested but got 0');
      }

      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          result[name]['id']
      ];
    });
  }

  Future<List<String>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map(
              (Map<String, Map<String, dynamic>> result) => result[name]['name'].toString())
          .toList();
    });
  }

  Future<void> remove({@required String matiere}) async {
    final String query = "DELETE FROM $name WHERE name=@name;";

    return database.query(query, substitutionValues: {
      'name': matiere,
    });
  }

  Future<void> removeMultiple({@required List<String> matieres}) async {
    if (matieres.length ==0) return;
    final String query = "DELETE FROM $name WHERE name IN (" +
        [for (int index = 0; index < matieres.length; index++) '@$index'].join(',') +
        ");";

    return database.query(query,
        substitutionValues: matieres.asMap().map((int key, String matiere) =>
            MapEntry(key.toString(), matiere)));
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

Future<void> main() async {
  final tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final matiereTable = MatieresTable(database: tinterDatabase.connection);
  await matiereTable.delete();
  await matiereTable.create();
  await matiereTable.populate();

  await tinterDatabase.close();
}
