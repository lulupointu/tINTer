import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_management_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';

class BinomePairsMatchesTable {
  final BinomePairsManagementTable binomePairsManagementTable;
  final RelationsScoreScolaireTable relationsScoreTable;
  final RelationsStatusScolaireTable relationsStatusTable;
  final PostgreSQLConnection database;

  BinomePairsMatchesTable({
    @required this.database,
  })  : binomePairsManagementTable = BinomePairsManagementTable(database: database),
        relationsScoreTable = RelationsScoreScolaireTable(database: database),
        relationsStatusTable = RelationsStatusScolaireTable(database: database);

  Future<List<BuildBinomePair>> getXDiscoverBinomePairsFromBinomePairId(
      {@required int binomePairId, @required int limit, int offset = 0}) async {
    String getDiscoverBinomePairsQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherBinomePairId\", score, \"statusScolaire\" FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".\"binomePairId\", \"myRelationStatusScolaire\".\"otherBinomePairId\", \"myRelationStatusScolaire\".\"statusScolaire\", \"otherRelationStatusScolaire\".\"statusScolaire\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE \"binomePairId\"=@binomePairId AND \"statusScolaire\"='none' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".\"binomePairId\" = \"otherRelationStatusScolaire\".\"otherBinomePairId\" AND \"myRelationStatusScolaire\".\"otherBinomePairId\" = \"otherRelationStatusScolaire\".\"binomePairId\" "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherBinomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdA AND ${RelationsStatusScolaireTable.name}.\"binomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdB) OR (${RelationsStatusScolaireTable.name}.\"otherBinomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdB AND ${RelationsStatusScolaireTable.name}.\"binomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    return database.mappedResultsQuery(getDiscoverBinomePairsQuery, substitutionValues: {
      'binomePairId': binomePairId,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return binomePairsManagementTable.
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map((Map<String, Map<String, dynamic>> result) =>
              result[RelationsStatusScolaireTable.name]['otherBinomePairId'].toString())
              .toList())
          .then((Map<String, BuildBinomePair> otherBinomePairs) {
        return [
          for (int index = 0; index < otherBinomePairs.length; index++)
            BuildBinomePair.fromJson({
              ...otherBinomePairs[sqlResults[index][RelationsStatusScolaireTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreScolaireTable.name]['score'],
              'statusScolaire': BinomePairStatus.none.serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  Future<List<BuildBinomePair>> getMatchedBinomePairsFromBinomePairId({@required int binomePairId}) async {
    String getDiscoverBinomePairsQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherBinomePairId\", score, \"statusScolaire\", \"otherStatus\" FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".\"binomePairId\", \"myRelationStatusScolaire\".\"otherBinomePairId\", \"myRelationStatusScolaire\".\"statusScolaire\", \"otherRelationStatusScolaire\".\"statusScolaire\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE \"binomePairId\"=@binomePairId AND \"statusScolaire\"<>'none' AND \"statusScolaire\"<>'ignored' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".\"binomePairId\" = \"otherRelationStatusScolaire\".\"otherBinomePairId\" AND \"myRelationStatusScolaire\".\"otherBinomePairId\" = \"otherRelationStatusScolaire\".\"binomePairId\" "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherBinomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdA AND ${RelationsStatusScolaireTable.name}.\"binomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdB) OR (${RelationsStatusScolaireTable.name}.\"otherBinomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdB AND ${RelationsStatusScolaireTable.name}.\"binomePairId\" = ${RelationsScoreScolaireTable.name}.binomePairIdA) "
        ";";

    return database.mappedResultsQuery(getDiscoverBinomePairsQuery, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      return binomePairsManagementTable
          .getMultipleFromBinomePairsId(
          binomePairsId: sqlResults
              .map((Map<String, Map<String, dynamic>> result) =>
              result[RelationsStatusScolaireTable.name]['otherBinomePairId'].toString())
              .toList())
          .then((Map<String, BuildBinomePair> otherBinomePairs) {
        return [
          for (int index = 0; index < otherBinomePairs.length; index++)
            BuildBinomePair.fromJson({
              ...otherBinomePairs[sqlResults[index][RelationsStatusScolaireTable.name]['otherBinomePairId']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreScolaireTable.name]['score'],
              'statusScolaire': getBinomePairStatusFromRelationStatusScolaire(
                  status: EnumRelationStatusScolaire.valueOf(sqlResults[index]
                  [RelationsStatusScolaireTable.name]['statusScolaire']),
                  otherStatus: EnumRelationStatusScolaire.valueOf(
                      sqlResults[index][RelationsStatusScolaireTable.name]['otherStatus']))
                  .serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  // Maps the RelationStatusScolaire to the BinomePairStatus
  // ignore: missing_return
  BinomePairStatus getBinomePairStatusFromRelationStatusScolaire(
      {EnumRelationStatusScolaire status, EnumRelationStatusScolaire otherStatus}) {
    assert(status != null && otherStatus != null);

    switch (status) {
      case EnumRelationStatusScolaire.none:
        return BinomePairStatus.none;
      case EnumRelationStatusScolaire.ignored:
        return BinomePairStatus.ignored;
      case EnumRelationStatusScolaire.liked:
        switch (otherStatus) {
          case EnumRelationStatusScolaire.none:
            return BinomePairStatus.liked;
          case EnumRelationStatusScolaire.ignored:
            return BinomePairStatus.heIgnoredYou;
          case EnumRelationStatusScolaire.liked:
            return BinomePairStatus.matched;
          case EnumRelationStatusScolaire.askedBinomePair:
            return BinomePairStatus.heAskedBinomePair;
          case EnumRelationStatusScolaire.acceptedBinomePair:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.refusedBinomePair:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
        }
        break;
      case EnumRelationStatusScolaire.askedBinomePair:
        switch (otherStatus) {
          case EnumRelationStatusScolaire.none:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.ignored:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.liked:
            return BinomePairStatus.youAskedBinomePair;
          case EnumRelationStatusScolaire.askedBinomePair:
            return BinomePairStatus.binomeAccepted;
          case EnumRelationStatusScolaire.acceptedBinomePair:
            return BinomePairStatus.binomeAccepted;
          case EnumRelationStatusScolaire.refusedBinomePair:
            BinomePairStatus.binomeHeRefused;
        }
        break;
      case EnumRelationStatusScolaire.acceptedBinomePair:
        return BinomePairStatus.binomeAccepted;
      case EnumRelationStatusScolaire.refusedBinomePair:
        return BinomePairStatus.binomeYouRefused;
    }
  }
}

class UnauthorizedRelationStatusScolaireCombination implements Exception {
  final EnumRelationStatusScolaire status, otherStatus;

  UnauthorizedRelationStatusScolaireCombination(
      {@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}
