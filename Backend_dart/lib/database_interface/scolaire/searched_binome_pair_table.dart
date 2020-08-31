import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
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

  Future<Map<String, SearchedBinomePair>> getAllExceptOneFromLogin({@required String login}) async {
    final Future query = database.mappedResultsQuery(
        "SELECT \"binomePairId\", name, surname, \"otherName\", \"otherSurname\", \"status\" "
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
      print("""first relation statusJson: ${{
          'liked': _getLikeOrNotFromRelationStatusBinomePair(
          EnumRelationStatusBinomePair.valueOf(queryResults[0][RelationsStatusBinomePairsMatchesTable.name]['statusBinomePair']))
      }}""");
      return {
        for (Map<String, Map<String, dynamic>> queryResult in queryResults)
          queryResult[BinomePairsProfilesTable.name]['binomePairId']: SearchedBinomePair.fromJson({
            ...queryResult[BinomePairsProfilesTable.name],
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
