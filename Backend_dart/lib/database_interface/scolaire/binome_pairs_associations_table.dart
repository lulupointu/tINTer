import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';

final _logger = Logger('BinomePairsAssociationsTable');

class BinomePairsAssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_associations';
  final PostgreSQLConnection database;
  final AssociationsTable associationsTable;

  BinomePairsAssociationsTable({@required this.database})
      : associationsTable = AssociationsTable(database: database);

  Future<void> create() {
    _logger.info('Executing function create.');

    final String query = """
    CREATE TABLE $name (
      \"binomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      association_id int NOT NULL REFERENCES ${AssociationsTable.name} (id) ON DELETE CASCADE,
      PRIMARY KEY (\"binomePairId\", association_id)
    );
    """;

    return database.query(query);
  }

  Future<void> delete() {
    _logger.info('Executing function delete.');

    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> addFromBinomePairId(
      {@required int binomePairId, @required Association association}) async {
    _logger.info('Executing function addFromBinomePairId with args: binomePairId=${binomePairId}, association=${association}');

    // get the association id from the association name
    int associationId =
    await associationsTable.getIdFromName(associationName: association.name);

    final String query = "INSERT INTO $name VALUES (@binomePairId, @associationId);";

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      'associationId': associationId,
    });
  }

  Future<void> addMultipleFromBinomePairId(
      {@required binomePairId, @required List<Association> associations}) async {
    _logger.info('Executing function addMultipleFromBinomePairId with args: binomePairId=${binomePairId}, associations=${associations}');

    if (associations.length == 0 ) return;
    // get the associations ids from the associations names
    List<int> associationsIds =
    await associationsTable.getMultipleIdFromName(associations: associations);

    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < associations.length; index++)
            "(@binomePairId, @associationId$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'binomePairId': binomePairId,
      for (int index = 0; index < associations.length; index++) ...{
        'associationId$index': associationsIds[index],
      }
    });
  }

  Future<void> updateBinomePair({@required int binomePairId, @required List<Association> associations}) async {
    _logger.info('Executing function updateBinomePair with args: binomePairId=${binomePairId}, associations=${associations}');

    await removeAllFromBinomePairId(binomePairId: binomePairId);

    return addMultipleFromBinomePairId(binomePairId: binomePairId, associations: associations);
  }

  Future<List<Association>> getFromBinomePairId({@required int binomePairId}) async {
    _logger.info('Executing function getFromBinomePairId with args: binomePairId=${binomePairId}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\" = @binomePairId "
        ") AS $name JOIN ${AssociationsTable.name} "
        "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          Association.fromJson(sqlResults[index][AssociationsTable.name])
      ];
    });
  }

  Future<List<Association>> getFromLogin({@required String login}) async {
    _logger.info('Executing function getFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE login=@login OR \"otherLogin\"=@login "
        ") AS $name JOIN ${AssociationsTable.name} "
        "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          Association.fromJson(sqlResults[index][AssociationsTable.name])
      ];
    });
  }

  Future<Map<int, List<Association>>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
    _logger.info('Executing function getMultipleFromBinomePairsId with args: binomePairsId=${binomePairsId}');

    if (binomePairsId.length == 0) return {};
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\" IN (" +
        [for (int index = 0; index < binomePairsId.length; index++) "@binomePairId$index"].join(',') +
        ")"
            ") AS $name JOIN ${AssociationsTable.name} "
            "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < binomePairsId.length; index++) "binomePairId$index": binomePairsId[index]
    }).then((sqlResults) {
      Map<int, List<Association>> mapListAssociationToBinomePairs = {
        for (int binomePairId in binomePairsId) binomePairId: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapListAssociationToBinomePairs[result[name]['binomePairId']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToBinomePairs;
    });
  }

  Future<Map<String, List<Association>>> getAllExceptOneFromBinomePairId(
      {@required int binomePairId}) async {
    _logger.info('Executing function getAllExceptOneFromBinomePairId with args: binomePairId=${binomePairId}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE \"binomePairId\" != @binomePairId "
        ") AS $name JOIN ${AssociationsTable.name} "
        "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      Map<String, List<Association>> mapListAssociationToBinomePairs = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapListAssociationToBinomePairs.keys.contains(result[name]['binomePairId'])) {
          mapListAssociationToBinomePairs[result[name]['binomePairId']] = [];
        }
        mapListAssociationToBinomePairs[result[name]['binomePairId']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToBinomePairs;
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
