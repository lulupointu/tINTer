import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/searched_binome_pair.dart';

final _logger = Logger('SearchedBinomePairsTable');

class SearchedBinomePairsTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedBinomePairsTable({
    @required this.database,
  });

  Future<Map<int, SearchedBinomePair>> getAllExceptOneFromLogin({@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final Future query = database.mappedResultsQuery(
        "SELECT \"binomePairId\", login, name, surname, \"otherLogin\", \"otherName\", \"otherSurname\", \"status\" "
            " FROM "
            "( SELECT \"otherBinomePairId\" AS \"binomePairId\", status FROM "
            " ${RelationsStatusBinomePairsMatchesTable.name} "
            "JOIN "
            "( SELECT \"binomePairId\" FROM ${BinomePairsProfilesTable.name} "
            "WHERE login=@login OR \"otherLogin\"=@login "
            ") AS ${BinomePairsProfilesTable.name} "
            "USING (\"binomePairId\") "
            ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
            "JOIN ${BinomePairsProfilesTable.name} "
            "USING (\"binomePairId\") ;",
        substitutionValues: {
          'login': login,
        });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> queryResult in queryResults)
          queryResult[RelationsStatusBinomePairsMatchesTable.name]['binomePairId']: SearchedBinomePair.fromJson({
            ...queryResult[BinomePairsProfilesTable.name],
            'binomePairId': queryResult[RelationsStatusBinomePairsMatchesTable.name]['binomePairId'],
            'liked': _getLikeOrNotFromRelationStatusBinomePair(
                EnumRelationStatusBinomePair.valueOf(queryResult[RelationsStatusBinomePairsMatchesTable.name]['status']))
          })
      };
    });
  }


  bool _getLikeOrNotFromRelationStatusBinomePair(EnumRelationStatusBinomePair relationStatus) {
    _logger.info('Executing function _getLikeOrNotFromRelationStatusBinomePair with args: relationStatus=${relationStatus}');

    return (relationStatus == EnumRelationStatusBinomePair.ignored || relationStatus == EnumRelationStatusBinomePair.none)
        ? false
        : true;
  }
}
