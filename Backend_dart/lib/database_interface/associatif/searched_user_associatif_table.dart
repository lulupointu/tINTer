import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/associatif/searched_user_associatif.dart';

class SearchedUserAssociatifTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedUserAssociatifTable({
    @required this.database,
  });

  Future<Map<String, SearchedUserAssociatif>> getAllExceptOneFromLogin({@required String login}) async {
    final Future query = database.mappedResultsQuery(
        "SELECT ${UsersTable.name}.login, name, surname, \"statusAssociatif\" FROM "
        "(SELECT * FROM ${RelationsStatusAssociatifTable.name} "
        "WHERE login=@login "
        ") AS ${RelationsStatusAssociatifTable.name} "
        "JOIN ${UsersTable.name} "
        "ON ${RelationsStatusAssociatifTable.name}.\"otherLogin\"=${UsersTable.name}.login ",
        substitutionValues: {
          'login': login,
        });

    return query.then((queryResults) {
      return {
        for (Map<String, Map<String, dynamic>> query in queryResults)
          query[UsersTable.name]['otherLogin']: SearchedUserAssociatif.fromJson({
            ...query[UsersTable.name],
            'liked': _getLikeOrNotFromRelationStatusAssociatif(
                EnumRelationStatusAssociatif.valueOf(query[RelationsStatusAssociatifTable.name]['statusAssociatif']))
          })
      };
    });
  }

  bool _getLikeOrNotFromRelationStatusAssociatif(EnumRelationStatusAssociatif relationStatus) {
    return (relationStatus == EnumRelationStatusAssociatif.ignored || relationStatus == EnumRelationStatusAssociatif.none)
        ? false
        : true;
  }
}
