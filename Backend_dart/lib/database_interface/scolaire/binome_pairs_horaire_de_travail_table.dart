import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/shared/user.dart';

class BinomePairsHorairesDeTravailTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_horaires_de_travail';
  final PostgreSQLConnection database;

  BinomePairsHorairesDeTravailTable({@required this.database});

  Future<void> create() async {
    final String query = """
    CREATE TABLE $name (
      \"binomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      \"horairesDeTravail\" HorairesDeTravail NOT NULL,
      PRIMARY KEY (\"binomePairId\", \"horairesDeTravail\")
    );
    """;
    return database.query(query);
  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name CASCADE;"),
    ];

    return Future.wait(queries);
  }

  Future<void> addFromBinomePairId(
      {@required int binomePairId, @required HoraireDeTravail horaireDeTravail}) async {
    final String query = "INSERT INTO $name VALUES (@binomePairId, @HoraireDeTravail);";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      'HoraireDeTravail': horaireDeTravail.serialize(),
    });
  }

  Future<void> addMultipleFromBinomePairId(
      {@required int binomePairId, @required List<HoraireDeTravail> horairesDeTravail}) async {
    if (horairesDeTravail.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < horairesDeTravail.length; index++)
            "(@binomePairId, @HoraireDeTravail$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      for (int index = 0; index < horairesDeTravail.length; index++) ...{
        'HoraireDeTravail$index': horairesDeTravail[index].serialize(),
      }
    });
  }

  Future<void> updateBinomePair(
      {@required int binomePairId, @required List<HoraireDeTravail> horairesDeTravail}) async {
    await removeAllFromBinomePairId(binomePairId: binomePairId);

    return addMultipleFromBinomePairId(binomePairId: binomePairId, horairesDeTravail: horairesDeTravail);
  }

  Future<List<String>> getFromBinomePairId({@required int binomePairId}) async {
    final String query = "SELECT * FROM $name WHERE \"binomePairId\"=@binomePairId ";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][name]['horairesDeTravail']
      ];
    });
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name WHERE login=@login OR \"otherLogin\"=@login ";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][name]['horairesDeTravail']
      ];
    });
  }

  Future<Map<int, List<String>>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
    if (binomePairsId.length == 0) return {};
    final String query = "SELECT * FROM $name WHERE \"binomePairId\" IN (" +
        [for (int index = 0; index < binomePairsId.length; index++) "@binomePairId$index"].join(',') +
        ")";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < binomePairsId.length; index++) "binomePairId$index": binomePairsId[index]
    }).then((sqlResults) {
      Map<int, List<String>> mapHorairesDeTravailTobinomePairs = {
        for (int binomePairId in binomePairsId) binomePairId: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapHorairesDeTravailTobinomePairs[result[name]['binomePairId']]
            .add(result[name]['horairesDeTravail']);
      }

      return mapHorairesDeTravailTobinomePairs;
    });
  }

  Future<Map<String, List<String>>> getAllExceptOneFromBinomePairId({@required int binomePairId}) async {
    final String query = "SELECT * FROM $name WHERE \"binomePairId\" != @binomePairId ";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      Map<String, List<String>> mapHorairesDeTravailTobinomePairs = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapHorairesDeTravailTobinomePairs.keys.contains(result[name]['binomePairId'])) {
          mapHorairesDeTravailTobinomePairs[result[name]['binomePairId']] = [];
        }
        mapHorairesDeTravailTobinomePairs[result[name]['binomePairId']]
            .add(result[name]['horairesDeTravail']);
      }

      return mapHorairesDeTravailTobinomePairs;
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
