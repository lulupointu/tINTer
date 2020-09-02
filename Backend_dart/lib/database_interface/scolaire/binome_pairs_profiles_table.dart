import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';

class BinomePairsProfilesTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_profiles';
  final PostgreSQLConnection database;

  BinomePairsProfilesTable({@required this.database});

  Future<void> create() async {
    final String createTableQuery = """
    CREATE TABLE $name (
      \"binomePairId\" SERIAL PRIMARY KEY,
      login Text UNIQUE NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      name Text NOT NULL,
      surname Text NOT NULL,
      email Text NOT NULL,
      \"otherLogin\" Text UNIQUE NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"otherName\" Text NOT NULL,
      \"otherSurname\" Text NOT NULL,
      \"otherEmail\" Text NOT NULL,
      \"groupeOuSeul\" Double PRECISION NOT NULL CHECK (\"groupeOuSeul\" >= 0 AND \"groupeOuSeul\" <= 1),
      \"lieuDeVie\" LieuDeVie,
      \"enligneOuNon\" Double PRECISION NOT NULL CHECK (\"enligneOuNon\" >= 0 AND \"enligneOuNon\" <= 1),
      CHECK (login < \"otherLogin\")
      );
    """;

    return database.query(createTableQuery);
  }

  Future<void> delete() async {
    return database.query("DROP TABLE IF EXISTS $name CASCADE;");
  }

  Future<void> add({@required Map<String, dynamic> binomePairJson}) async {
    assert(binomePairJson.containsKey('binomePairId'));

    // Remove any useless input
    binomePairJson.removeWhere((String key, dynamic value) => value == null || value is List);

    var queries = <Future>[
      database.query(
          "INSERT INTO $name "
                  "(" +
              [for (String key in binomePairJson.keys) '\"$key\"'].join(', ') +
              ") "
                  "VALUES (" +
              [for (String key in binomePairJson.keys) '@$key'].join(', ') +
              ");",
          substitutionValues: binomePairJson),
    ];

    return Future.wait(queries);
  }

  Future<bool> isKnown({@required int binomePairId}) {
    final String query = "SELECT * FROM $name "
        "WHERE $name.\"binomePairId\"=@binomePairId;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        return false;
      }

      return true;
    });
  }

  Future<bool> isKnownFromLogin({@required String login}) {
    final String query = "SELECT * FROM $name "
        "WHERE login=@login OR \"otherLogin\"=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        return false;
      }

      return true;
    });
  }

  Future<void> update({@required BuildBinomePair binomePair}) async {
    Map<String, dynamic> binomePairJson = binomePair.toJson();

    // Remove any useless input
    binomePairJson.removeWhere((String key, dynamic value) => value == null || value is List);

    print(
        "UPDATE $name "
            "SET " +
            [for (String key in binomePairJson.keys) '\"$key\"=@$key'].join(', ') +
            " WHERE \"binomePairId\"=@binomePairId;");

    final List<Future> queries = [
      database.query(
          "UPDATE $name "
                  "SET " +
              [for (String key in binomePairJson.keys) '\"$key\"=@$key'].join(', ') +
              " WHERE \"binomePairId\"=@binomePairId;",
          substitutionValues: binomePairJson),
    ];


    return Future.wait(queries);
  }

  Future<Map<String, dynamic>> getFromBinomePairId({@required int binomePairId}) async {
    final String query = "SELECT * FROM $name "
        "WHERE $name.\"binomePairId\"=@binomePairId;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${binomePairId}) but got 0');
      }

      return queriesResults[0][name];
    });
  }

  Future<Map<String, dynamic>> getFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name "
        "WHERE login=@login OR \"otherLogin\"=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${login}) but got 0');
      }

      return queriesResults[0][name];
    });
  }

  Future<String> getOtherLoginFromLogin({@required String login}) async {
    final String query = "SELECT login, \"otherLogin\" FROM $name "
        "WHERE login=@login OR \"otherLogin\"=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${login}) but got 0');
      }

      return queriesResults[0][name]['login'] != login
          ? queriesResults[0][name]['login']
          : queriesResults[0][name]['otherLogin'];
    });
  }

  Future<int> getBinomePairIdFromLogin({@required String login}) async {
    final String query = "SELECT \"binomePairId\" FROM $name "
        "WHERE login=@login OR \"otherLogin\"=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${login}) but got 0');
      }

      return queriesResults[0][name]['binomePairId'];
    });
  }

  Future<Map<int, Map<String, dynamic>>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
    if (binomePairsId.length == 0) return {};
    final String query = "SELECT * FROM $name "
            "WHERE $name.\"binomePairId\" IN (" +
        [for (int index = 0; index < binomePairsId.length; index++) "@binomePairId$index"]
            .join(',') +
        ");";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < binomePairsId.length; index++)
        'binomePairId$index': binomePairsId[index]
    }).then((queriesResults) {
      return {
        for (int index = 0; index < binomePairsId.length; index++)
          queriesResults[index][name]['binomePairId']: queriesResults[index][name]
      };
    });
  }

  Future<void> remove({@required int binomePairId}) async {
    final String query = "DELETE FROM $name WHERE \"binomePairId\"=@binomePairId;";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
    });
  }

  Future<void> removeFromLogin({@required String login}) async {
    final String query = "DELETE FROM $name WHERE \"login\"=@login OR \"otherLogin\"=@login;";

    return database.query(query, substitutionValues: {
      'login': login,
    });
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}
