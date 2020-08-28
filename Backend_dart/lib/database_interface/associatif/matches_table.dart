import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/relation_score_associatif_table.dart';
import 'package:tinter_backend/database_interface/associatif/relation_status_associatif_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/models/associatif/match.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/shared/user.dart';

class MatchesTable {
  final UsersManagementTable usersManagementTable;
  final RelationsScoreAssociatifTable relationsScoreTable;
  final RelationsStatusAssociatifTable relationsStatusTable;
  final PostgreSQLConnection database;

  MatchesTable({
    @required this.database,
  })  : usersManagementTable = UsersManagementTable(database: database),
        relationsScoreTable = RelationsScoreAssociatifTable(database: database),
        relationsStatusTable = RelationsStatusAssociatifTable(database: database);

  Future<List<BuildMatch>> getXDiscoverMatchesFromLogin(
      {@required String login, @required int limit, int offset = 0}) async {
    String getDiscoverMatchesQuery =
        "SELECT ${RelationsStatusAssociatifTable.name}.\"otherLogin\", score, \"statusAssociatif\" FROM ${RelationsScoreAssociatifTable.name} JOIN "
        "(SELECT \"myRelationStatusAssociatif\".login, \"myRelationStatusAssociatif\".\"otherLogin\", \"myRelationStatusAssociatif\".\"statusAssociatif\", \"otherRelationStatusAssociatif\".\"statusAssociatif\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusAssociatifTable.name} "
        "WHERE login=@login AND \"statusAssociatif\"='none' "
        ") AS \"myRelationStatusAssociatif\" "
        "JOIN ${RelationsStatusAssociatifTable.name} AS \"otherRelationStatusAssociatif\" "
        "ON \"myRelationStatusAssociatif\".login = \"otherRelationStatusAssociatif\".\"otherLogin\" AND \"myRelationStatusAssociatif\".\"otherLogin\" = \"otherRelationStatusAssociatif\".login "
        ") AS ${RelationsStatusAssociatifTable.name} "
        "ON (${RelationsStatusAssociatifTable.name}.\"otherLogin\" = ${RelationsScoreAssociatifTable.name}.loginA AND ${RelationsStatusAssociatifTable.name}.login = ${RelationsScoreAssociatifTable.name}.loginB) OR (${RelationsStatusAssociatifTable.name}.\"otherLogin\" = ${RelationsScoreAssociatifTable.name}.loginB AND ${RelationsStatusAssociatifTable.name}.login = ${RelationsScoreAssociatifTable.name}.loginA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    return database.mappedResultsQuery(getDiscoverMatchesQuery, substitutionValues: {
      'login': login,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return usersManagementTable
          .getMultipleFromLogins(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusAssociatifTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, BuildUser> otherUsers) {
        return [
          for (int index = 0; index < sqlResults.length; index++)
            BuildMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusAssociatifTable.name]
                      ['otherLogin']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreAssociatifTable.name]['score'],
              'statusAssociatif': MatchStatus.none.serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  Future<List<BuildMatch>> getMatchedMatchesFromLogin({@required String login}) async {
    String getDiscoverMatchesQuery =
        "SELECT ${RelationsStatusAssociatifTable.name}.\"otherLogin\", score, \"statusAssociatif\", \"otherStatus\" FROM ${RelationsScoreAssociatifTable.name} JOIN "
        "(SELECT \"myRelationStatusAssociatif\".login, \"myRelationStatusAssociatif\".\"otherLogin\", \"myRelationStatusAssociatif\".\"statusAssociatif\", \"otherRelationStatusAssociatif\".\"statusAssociatif\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusAssociatifTable.name} "
        "WHERE login=@login AND \"statusAssociatif\"<>'none' AND \"statusAssociatif\"<>'ignored' "
        ") AS \"myRelationStatusAssociatif\" "
        "JOIN ${RelationsStatusAssociatifTable.name} AS \"otherRelationStatusAssociatif\" "
        "ON \"myRelationStatusAssociatif\".login = \"otherRelationStatusAssociatif\".\"otherLogin\" AND \"myRelationStatusAssociatif\".\"otherLogin\" = \"otherRelationStatusAssociatif\".login "
        ") AS ${RelationsStatusAssociatifTable.name} "
        "ON (${RelationsStatusAssociatifTable.name}.\"otherLogin\" = ${RelationsScoreAssociatifTable.name}.loginA AND ${RelationsStatusAssociatifTable.name}.login = ${RelationsScoreAssociatifTable.name}.loginB) OR (${RelationsStatusAssociatifTable.name}.\"otherLogin\" = ${RelationsScoreAssociatifTable.name}.loginB AND ${RelationsStatusAssociatifTable.name}.login = ${RelationsScoreAssociatifTable.name}.loginA) "
        ";";

    return database.mappedResultsQuery(getDiscoverMatchesQuery, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return usersManagementTable
          .getMultipleFromLogins(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusAssociatifTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, BuildUser> otherUsers) {
        return [
          for (int index = 0; index < sqlResults.length; index++)
            BuildMatch.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusAssociatifTable.name]
                      ['otherLogin']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreAssociatifTable.name]['score'],
              'statusAssociatif': getMatchStatusFromRelationStatusAssociatif(
                      status: EnumRelationStatusAssociatif.valueOf(sqlResults[index]
                          [RelationsStatusAssociatifTable.name]['statusAssociatif']),
                      otherStatus: EnumRelationStatusAssociatif.valueOf(sqlResults[index]
                          [RelationsStatusAssociatifTable.name]['otherStatus']))
                  .serialize(),
            })
        ];
      });
    });
  }

  // Maps the RelationStatusAssociatif to the MatchStatus
  // ignore: missing_return
  MatchStatus getMatchStatusFromRelationStatusAssociatif(
      {EnumRelationStatusAssociatif status, EnumRelationStatusAssociatif otherStatus}) {
    assert(status != null && otherStatus != null);

    switch (status) {
      case EnumRelationStatusAssociatif.none:
        return MatchStatus.none;
      case EnumRelationStatusAssociatif.ignored:
        return MatchStatus.ignored;
      case EnumRelationStatusAssociatif.liked:
        switch (otherStatus) {
          case EnumRelationStatusAssociatif.none:
            return MatchStatus.liked;
          case EnumRelationStatusAssociatif.ignored:
            return MatchStatus.heIgnoredYou;
          case EnumRelationStatusAssociatif.liked:
            return MatchStatus.matched;
          case EnumRelationStatusAssociatif.askedParrain:
            return MatchStatus.heAskedParrain;
          case EnumRelationStatusAssociatif.acceptedParrain:
            throw UnauthorizedRelationStatusAssociatifCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusAssociatif.refusedParrain:
            throw UnauthorizedRelationStatusAssociatifCombination(
                status: status, otherStatus: otherStatus);
        }
        break;
      case EnumRelationStatusAssociatif.askedParrain:
        switch (otherStatus) {
          case EnumRelationStatusAssociatif.none:
            throw UnauthorizedRelationStatusAssociatifCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusAssociatif.ignored:
            throw UnauthorizedRelationStatusAssociatifCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusAssociatif.liked:
            return MatchStatus.youAskedParrain;
          case EnumRelationStatusAssociatif.askedParrain:
            return MatchStatus.parrainAccepted;
          case EnumRelationStatusAssociatif.acceptedParrain:
            return MatchStatus.parrainAccepted;
          case EnumRelationStatusAssociatif.refusedParrain:
            MatchStatus.parrainHeRefused;
        }
        break;
      case EnumRelationStatusAssociatif.acceptedParrain:
        return MatchStatus.parrainAccepted;
      case EnumRelationStatusAssociatif.refusedParrain:
        return MatchStatus.parrainYouRefused;
    }
  }
}

class UnauthorizedRelationStatusAssociatifCombination implements Exception {
  final EnumRelationStatusAssociatif status, otherStatus;

  UnauthorizedRelationStatusAssociatifCombination(
      {@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}
