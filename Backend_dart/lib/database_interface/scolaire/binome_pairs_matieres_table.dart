import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';

class BinomePairsMatieresTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_matiere';
  final PostgreSQLConnection database;
  final MatieresTable matieresTable;

  BinomePairsMatieresTable({@required this.database})
      : matieresTable = MatieresTable(database: database);

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      \"binomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      matiere_id int NOT NULL REFERENCES ${MatieresTable.name} (id),
      PRIMARY KEY (\"binomePairId\", matiere_id)
    );
    """;

    return database.query(query);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> addFromBinomePairId({@required int binomePairId, @required String matiere}) async {
    // get the matiere id from the matiere name
    int matiereId = await matieresTable.getIdFromName(matiere: matiere);

    final String query = "INSERT INTO $name VALUES (@binomePairId, @matiereId);";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      'matiereId': matiereId,
    });
  }

  Future<void> addMultipleFromBinomePairId(
      {@required int binomePairId, @required List<String> matieres}) async {
    if (matieres.length == 0 ) return;
    // get the matieres ids from the matieres names
    List<int> matieresIds =
    await matieresTable.getMultipleIdFromName(matieres: matieres);

    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < matieres.length; index++)
            "(@binomePairId, @matiereId$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      for (int index = 0; index < matieres.length; index++) ...{
        'matiereId$index': matieresIds[index],
      }
    });
  }

  Future<void> updateBinomePair({@required int binomePairId, @required List<String> matieres}) async {
    await removeAllFromBinomePairId(binomePairId: binomePairId);

    return addMultipleFromBinomePairId(binomePairId: binomePairId, matieres: matieres);
  }

  Future<List<String>> getFromBinomePairId({@required int binomePairId}) async {
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\"=@binomePairId "
        ") AS $name JOIN ${MatieresTable.name} "
        "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][MatieresTable.name]['name']
      ];
    });
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE login=@login OR \"otherLogin\"=@login "
        ") AS $name JOIN ${MatieresTable.name} "
        "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][MatieresTable.name]['name']
      ];
    });
  }

  Future<Map<int, List<String>>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
    if (binomePairsId.length == 0) return {};
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\" IN (" +
        [for (int index = 0; index < binomePairsId.length; index++) "@binomePairId$index"].join(',') +
        ")"
            ") AS $name JOIN ${MatieresTable.name} "
            "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < binomePairsId.length; index++) "binomePairId$index": binomePairsId[index]
    }).then((sqlResults) {
      Map<int, List<String>> mapGoutMusicauxToBinomePairs = {
        for (int binomePairId in binomePairsId) binomePairId: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapGoutMusicauxToBinomePairs[result[name]['\"binomePairId\"']]
            .add(result[MatieresTable.name]['name']);
      }

      return mapGoutMusicauxToBinomePairs;
    });
  }

  Future<Map<String, List<String>>> getAllExceptOneFromBinomePairId({@required int binomePairId}) async {
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\" != @binomePairId "
        ") AS $name JOIN ${MatieresTable.name} "
        "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToBinomePairs = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapGoutMusicauxToBinomePairs.keys.contains(result[name]['\"binomePairId\"'])) {
          mapGoutMusicauxToBinomePairs[result[name]['\"binomePairId\"']] = [];
        }
        mapGoutMusicauxToBinomePairs[result[name]['\"binomePairId\"']]
            .add(result[MatieresTable.name]['name']);
      }

      return mapGoutMusicauxToBinomePairs;
    });
  }

  Future<void> removeAllFromBinomePairId({@required int binomePairId}) {
    final String query = "DELETE FROM $name WHERE \"binomePairId\"=@binomePairId;";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
    });
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}
