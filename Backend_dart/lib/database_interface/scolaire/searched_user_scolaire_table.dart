import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';

final _logger = Logger('SearchedUserScolaireTable');

class SearchedUserScolaireTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  RelationsScoreScolaireTable relationsScoreScolaireTable;

  SearchedUserScolaireTable({
    @required this.database,
  }) : relationsScoreScolaireTable =
            RelationsScoreScolaireTable(database: database);

  Future<Map<String, SearchedUserScolaire>> getAllExceptOneFromLogin(
      {@required String login}) async {
    _logger.info(
        'Executing function getAllExceptOneFromLogin with args: login=${login}');

    String getAllExceptOneFromLoginQuery =
        "SELECT ${UsersTable.name}.login, name, surname, \"statusScolaire\" FROM "
        "(SELECT ${RelationsStatusScolaireTable.name}.login, ${RelationsStatusScolaireTable.name}.\"otherLogin\", ${RelationsStatusScolaireTable.name}.\"statusScolaire\" FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login "
        ") AS ${RelationsStatusScolaireTable.name} "
        " LEFT OUTER JOIN ${BinomePairsProfilesTable.name} "
        " ON ${BinomePairsProfilesTable.name}.login=${RelationsStatusScolaireTable.name}.\"otherLogin\" OR ${BinomePairsProfilesTable.name}.\"otherLogin\"=${RelationsStatusScolaireTable.name}.\"otherLogin\" "
        " WHERE ${BinomePairsProfilesTable.name}.\"binomePairId\" IS NULL"
        ") AS ${RelationsStatusScolaireTable.name} "
        "JOIN ${UsersTable.name} "
        "ON ${RelationsStatusScolaireTable.name}.\"otherLogin\"=${UsersTable.name}.login ";

    final Future query = database
        .mappedResultsQuery(getAllExceptOneFromLoginQuery, substitutionValues: {
      'login': login,
    });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> queryResult in queryResults)
          queryResult[UsersTable.name]['login']: SearchedUserScolaire.fromJson({
            ...queryResult[UsersTable.name],
            'score': relationsScoreScolaireTable.getFromLogins(
                login: login,
                otherLogin: queryResult[UsersTable.name]['login']),
            'liked': _getLikeOrNotFromRelationStatusScolaire(
                EnumRelationStatusScolaire.valueOf(
                    queryResult[RelationsStatusScolaireTable.name]
                        ['statusScolaire']))
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatusScolaire(
      EnumRelationStatusScolaire relationStatus) {
    _logger.info(
        'Executing function _getLikeOrNotFromRelationStatusScolaire with args: relationStatus=${relationStatus}');

    return (relationStatus == EnumRelationStatusScolaire.ignored ||
            relationStatus == EnumRelationStatusScolaire.none)
        ? false
        : true;
  }
}
