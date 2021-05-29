import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_score_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/searched_binome_pair.dart';

final _logger = Logger('SearchedBinomePairsTable');

class SearchedBinomePairsTable {
  final PostgreSQLConnection database;

  final RelationsScoreBinomePairsMatchesTable relationsScoreBinomePairsMatchesTable;

  SearchedBinomePairsTable({
    @required this.database,
  }) : relationsScoreBinomePairsMatchesTable = RelationsScoreBinomePairsMatchesTable(
          database: database,
        );

  Future<Map<int, SearchedBinomePair>> getAllExceptOneFromLogin(
      {@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final Future query = database.mappedResultsQuery(
        "SELECT \"binomePairId\", \"otherBinomePairId\", login, name, surname, \"otherLogin\", \"otherName\", \"otherSurname\", \"status\" "
        " FROM "
        "( SELECT \"binomePairId\", \"otherBinomePairId\", status FROM "
        " ${RelationsStatusBinomePairsMatchesTable.name} "
        "JOIN "
        "( SELECT \"binomePairId\" FROM ${BinomePairsProfilesTable.name} "
        "WHERE login=@login OR \"otherLogin\"=@login "
        ") AS ${BinomePairsProfilesTable.name} "
        "USING (\"binomePairId\") "
        ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
        "JOIN "
        "( SELECT \"binomePairId\" AS \"otherBinomePairId\", login, name, surname, \"otherLogin\", \"otherName\", \"otherSurname\" FROM "
        "${BinomePairsProfilesTable.name} "
        ") AS ${BinomePairsProfilesTable.name} "
        "USING (\"otherBinomePairId\") ;",
        substitutionValues: {
          'login': login,
        });

    return query.then((queryResults) async {
      final scores = <int>[];
      for (Map<String, Map<String, dynamic>> queryResult in queryResults)
        scores.add(
          (await relationsScoreBinomePairsMatchesTable.getFromBinomePairIds(
                  binomePairId: queryResult[RelationsStatusBinomePairsMatchesTable.name]
                      ['binomePairId'],
                  otherBinomePairId: queryResult[RelationsStatusBinomePairsMatchesTable.name]
                      ['otherBinomePairId']))
              .score,
        );

      return {
        for (var i = 0; i < queryResults.length; i++)
          queryResults[i][RelationsStatusBinomePairsMatchesTable.name]['binomePairId']:
              SearchedBinomePair.fromJson({
            ...queryResults[i][BinomePairsProfilesTable.name],
            'binomePairId': queryResults[i][RelationsStatusBinomePairsMatchesTable.name]
                ['binomePairId'],
            'liked': _getLikeOrNotFromRelationStatusBinomePair(
                EnumRelationStatusBinomePair.valueOf(
                    queryResults[i][RelationsStatusBinomePairsMatchesTable.name]['status'])),
            'score': scores[i],
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatusBinomePair(EnumRelationStatusBinomePair relationStatus) {
    _logger.info(
        'Executing function _getLikeOrNotFromRelationStatusBinomePair with args: relationStatus=${relationStatus}');

    return (relationStatus == EnumRelationStatusBinomePair.ignored ||
            relationStatus == EnumRelationStatusBinomePair.none)
        ? false
        : true;
  }
}
