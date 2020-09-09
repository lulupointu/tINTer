import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/associatif/gouts_musicaux.dart';

class GoutsMusicauxTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'gouts_musicaux';
  final PostgreSQLConnection database;

  GoutsMusicauxTable({@required this.database});

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
      for (String goutMusical in allGoutsMusicaux)
        database.query("INSERT INTO $name VALUES (DEFAULT, @name);", substitutionValues: {
          'name': goutMusical,
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


  Future<void> add({@required String goutMusical}) async {
    final String query = "INSERT INTO $name VALUES (DEFAULT, @name);";

    return database.query(query, substitutionValues: {
      'name': goutMusical,
    });
  }

  Future<void> addMultiple({@required List<String> goutsMusicaux}) async {
    if (goutsMusicaux.length==0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < goutsMusicaux.length; index++)
            "(DEFAULT, @name$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < goutsMusicaux.length; index++)
        'name$index': goutsMusicaux[index]
    });
  }

  Future<void> update(
      {@required String oldGoutMusical, @required String goutMusical}) async {
    final String query =
        "UPDATE $name SET name=@name WHERE name=@old_name;";

    return database.query(query, substitutionValues: {
      'name': goutMusical,
      'old_name': oldGoutMusical,
    });
  }

  Future<int> getIdFromName({@required String goutMusical}) async {
    final String query = "SELECT id FROM $name WHERE name=@name;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'name': goutMusical,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
            'One goutMusical requested (${goutMusical} but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
            'One goutMusical requested (${goutMusical} but got ${sqlResults.length}');
      }

      return sqlResults[0][name]['id'];
    });
  }

  Future<List<int>> getMultipleIdFromName({@required List<String> goutsMusicaux}) async {
    if (goutsMusicaux==0) return [];
    final String query = """
    SELECT id FROM $name WHERE name IN (
    """ +
        [for (int index = 0; index < goutsMusicaux.length; index++) '@$index'].join(',') +
        ");";

    return database
        .mappedResultsQuery(
      query,
      substitutionValues: goutsMusicaux.asMap().map(
              (int key, String goutMusical) => MapEntry(key.toString(), goutMusical)),
    )
        .then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: '${goutsMusicaux.length} goutMusical requested but got 0');
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

  Future<void> remove({@required String goutMusical}) async {
    final String query = "DELETE FROM $name WHERE name=@name;";

    return database.query(query, substitutionValues: {
      'name': goutMusical,
    });
  }

  Future<void> removeMultiple({@required List<String> goutsMusicaux}) async {
    if (goutsMusicaux.length ==0) return;
    final String query = "DELETE FROM $name WHERE name IN (" +
        [for (int index = 0; index < goutsMusicaux.length; index++) '@$index'].join(',') +
        ");";

    return database.query(query,
        substitutionValues: goutsMusicaux.asMap().map((int key, String goutMusical) =>
            MapEntry(key.toString(), goutMusical)));
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

Future<void> main() async {
  final tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final goutMusicalTable = GoutsMusicauxTable(database: tinterDatabase.connection);
  await goutMusicalTable.delete();
  await goutMusicalTable.create();
  await goutMusicalTable.populate();

  // await tinterDatabase.close();
}
