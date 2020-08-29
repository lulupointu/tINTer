import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_status_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinter_backend/models/scolaire/searched_binome_pair.dart';

class SearchedBinomePairsTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedBinomePairsTable({
    @required this.database,
  });

  Future<Map<String, SearchedBinomePair>> getAllExceptOneFromBinomePairId({@required int binomePairId}) async {
    final Future query = database.mappedResultsQuery(
        "SELECT ${UsersTable.name}.\"binomePairId\", name, surname, \"statusBinomePair\" FROM "
            "(SELECT * FROM ${RelationsStatusBinomePairsMatchesTable.name} "
            "WHERE \"binomePairId\"=@binomePairId "
            ") AS ${RelationsStatusBinomePairsMatchesTable.name} "
            "JOIN ${UsersTable.name} "
            "ON ${RelationsStatusBinomePairsMatchesTable.name}.\"otherBinomePairId\"=${UsersTable.name}.\"binomePairId\" ",
        substitutionValues: {
          'binomePairId': binomePairId,
        });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> queryResult in queryResults)
          queryResult[UsersTable.name]['binomePairId']: SearchedBinomePair.fromJson({
            ...queryResult[UsersTable.name],
            'liked': _getLikeOrNotFromRelationStatusBinomePair(
                EnumRelationStatusBinomePair.valueOf(queryResult[RelationsStatusBinomePairsMatchesTable.name]['statusBinomePair']))
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatusBinomePair(EnumRelationStatusBinomePair relationStatus) {
    return (relationStatus == EnumRelationStatusBinomePair.ignored || relationStatus == EnumRelationStatusBinomePair.none)
        ? false
        : true;
  }
}
