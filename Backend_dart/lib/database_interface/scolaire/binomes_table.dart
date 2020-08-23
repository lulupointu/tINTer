import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';

class BinomesTable {
  final UsersTable usersTable;
  final RelationsScoreScolaireTable relationsScoreTable;
  final RelationsStatusScolaireTable relationsStatusTable;
  final PostgreSQLConnection database;

  BinomesTable({
    @required this.database,
  })  : usersTable = UsersTable(database: database),
        relationsScoreTable = RelationsScoreScolaireTable(database: database),
        relationsStatusTable = RelationsStatusScolaireTable(database: database);

  Future<List<BuildBinome>> getXDiscoverBinomesFromLogin(
      {@required String login, @required int limit, int offset = 0}) async {
    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherLogin\", score, status FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\", \"myRelationStatusScolaire\".status, \"otherRelationStatusScolaire\".status AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login AND status='none' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".login = \"otherRelationStatusScolaire\".\"otherLogin\" AND \"myRelationStatusScolaire\".\"otherLogin\" = \"otherRelationStatusScolaire\".login "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginA AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginB) OR (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginB AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'login': login,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return usersTable
          .getMultipleFromLogin(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusScolaireTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, Map<String, dynamic>> otherUsers) {
        return [
//          for (int index = 0; index < otherUsers.length; index++)
//            BuildBinome.fromJson({
//              ...otherUsers[index]['otherLogin'].toJson(),
//              'score': sqlResults[index][RelationsScoreScolaireTable.name]['score'],
//              'status': BinomeStatus.none,
//              // Since we search for discover, we know that the status is none.
//            })
        ];
      });
    });
  }

  Future<List<BuildBinome>> getMatchedBinomesFromLogin({@required String login}) async {
    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherLogin\", score, status, \"otherStatus\" FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\", \"myRelationStatusScolaire\".status, \"otherRelationStatusScolaire\".status AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login AND status<>'none' AND status<>'ignored' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".login = \"otherRelationStatusScolaire\".\"otherLogin\" AND \"myRelationStatusScolaire\".\"otherLogin\" = \"otherRelationStatusScolaire\".login "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginA AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginB) OR (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginB AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginA) "
        ";";

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      print(sqlResults);
      return usersTable
          .getMultipleFromLogin(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusScolaireTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, Map<String, dynamic>> otherUsers) {
        return [
//          for (Map<String, Map<String, dynamic>> result in sqlResults)
//            BuildBinome.fromJson({
//              ...otherUsers[result[RelationsStatusScolaireTable.name]['otherLogin']].toJson(),
//              'score': result[RelationsScoreScolaireTable.name]['score'],
//              'status': getBinomeStatusFromRelationStatusScolaire(
//                  status: getEnumRelationStatusScolaireFromString(
//                      result[RelationsStatusScolaireTable.name]['status']),
//                  otherStatus: getEnumRelationStatusScolaireFromString(
//                      result[RelationsStatusScolaireTable.name]['otherStatus'])),
//            })
        ];
      });
    });
  }

  // Maps the RelationStatusScolaire to the BinomeStatus
  // ignore: missing_return
  BinomeStatus getBinomeStatusFromRelationStatusScolaire(
      {EnumRelationStatusScolaire status, EnumRelationStatusScolaire otherStatus}) {
    assert(status != null && otherStatus != null);

    switch (status) {
      case EnumRelationStatusScolaire.none:
        return BinomeStatus.none;
      case EnumRelationStatusScolaire.ignored:
        return BinomeStatus.ignored;
      case EnumRelationStatusScolaire.liked:
        switch (otherStatus) {
          case EnumRelationStatusScolaire.none:
            return BinomeStatus.liked;
          case EnumRelationStatusScolaire.ignored:
            return BinomeStatus.heIgnoredYou;
          case EnumRelationStatusScolaire.liked:
            return BinomeStatus.matched;
          case EnumRelationStatusScolaire.askedBinome:
            return BinomeStatus.heAskedBinome;
          case EnumRelationStatusScolaire.acceptedBinome:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.refusedBinome:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
        }
        break;
      case EnumRelationStatusScolaire.askedBinome:
        switch (otherStatus) {
          case EnumRelationStatusScolaire.none:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.ignored:
            throw UnauthorizedRelationStatusScolaireCombination(
                status: status, otherStatus: otherStatus);
          case EnumRelationStatusScolaire.liked:
            return BinomeStatus.youAskedBinome;
          case EnumRelationStatusScolaire.askedBinome:
            return BinomeStatus.binomeAccepted;
          case EnumRelationStatusScolaire.acceptedBinome:
            return BinomeStatus.binomeAccepted;
          case EnumRelationStatusScolaire.refusedBinome:
            BinomeStatus.binomeHeRefused;
        }
        break;
      case EnumRelationStatusScolaire.acceptedBinome:
        return BinomeStatus.binomeAccepted;
      case EnumRelationStatusScolaire.refusedBinome:
        return BinomeStatus.binomeYouRefused;
    }
  }
}

class UnauthorizedRelationStatusScolaireCombination implements Exception {
  final EnumRelationStatusScolaire status, otherStatus;

  UnauthorizedRelationStatusScolaireCombination({@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}