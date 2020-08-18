import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/match.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:tinter_backend/models/searched_user.dart';

class SearchedUserTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedUserTable({
    @required this.database,
  });

  Future<Map<String, SearchedUser>> getAllExceptOneFromLogin({@required String login}) async {
    final Future query = database.mappedResultsQuery(
        "SELECT * FROM "
        "(SELECT * FROM ${RelationsStatusTable.name} "
        "WHERE login=@login "
        ") AS ${RelationsStatusTable.name} "
        "JOIN ${StaticProfileTable.name} "
        "ON ${RelationsStatusTable.name}.\"otherLogin\"=${StaticProfileTable.name}.login ",
        substitutionValues: {
          'login': login,
        });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> query in queryResults)
          query[RelationsStatusTable.name]['otherLogin']: SearchedUser.fromJson({
            ...query[StaticProfileTable.name],
            'liked': _getLikeOrNotFromRelationStatus(
                getEnumRelationStatusFromString(query[RelationsStatusTable.name]['status']))
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatus(EnumRelationStatus relationStatus) {
    return (relationStatus == EnumRelationStatus.ignored || relationStatus == EnumRelationStatus.none)
        ? false
        : true;
  }
}
