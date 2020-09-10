import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/shared/user.dart';

final _logger = Logger('BinomePairsHorairesDeTravailTable');

class BinomePairsHorairesDeTravailTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_horaires_de_travail';
  final PostgreSQLConnection database;

  BinomePairsHorairesDeTravailTable({@required this.database});

  Future<void> create() async {
    _logger.info('Executing function create.');

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
    _logger.info('Executing function delete.');

    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name CASCADE;"),
    ];

    return Future.wait(queries);
  }

  Future<void> addFromBinomePairId(
      {@required int binomePairId, @required HoraireDeTravail horaireDeTravail}) async {
    _logger.info('Executing function addFromBinomePairId with args: binomePairId=${binomePairId}, horaireDeTravail=${horaireDeTravail}');

    final String query = "INSERT INTO $name VALUES (@binomePairId, @HoraireDeTravail);";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      'HoraireDeTravail': horaireDeTravail.serialize(),
    });
  }

  Future<void> addMultipleFromBinomePairId(
      {@required int binomePairId, @required List<HoraireDeTravail> horairesDeTravail}) async {
    _logger.info('Executing function addMultipleFromBinomePairId with args: binomePairId=${binomePairId}, horairesDeTravail=${horairesDeTravail}');

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
    _logger.info('Executing function updateBinomePair with args: binomePairId=${binomePairId}, horairesDeTravail=${horairesDeTravail}');

    await removeAllFromBinomePairId(binomePairId: binomePairId);

    return addMultipleFromBinomePairId(binomePairId: binomePairId, horairesDeTravail: horairesDeTravail);
  }

  Future<List<String>> getFromBinomePairId({@required int binomePairId}) async {
    _logger.info('Executing function getFromBinomePairId with args: binomePairId=${binomePairId}');
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
    _logger.info('Executing function getFromLogin with args: login=${login}');

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
    _logger.info('Executing function getMultipleFromBinomePairsId with args: binomePairsId=${binomePairsId}');

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
    _logger.info('Executing function getAllExceptOneFromBinomePairId with args: binomePairId=${binomePairId}');

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
    _logger.info('Executing function removeAllFromBinomePairId with args: binomePairId=${binomePairId}');

    final String query = "DELETE FROM $name WHERE \"binomePairId\"=@binomePairId;";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
    });
  }

  Future<void> removeAll() {
    _logger.info('Executing function removeAll.');

    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}
