import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/models/scolaire/relation_score_binome_pair.dart';

//List<RelationScoreBinomePair> fakeListRelationScoreBinomePair = [
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[1].binomePairId
//      ..score = 78,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[2].binomePairId
//      ..score = 98,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[3].binomePairId
//      ..score = 74,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[4].binomePairId
//      ..score = 45,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[1].binomePairId
//      ..otherBinomePairId = fakeUsers[2].binomePairId
//      ..score = 98,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[1].binomePairId
//      ..otherBinomePairId = fakeUsers[3].binomePairId
//      ..score = 74,
//  ),
//  RelationScoreBinomePair(
//        (r) => r
//      ..binomePairId = fakeUsers[1].binomePairId
//      ..otherBinomePairId = fakeUsers[4].binomePairId
//      ..score = 25,
//  ),
//];

final _logger = Logger('RelationsScoreBinomePairsMatchesTable');

class RelationsScoreBinomePairsMatchesTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_scores_binome_pairs';
  final PostgreSQLConnection database;

  RelationsScoreBinomePairsMatchesTable({@required this.database});

  Future<void> create() {
    _logger.info('Executing function create.');

    final String query = """
    CREATE TABLE $name (
      binomePairIdA int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      binomePairIdB int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
      PRIMARY KEY (binomePairIdA, binomePairIdB),
      CHECK (binomePairIdA < binomePairIdB)
    );
    """;

    return database.query(query);
  }

//  Future<void> populate() {
//    var queries = <Future>[
//      for (RelationScoreBinomePair relationScore in fakeListRelationScoreBinomePair)
//        database.query("INSERT INTO $name VALUES (@binomePairIdA, @binomePairIdB, @score);",
//            substitutionValues: (relationScore.binomePairId.compareTo(relationScore.otherBinomePairId) < 0)
//                ? {
//              'binomePairIdA': relationScore.binomePairId,
//              'binomePairIdB': relationScore.otherBinomePairId,
//              'score': relationScore.score,
//            }
//                : {
//              'binomePairIdA': relationScore.otherBinomePairId,
//              'binomePairIdB': relationScore.binomePairId,
//              'score': relationScore.score,
//            })
//    ];
//
//    return Future.wait(queries);
//  }

  Future<void> delete() {
    _logger.info('Executing function delete.');

    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required RelationScoreBinomePair relationScore}) async {
    _logger.info('Executing function add with args: relationScore=${relationScore}');

    final String query = "INSERT INTO $name VALUES (@binomePairIdA, @binomePairIdB, @score);";

    return database.query(query,
        substitutionValues: (relationScore.binomePairId.compareTo(relationScore.otherBinomePairId) < 0)
            ? {
          'binomePairIdA': relationScore.binomePairId,
          'binomePairIdB': relationScore.otherBinomePairId,
          'score': relationScore.score,
        }
            : {
          'binomePairIdA': relationScore.otherBinomePairId,
          'binomePairIdB': relationScore.binomePairId,
          'score': relationScore.score,
        });
  }

  Future<void> addMultiple({@required List<RelationScoreBinomePair> listRelationScoreBinomePair}) async {
    _logger.info('Executing function addMultiple with args: listRelationScoreBinomePair=${listRelationScoreBinomePair}');

    if (listRelationScoreBinomePair.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationScoreBinomePair.length; index++)
            "(@binomePairIdA$index, @binomePairIdB$index, @score$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScoreBinomePair.length; index++)
        ...(listRelationScoreBinomePair[index].binomePairId.compareTo(listRelationScoreBinomePair[index].otherBinomePairId) < 0)
            ? {
          'binomePairIdA$index': listRelationScoreBinomePair[index].binomePairId,
          'binomePairIdB$index': listRelationScoreBinomePair[index].otherBinomePairId,
          'score$index': listRelationScoreBinomePair[index].score,
        }
            : {
          'binomePairIdA$index': listRelationScoreBinomePair[index].otherBinomePairId,
          'binomePairIdB$index': listRelationScoreBinomePair[index].binomePairId,
          'score$index': listRelationScoreBinomePair[index].score,
        }
    });
  }

  Future<void> update({@required RelationScoreBinomePair relationScore}) async {
    _logger.info('Executing function update with args: relationScore=${relationScore}');

    final String query =
        "UPDATE $name SET score=@score WHERE binomePairIdA=@binomePairIdA AND binomePairIdB=@binomePairIdB;";

    return database.query(query,
        substitutionValues: (relationScore.binomePairId.compareTo(relationScore.otherBinomePairId) < 0)
            ? {
          'binomePairIdA': relationScore.binomePairId,
          'binomePairIdB': relationScore.otherBinomePairId,
          'score': relationScore.score,
        }
            : {
          'binomePairIdA': relationScore.otherBinomePairId,
          'binomePairIdB': relationScore.binomePairId,
          'score': relationScore.score,
        });
  }

  Future<void> updateMultiple({@required List<RelationScoreBinomePair> listRelationScoreBinomePair}) async {
    _logger.info('Executing function updateMultiple with args: listRelationScoreBinomePair=${listRelationScoreBinomePair}');

    if (listRelationScoreBinomePair.length == 0) return;

    final String query = "UPDATE $name AS old SET score=new.score "
        "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationScoreBinomePair.length; index++)
            "(@binomePairIdA$index::integer, @binomePairIdB$index::integer, @score$index::integer)"
        ].join(',') +
        ") AS new(binomePairIdA, binomePairIdB, score)"
            "WHERE old.binomePairIdA=new.binomePairIdA AND old.binomePairIdB=new.binomePairIdB;";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationScoreBinomePair.length; index++)
        ...(listRelationScoreBinomePair[index].binomePairId.compareTo(listRelationScoreBinomePair[index].otherBinomePairId) < 0)
            ? {
          'binomePairIdA$index': listRelationScoreBinomePair[index].binomePairId,
          'binomePairIdB$index': listRelationScoreBinomePair[index].otherBinomePairId,
          'score$index': listRelationScoreBinomePair[index].score,
        }
            : {
          'binomePairIdA$index': listRelationScoreBinomePair[index].otherBinomePairId,
          'binomePairIdB$index': listRelationScoreBinomePair[index].binomePairId,
          'score$index': listRelationScoreBinomePair[index].score,
        }
    });
  }

  Future<RelationScoreBinomePair> getFromBinomePairIds({@required String binomePairId, @required otherBinomePairId}) async {
    _logger.info('Executing function getFromBinomePairIds with args: binomePairId=${binomePairId}, otherBinomePairId=${otherBinomePairId}');

    final String query = "SELECT * FROM $name WHERE binomePairIdA=@binomePairIdA AND binomePairIdB=@binomePairIdB;";

    return database
        .mappedResultsQuery(query,
        substitutionValues: (binomePairId.compareTo(otherBinomePairId) < 0)
            ? {
          'binomePairIdA': binomePairId,
          'binomePairIdB': otherBinomePairId,
        }
            : {
          'binomePairIdA': otherBinomePairId,
          'binomePairIdB': binomePairId,
        })
        .then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error: 'One pair of binomePairId expected but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One pair of binomePairId expected but got ${sqlResults.length}');
      }

      return RelationScoreBinomePair.fromJson(sqlResults[0][name]);
    });
  }

  Future<List<RelationScoreBinomePair>> getAllFromBinomePairId({@required String binomePairId}) async {
    _logger.info('Executing function getAllFromBinomePairId with args: binomePairId=${binomePairId}');

    final String query = "SELECT * FROM $name WHERE binomePairIdA=@binomePairId OR binomePairIdB=@binomePairId";

    return database
        .mappedResultsQuery(query, substitutionValues: {'binomePairId': binomePairId}).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScoreBinomePair.fromJson(result[name])
      ];
    });
  }

  Future<List<RelationScoreBinomePair>> getAll() {
    _logger.info('Executing function getAll.');
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          RelationScoreBinomePair.fromJson(result[name])
      ];
    });
  }

  Future<void> removeFromBinomePairIds({@required String binomePairId, @required otherBinomePairId}) async {
    _logger.info('Executing function removeFromBinomePairIds with args: binomePairId=${binomePairId}, otherBinomePairId=${otherBinomePairId}');

    final String query = "DELETE FROM $name WHERE binomePairIdA=@binomePairIdA AND binomePairIdB=@binomePairIdB;";

    return database.query(query,
        substitutionValues: (binomePairId.compareTo(otherBinomePairId) < 0)
            ? {
          'binomePairIdA': binomePairId,
          'binomePairIdB': otherBinomePairId,
        }
            : {
          'binomePairIdA': otherBinomePairId,
          'binomePairIdB': binomePairId,
        });
  }

  Future<void> removeAllFromBinomePairId({@required String binomePairId}) async {
    _logger.info('Executing function removeAllFromBinomePairId with args: binomePairId=${binomePairId}');

    final String query = "DELETE FROM $name WHERE binomePairIdA=@binomePairId OR binomePairIdB=@binomePairId;";

    return database.query(query, substitutionValues: {'binomePairId': binomePairId});
  }

  Future<void> removeAll() {
    _logger.info('Executing function removeAll.');

    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

