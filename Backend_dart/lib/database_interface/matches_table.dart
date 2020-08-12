import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/relation_status_table.dart';
import 'package:tinter_backend/database_interface/relation_score_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/match.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/relation_status.dart';
import 'package:tinter_backend/models/user.dart';

class MatchesTable {
  // WARNING: the name must have only lower case letter.
  final UsersTable usersTable;
  final RelationsScoreTable relationsScoreTable;
  final RelationsStatusTable relationsStatusTable;
  final PostgreSQLConnection database;
  final String login;

  MatchesTable({
    @required this.login,
    @required this.database,
    @required this.usersTable,
    @required this.relationsScoreTable,
    @required this.relationsStatusTable,
  });

  Future<List<Match>> getXDiscoverMatchesFromLogin(
      {@required String login, @required int limit, int offset = 0}) async {
    String getDiscoverMatchesQuery =
        "SELECT ${RelationsStatusTable.name}.\"otherLogin\", score, status FROM ${RelationsScoreTable.name} JOIN "
        "(SELECT \"myRelationStatus\".login, \"myRelationStatus\".\"otherLogin\", \"myRelationStatus\".status, \"otherRelationStatus\".status AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusTable.name} "
        "WHERE login=@login AND status='none' "
        ") AS \"myRelationStatus\" "
        "JOIN ${RelationsStatusTable.name} AS \"otherRelationStatus\" "
        "ON \"myRelationStatus\".login = \"otherRelationStatus\".\"otherLogin\" AND \"myRelationStatus\".\"otherLogin\" = \"otherRelationStatus\".login "
        ") AS ${RelationsStatusTable.name} "
        "ON (${RelationsStatusTable.name}.\"otherLogin\" = ${RelationsScoreTable.name}.loginA AND ${RelationsStatusTable.name}.login = ${RelationsScoreTable.name}.loginB) OR (${RelationsStatusTable.name}.\"otherLogin\" = ${RelationsScoreTable.name}.loginB AND ${RelationsStatusTable.name}.login = ${RelationsScoreTable.name}.loginA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    return database.mappedResultsQuery(getDiscoverMatchesQuery, substitutionValues: {
      'login': login,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return usersTable
          .getMultipleFromLogin(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, User> otherUsers) {
        return [
          for (Map<String, Map<String, dynamic>> result in sqlResults)
            Match.fromJson({
              ...otherUsers[result[RelationsStatusTable.name]['otherLogin']].toJson(),
              'score': result[RelationsScoreTable.name]['score'],
              'status': MatchStatus.none,
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  Future<List<Match>> getMatchedMatchesFromLogin({@required String login}) async {
    String getDiscoverMatchesQuery =
        "SELECT ${RelationsStatusTable.name}.\"otherLogin\", score, status FROM ${RelationsScoreTable.name} JOIN "
        "(SELECT \"myRelationStatus\".login, \"myRelationStatus\".\"otherLogin\", \"myRelationStatus\".status, \"otherRelationStatus\".status AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusTable.name} "
        "WHERE login=@login AND status<>'none' "
        ") AS \"myRelationStatus\" "
        "JOIN ${RelationsStatusTable.name} AS \"otherRelationStatus\" "
        "ON \"myRelationStatus\".login = \"otherRelationStatus\".\"otherLogin\" AND \"myRelationStatus\".\"otherLogin\" = \"otherRelationStatus\".login "
        ") AS ${RelationsStatusTable.name} "
        "ON (${RelationsStatusTable.name}.\"otherLogin\" = ${RelationsScoreTable.name}.loginA AND ${RelationsStatusTable.name}.login = ${RelationsScoreTable.name}.loginB) OR (${RelationsStatusTable.name}.\"otherLogin\" = ${RelationsScoreTable.name}.loginB AND ${RelationsStatusTable.name}.login = ${RelationsScoreTable.name}.loginA) "
        ";";

    return database.mappedResultsQuery(getDiscoverMatchesQuery, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return usersTable
          .getMultipleFromLogin(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, User> otherUsers) {
        return [
          for (Map<String, Map<String, dynamic>> result in sqlResults)
            Match.fromJson({
              ...otherUsers[result[RelationsStatusTable.name]['otherLogin']].toJson(),
              'score': result[RelationsScoreTable.name]['score'],
              'status': getMatchStatusFromRelationStatus(
                  status: getEnumRelationStatusFromString(result[RelationsStatusTable.name]['status']),
                  otherStatus: getEnumRelationStatusFromString(result[RelationsStatusTable.name]['otherStatus'])),
            })
        ];
      });
    });
  }

  // Maps the RelationStatus to the MatchStatus
  // ignore: missing_return
  MatchStatus getMatchStatusFromRelationStatus(
      {EnumRelationStatus status, EnumRelationStatus otherStatus}) {
    assert(status != null && otherStatus != null);

    switch (status) {
      case EnumRelationStatus.none:
        return MatchStatus.none;
      case EnumRelationStatus.ignored:
        return MatchStatus.ignored;
      case EnumRelationStatus.liked:
        switch (otherStatus) {
          case EnumRelationStatus.none:
            return MatchStatus.liked;
          case EnumRelationStatus.ignored:
            return MatchStatus.heIgnoredYou;
          case EnumRelationStatus.liked:
            return MatchStatus.matched;
          case EnumRelationStatus.askedParrain:
            return MatchStatus.heAskedParrain;
          case EnumRelationStatus.acceptedParrain:
            throw UnauthorizedRelationStatusCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatus.refusedParrain:
            throw UnauthorizedRelationStatusCombination(
                status: status, otherStatus: otherStatus);
        }
        break;
      case EnumRelationStatus.askedParrain:
        switch (otherStatus) {
          case EnumRelationStatus.none:
            throw UnauthorizedRelationStatusCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatus.ignored:
            throw UnauthorizedRelationStatusCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatus.liked:
            throw UnauthorizedRelationStatusCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatus.askedParrain:
            return MatchStatus.parrainAccepted;
          case EnumRelationStatus.acceptedParrain:
            return MatchStatus.parrainAccepted;
          case EnumRelationStatus.refusedParrain:
            MatchStatus.parrainRefused;
        }
        break;
      case EnumRelationStatus.acceptedParrain:
        return MatchStatus.parrainAccepted;
      case EnumRelationStatus.refusedParrain:
        return MatchStatus.parrainRefused;
    }
  }
}

class UnauthorizedRelationStatusCombination implements Exception {
  final EnumRelationStatus status, otherStatus;

  UnauthorizedRelationStatusCombination({@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}
