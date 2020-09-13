import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_score_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/binome_pair_match.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';

final _logger = Logger('BinomePairsMatchesTable');

class BinomePairsMatchesTable {
  final BinomePairsManagementTable binomePairsManagementTable;
  final RelationsScoreBinomePairsMatchesTable relationsScoreTable;
  final RelationsStatusBinomePairsMatchesTable relationsStatusTable;
  final PostgreSQLConnection database;

  BinomePairsMatchesTable({
    @required this.database,
  })  : binomePairsManagementTable = BinomePairsManagementTable(database: database),
        relationsScoreTable = RelationsScoreBinomePairsMatchesTable(database: database),
        relationsStatusTable = RelationsStatusBinomePairsMatchesTable(database: database);

  Future<List<BuildBinomePairMatch>> getXDiscoverBinomesFromLogin(
      {@required String login, @required int limit, int offset = 0}) async {
    _logger.info('Executing function getXDiscoverBinomesFromLogin with args: login=${login}, limit=${limit}, offset=${offset}');

    String getDiscoverBinomePairMatchesQuery =
        " SELECT ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\", score, \"status\" FROM ${RelationsScoreBinomePairsMatchesTable.name} JOIN "
        " (SELECT \"myRelationStatusBinomePair\".\"binomePairId\", \"myRelationStatusBinomePair\".\"otherBinomePairId\", \"myRelationStatusBinomePair\".\"status\", \"otherRelationStatusBinomePair\".\"status\" AS \"otherStatus\" "
        " FROM "
        " (SELECT * FROM "
        " (SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
        " WHERE \"status\"='none' "
        " ) AS \"myRelationStatusBinomePair\" "
        " JOIN "
        " (SELECT * FROM ${BinomePairsProfilesTable.name} "
        " WHERE login=@login OR \"otherLogin\"=@login "
        " ) AS ${BinomePairsProfilesTable.name} "
        " USING (\"binomePairId\") "
        " ) AS \"myRelationStatusBinomePair\" "
        " JOIN ${RelationsStatusBinomePairsMatchesTable.name} AS \"otherRelationStatusBinomePair\" "
        " ON \"myRelationStatusBinomePair\".\"binomePairId\" = \"otherRelationStatusBinomePair\".\"otherBinomePairId\" AND \"myRelationStatusBinomePair\".\"otherBinomePairId\" = \"otherRelationStatusBinomePair\".\"binomePairId\" "
        ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
        " ON (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB) OR (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    if (login == "delsol_l") {
      getDiscoverBinomePairMatchesQuery =
      " SELECT ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\", score, \"status\" FROM ${RelationsScoreBinomePairsMatchesTable.name} JOIN "
          " (SELECT \"myRelationStatusBinomePair\".\"binomePairId\", \"myRelationStatusBinomePair\".\"otherBinomePairId\", \"myRelationStatusBinomePair\".\"status\", \"otherRelationStatusBinomePair\".\"status\" AS \"otherStatus\" "
          " FROM "

          " (SELECT \"myRelationStatusBinomePair\".* FROM "

          " (SELECT * FROM "
          " (SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
          " WHERE \"status\"='none' "
          " ) AS \"myRelationStatusBinomePair\" "
          " JOIN "
          " (SELECT * FROM ${BinomePairsProfilesTable.name} "
          " WHERE login=@login OR \"otherLogin\"=@login "
          " ) AS ${BinomePairsProfilesTable.name} "
          " USING (\"binomePairId\") "
          " ) AS \"myRelationStatusBinomePair\" "

          " LEFT JOIN "
          "( SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
          " WHERE status='acceptedBinomePairMatch' "
          " ) AS ${RelationsStatusBinomePairsMatchesTable.name} "
          " ON ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = \"myRelationStatusBinomePair\".\"otherBinomePairId\" OR ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = \"myRelationStatusBinomePair\".\"otherBinomePairId\" "
          " WHERE ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" IS NULL"

          " ) AS \"myRelationStatusBinomePair\" "

          " JOIN ${RelationsStatusBinomePairsMatchesTable.name} AS \"otherRelationStatusBinomePair\" "
          " ON \"myRelationStatusBinomePair\".\"binomePairId\" = \"otherRelationStatusBinomePair\".\"otherBinomePairId\" AND \"myRelationStatusBinomePair\".\"otherBinomePairId\" = \"otherRelationStatusBinomePair\".\"binomePairId\" "
          ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
          " ON (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB) OR (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA) "
          " ORDER BY score DESC LIMIT @limit OFFSET @offset"
          ";";
    }

    return database.mappedResultsQuery(getDiscoverBinomePairMatchesQuery, substitutionValues: {
      'login': login,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {

      return binomePairsManagementTable
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map<int>((Map<String, Map<String, dynamic>> result) =>
              result[RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId'])
              .toList())
          .then((Map<int, BuildBinomePair> otherUsers) {

        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinomePairMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreBinomePairsMatchesTable.name]['score'],
              'status': BinomeStatus.none.serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }
  Future<List<BuildBinomePairMatch>> getXDiscoverBinomesFromBinomePairId(
      {@required int binomePairId, @required int limit, int offset = 0}) async {
    _logger.info('Executing function getXDiscoverBinomesFromBinomePairId with args: binomePairId=${binomePairId}, limit=${limit}, offset=${offset}');

    String getDiscoverBinomePairMatchesQuery =
        "SELECT ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\", score, \"status\" FROM ${RelationsScoreBinomePairsMatchesTable.name} JOIN "
        "(SELECT \"myRelationStatusBinomePair\".\"binomePairId\", \"myRelationStatusBinomePair\".\"otherBinomePairId\", \"myRelationStatusBinomePair\".\"status\", \"otherRelationStatusBinomePair\".\"status\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
        "WHERE \"binomePairId\"=@binomePairId AND \"status\"='none' "
        ") AS \"myRelationStatusBinomePair\" "
        "JOIN ${RelationsStatusBinomePairsMatchesTable.name} AS \"otherRelationStatusBinomePair\" "
        "ON \"myRelationStatusBinomePair\".\"binomePairId\" = \"otherRelationStatusBinomePair\".\"otherBinomePairId\" AND \"myRelationStatusBinomePair\".\"otherBinomePairId\" = \"otherRelationStatusBinomePair\".\"binomePairId\" "
        ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
        "ON (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA AND ${RelationsStatusBinomePairsMatchesTable.name}.binomePairId = ${RelationsScoreBinomePairsMatchesTable.name}.\"binomePairId\"B) OR (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    return database.mappedResultsQuery(getDiscoverBinomePairMatchesQuery, substitutionValues: {
      'binomePairId': binomePairId,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return binomePairsManagementTable
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map<int>((Map<String, Map<String, dynamic>> result) =>
          result[RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId'])
              .toList())
          .then((Map<int, BuildBinomePair> otherUsers) {

        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinomePairMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreBinomePairsMatchesTable.name]['score'],
              'status': BinomeStatus.none.serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  Future<List<BuildBinomePairMatch>> getMatchedBinomesFromLogin({@required String login}) async {
    _logger.info('Executing function getMatchedBinomesFromLogin with args: login=${login}');

    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\", score, \"status\", \"otherStatus\" FROM ${RelationsScoreBinomePairsMatchesTable.name} JOIN "
        "(SELECT \"myRelationStatusBinomePair\".\"binomePairId\", \"myRelationStatusBinomePair\".\"otherBinomePairId\", \"myRelationStatusBinomePair\".\"status\", \"otherRelationStatusBinomePair\".\"status\" AS \"otherStatus\" "
        "FROM ("
        "(SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
        "WHERE \"status\"<>'none' AND \"status\"<>'ignored' "
        ") AS \"myRelationStatus\" "
        "JOIN "
        "(SELECT * FROM ${BinomePairsProfilesTable.name} "
        "WHERE login=@login OR \"otherLogin\"=@login "
        ") AS ${BinomePairsProfilesTable.name} "
        "USING (\"binomePairId\") "
        ") AS \"myRelationStatusBinomePair\" "
        "JOIN ${RelationsStatusBinomePairsMatchesTable.name} AS \"otherRelationStatusBinomePair\" "
        "ON \"myRelationStatusBinomePair\".\"binomePairId\" = \"otherRelationStatusBinomePair\".\"otherBinomePairId\" AND \"myRelationStatusBinomePair\".\"otherBinomePairId\" = \"otherRelationStatusBinomePair\".\"binomePairId\" "
        ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
        "ON (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB) OR (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA) "
        ";";

    print(0);

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return binomePairsManagementTable
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map<int>((Map<String, Map<String, dynamic>> result) =>
          result[RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId'])
              .toList())
          .then((Map<int, BuildBinomePair> otherUsers) {

        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinomePairMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreBinomePairsMatchesTable.name]['score'],
              'status': getBinomeStatusFromRelationStatusBinomePair(
                  status: EnumRelationStatusBinomePair.valueOf(sqlResults[index]
                  [RelationsStatusBinomePairsMatchesTable.name]['status']),
                  otherStatus: EnumRelationStatusBinomePair.valueOf(
                      sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherStatus']))
                  .serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }



  Future<List<BuildBinomePairMatch>> getMatchedBinomesFromBinomePairId({@required int binomePairId}) async {
    _logger.info('Executing function getMatchedBinomesFromBinomePairId with args: binomePairId=${binomePairId}');

    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\", score, \"status\", \"otherStatus\" FROM ${RelationsScoreBinomePairsMatchesTable.name} JOIN "
        "(SELECT \"myRelationStatusBinomePair\".\"binomePairId\", \"myRelationStatusBinomePair\".\"otherBinomePairId\", \"myRelationStatusBinomePair\".\"status\", \"otherRelationStatusBinomePair\".\"status\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
        "WHERE \"binomePairId\"=@binomePairId AND \"status\"<>'none' AND \"status\"<>'ignored' "
        ") AS \"myRelationStatusBinomePair\" "
        "JOIN ${RelationsStatusBinomePairsMatchesTable.name} AS \"otherRelationStatusBinomePair\" "
        "ON \"myRelationStatusBinomePair\".\"binomePairId\" = \"otherRelationStatusBinomePair\".\"otherBinomePairId\" AND \"myRelationStatusBinomePair\".\"otherBinomePairId\" = \"otherRelationStatusBinomePair\".\"binomePairId\" "
        ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
        "ON (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB) OR (${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdB AND ${RelationsStatusBinomePairsMatchesTable.name}.\"binomePairId\" = ${RelationsScoreBinomePairsMatchesTable.name}.binomePairIdA) "
        ";";

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      return binomePairsManagementTable
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map<int>((Map<String, Map<String, dynamic>> result) =>
          result[RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId'])
              .toList())
          .then((Map<int, BuildBinomePair> otherUsers) {

        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinomePairMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreBinomePairsMatchesTable.name]['score'],
              'status': getBinomeStatusFromRelationStatusBinomePair(
                  status: EnumRelationStatusBinomePair.valueOf(sqlResults[index]
                  [RelationsStatusBinomePairsMatchesTable.name]['status']),
                  otherStatus: EnumRelationStatusBinomePair.valueOf(
                      sqlResults[index][RelationsStatusBinomePairsMatchesTable.name]['otherStatus']))
                  .serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  // Maps the RelationStatusBinomePair to the BinomeStatus
  // ignore: missing_return
  BinomePairMatchStatus getBinomeStatusFromRelationStatusBinomePair(
      {EnumRelationStatusBinomePair status, EnumRelationStatusBinomePair otherStatus}) {
    _logger.info('Executing function getBinomeStatusFromRelationStatusBinomePair with args: status=${status}, otherStatus=${otherStatus}');

    assert(status != null && otherStatus != null);

    switch (status) {
      case EnumRelationStatusBinomePair.none:
        return BinomePairMatchStatus.none;
      case EnumRelationStatusBinomePair.ignored:
        return BinomePairMatchStatus.ignored;
      case EnumRelationStatusBinomePair.liked:
        switch (otherStatus) {
          case EnumRelationStatusBinomePair.none:
            return BinomePairMatchStatus.liked;
          case EnumRelationStatusBinomePair.ignored:
            return BinomePairMatchStatus.heIgnoredYou;
          case EnumRelationStatusBinomePair.liked:
            return BinomePairMatchStatus.matched;
          case EnumRelationStatusBinomePair.askedBinomePairMatch:
            return BinomePairMatchStatus.heAskedBinomePairMatch;
          case EnumRelationStatusBinomePair.acceptedBinomePairMatch:
            throw UnauthorizedRelationStatusBinomePairCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusBinomePair.refusedBinomePairMatch:
            throw UnauthorizedRelationStatusBinomePairCombination(
                status: status, otherStatus: otherStatus);
        }
        break;
      case EnumRelationStatusBinomePair.askedBinomePairMatch:
        switch (otherStatus) {
          case EnumRelationStatusBinomePair.none:
            throw UnauthorizedRelationStatusBinomePairCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusBinomePair.ignored:
            throw UnauthorizedRelationStatusBinomePairCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusBinomePair.liked:
            return BinomePairMatchStatus.youAskedBinomePairMatch;
          case EnumRelationStatusBinomePair.askedBinomePairMatch:
            return BinomePairMatchStatus.binomePairMatchAccepted;
          case EnumRelationStatusBinomePair.acceptedBinomePairMatch:
            return BinomePairMatchStatus.binomePairMatchAccepted;
          case EnumRelationStatusBinomePair.refusedBinomePairMatch:
            BinomePairMatchStatus.binomePairMatchHeRefused;
        }
        break;
      case EnumRelationStatusBinomePair.acceptedBinomePairMatch:
        return BinomePairMatchStatus.binomePairMatchAccepted;
      case EnumRelationStatusBinomePair.refusedBinomePairMatch:
        return BinomePairMatchStatus.binomePairMatchYouRefused;
    }
  }
}

class UnauthorizedRelationStatusBinomePairCombination implements Exception {
  final EnumRelationStatusBinomePair status, otherStatus;

  UnauthorizedRelationStatusBinomePairCombination(
      {@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}
