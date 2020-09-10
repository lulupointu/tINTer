import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/scolaire/searched_user_scolaire.dart';

final _logger = Logger('SearchedUserScolaireTable');

class SearchedUserScolaireTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedUserScolaireTable({
    @required this.database,
  });

  Future<Map<String, SearchedUserScolaire>> getAllExceptOneFromLogin({@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final Future query = database.mappedResultsQuery(
        "SELECT ${UsersTable.name}.login, name, surname, \"statusScolaire\" FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login "
        ") AS ${RelationsStatusScolaireTable.name} "
        "JOIN ${UsersTable.name} "
        "ON ${RelationsStatusScolaireTable.name}.\"otherLogin\"=${UsersTable.name}.login ",
        substitutionValues: {
          'login': login,
        });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> queryResult in queryResults)
          queryResult[UsersTable.name]['login']: SearchedUserScolaire.fromJson({
            ...queryResult[UsersTable.name],
            'liked': _getLikeOrNotFromRelationStatusScolaire(
                EnumRelationStatusScolaire.valueOf(queryResult[RelationsStatusScolaireTable.name]['statusScolaire']))
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatusScolaire(EnumRelationStatusScolaire relationStatus) {
    _logger.info('Executing function _getLikeOrNotFromRelationStatusScolaire with args: relationStatus=${relationStatus}');

    return (relationStatus == EnumRelationStatusScolaire.ignored || relationStatus == EnumRelationStatusScolaire.none)
        ? false
        : true;
  }
}
