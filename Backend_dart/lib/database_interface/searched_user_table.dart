import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/match.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:tinter_backend/models/searched_user.dart';
import 'package:tinter_backend/models/user.dart';

class SearchedUserTable {
  // WARNING: the name must have only lower case letter.
  final PostgreSQLConnection database;

  SearchedUserTable({
    @required this.database,
  });

  Future<Map<String, SearchedUser>> getAllExceptOneFromLogin({@required String login}) async {
    final List<Future> queries = [
      database.mappedResultsQuery(
          "SELECT * FROM "
              "(SELECT * FROM ${RelationsStatusTable.name} "
                "WHERE login=@login "
              ") AS ${RelationsStatusTable.name} "
              "JOIN ${StaticProfileTable.name} "
              "ON ${RelationsStatusTable.name}.\"otherLogin\"=${StaticProfileTable.name}.login ",
          substitutionValues: {
            'login': login,
          }),
      usersAssociationsTable.getAllExceptOneFromLogin(login: login),
      usersGoutsMusicauxTable.getAllExceptOneFromLogin(login: login),
    ];

    return Future.wait(queries).then((queriesResults) {
      return {
        for (int index = 0; index < queriesResults[0].length; index++)
          queriesResults[0][index][name]['login']: User.fromJson({
            ...queriesResults[0][index][name],
            ...queriesResults[0][index][StaticProfileTable.name],
            ...{
              'associations': queriesResults[1][queriesResults[0][index][name]['login']],
              'goutsMusicaux': queriesResults[2][queriesResults[0][index][name]['login']],
            }
          })
      };
    });
  }


}