import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';

class BinomePairsAssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'binome_pairs_associations';
  final PostgreSQLConnection database;
  final AssociationsTable associationsTable;

  BinomePairsAssociationsTable({@required this.database})
      : associationsTable = AssociationsTable(database: database);

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      \"binomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      association_id int NOT NULL REFERENCES ${AssociationsTable.name} (id),
      PRIMARY KEY (\"binomePairId\", association_id)
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

  Future<void> addFromBinomePairId(
      {@required int binomePairId, @required Association association}) async {
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
    await removeAllFromBinomePairId(binomePairId: binomePairId);

    return addMultipleFromBinomePairId(binomePairId: binomePairId, associations: associations);
  }

  Future<List<Association>> getFromBinomePairId({@required int binomePairId}) async {
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

  Future<Map<int, List<Association>>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
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
        mapListAssociationToBinomePairs[result[name]['\"binomePairId\"']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToBinomePairs;
    });
  }

  Future<Map<String, List<Association>>> getAllExceptOneFromBinomePairId(
      {@required int binomePairId}) async {
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
        if (!mapListAssociationToBinomePairs.keys.contains(result[name]['\"binomePairId\"'])) {
          mapListAssociationToBinomePairs[result[name]['\"binomePairId\"']] = [];
        }
        mapListAssociationToBinomePairs[result[name]['\"binomePairId\"']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToBinomePairs;
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
