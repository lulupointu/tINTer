import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_score_scolaire_table.dart';
import 'package:tinter_backend/database_interface/scolaire/relation_status_scolaire_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/binome.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';
import 'package:tinter_backend/models/shared/user.dart';

final _logger = Logger('BinomesTable');

class BinomesTable {
  final UsersManagementTable usersManagementTable;
  final RelationsScoreScolaireTable relationsScoreTable;
  final RelationsStatusScolaireTable relationsStatusTable;
  final PostgreSQLConnection database;

  BinomesTable({
    @required this.database,
  })  : usersManagementTable = UsersManagementTable(database: database),
        relationsScoreTable = RelationsScoreScolaireTable(database: database),
        relationsStatusTable = RelationsStatusScolaireTable(database: database);

  Future<List<BuildBinome>> getXDiscoverBinomesFromLogin(
      {@required String login, @required int limit, int offset = 0}) async {
    _logger.info('Executing function getXDiscoverBinomesFromLogin with args: login=${login}, limit=${limit}, offset=${offset}');

    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherLogin\", score, \"statusScolaire\" FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\", \"myRelationStatusScolaire\".\"statusScolaire\", \"otherRelationStatusScolaire\".\"statusScolaire\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login AND \"statusScolaire\"='none' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".login = \"otherRelationStatusScolaire\".\"otherLogin\" AND \"myRelationStatusScolaire\".\"otherLogin\" = \"otherRelationStatusScolaire\".login "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginA AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginB) OR (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginB AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginA) "
        " ORDER BY score DESC LIMIT @limit OFFSET @offset"
        ";";

    if (login == "delsol_l") {
      getDiscoverBinomesQuery =
          "SELECT ${RelationsStatusScolaireTable.name}.\"otherLogin\", score FROM ${RelationsScoreScolaireTable.name} JOIN "
          "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\", \"myRelationStatusScolaire\".\"statusScolaire\", \"otherRelationStatusScolaire\".\"statusScolaire\" AS \"otherStatus\" "
          "FROM "

          "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\" FROM "

          "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
          "WHERE login=@login AND \"statusScolaire\"='none' "
          ") AS \"myRelationStatusScolaire\" "

          " LEFT JOIN ${BinomePairsProfilesTable.name} "
          "ON ${BinomePairsProfilesTable.name}.login=\"myRelationStatusScolaire\".\"otherLogin\" OR ${BinomePairsProfilesTable.name}.\"otherLogin\"=\"myRelationStatusScolaire\".\"otherLogin\" "
          ") AS \"myRelationStatusScolaire\" "

          "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
          "ON \"myRelationStatusScolaire\".login = \"otherRelationStatusScolaire\".\"otherLogin\" AND \"myRelationStatusScolaire\".\"otherLogin\" = \"otherRelationStatusScolaire\".login "
          ") AS ${RelationsStatusScolaireTable.name} "
          "ON (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginA AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginB) OR (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginB AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginA) "
          " ORDER BY score DESC LIMIT @limit OFFSET @offset"
          ";";
    }

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'login': login,
      'limit': limit,
      'offset': offset,
    }).then((sqlResults) {
      return usersManagementTable
          .getMultipleFromLogins(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusScolaireTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, BuildUser> otherUsers) {
        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinome.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusScolaireTable.name]['otherLogin']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreScolaireTable.name]['score'],
              'statusScolaire': BinomeStatus.none.serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  Future<List<BuildBinome>> getMatchedBinomesFromLogin({@required String login}) async {
    _logger.info('Executing function getMatchedBinomesFromLogin with args: login=${login}');

    String getDiscoverBinomesQuery =
        "SELECT ${RelationsStatusScolaireTable.name}.\"otherLogin\", score, \"statusScolaire\", \"otherStatus\" FROM ${RelationsScoreScolaireTable.name} JOIN "
        "(SELECT \"myRelationStatusScolaire\".login, \"myRelationStatusScolaire\".\"otherLogin\", \"myRelationStatusScolaire\".\"statusScolaire\", \"otherRelationStatusScolaire\".\"statusScolaire\" AS \"otherStatus\" "
        "FROM "
        "(SELECT * FROM ${RelationsStatusScolaireTable.name} "
        "WHERE login=@login AND \"statusScolaire\"<>'none' AND \"statusScolaire\"<>'ignored' "
        ") AS \"myRelationStatusScolaire\" "
        "JOIN ${RelationsStatusScolaireTable.name} AS \"otherRelationStatusScolaire\" "
        "ON \"myRelationStatusScolaire\".login = \"otherRelationStatusScolaire\".\"otherLogin\" AND \"myRelationStatusScolaire\".\"otherLogin\" = \"otherRelationStatusScolaire\".login "
        ") AS ${RelationsStatusScolaireTable.name} "
        "ON (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginA AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginB) OR (${RelationsStatusScolaireTable.name}.\"otherLogin\" = ${RelationsScoreScolaireTable.name}.loginB AND ${RelationsStatusScolaireTable.name}.login = ${RelationsScoreScolaireTable.name}.loginA) "
        ";";

    return database.mappedResultsQuery(getDiscoverBinomesQuery, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return usersManagementTable
          .getMultipleFromLogins(
              logins: sqlResults
                  .map((Map<String, Map<String, dynamic>> result) =>
                      result[RelationsStatusScolaireTable.name]['otherLogin'].toString())
                  .toList())
          .then((Map<String, BuildUser> otherUsers) {
        return [
          for (int index = 0; index < otherUsers.length; index++)
            BuildBinome.fromJson({
              ...otherUsers[sqlResults[index][RelationsStatusScolaireTable.name]['otherLogin']]
                  .toJson(),
              'score': sqlResults[index][RelationsScoreScolaireTable.name]['score'],
              'statusScolaire': getBinomeStatusFromRelationStatusScolaire(
                      status: EnumRelationStatusScolaire.valueOf(sqlResults[index]
                          [RelationsStatusScolaireTable.name]['statusScolaire']),
                      otherStatus: EnumRelationStatusScolaire.valueOf(
                          sqlResults[index][RelationsStatusScolaireTable.name]['otherStatus']))
                  .serialize(),
              // Since we search for discover, we know that the status is none.
            })
        ];
      });
    });
  }

  // Maps the RelationStatusScolaire to the BinomeStatus
  // ignore: missing_return
  BinomeStatus getBinomeStatusFromRelationStatusScolaire(
      {EnumRelationStatusScolaire status, EnumRelationStatusScolaire otherStatus}) {
    _logger.info('Executing function getBinomeStatusFromRelationStatusScolaire with args: status=${status}, otherStatus=${otherStatus}');
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

  UnauthorizedRelationStatusScolaireCombination(
      {@required this.status, @required this.otherStatus});

  @override
  String toString() =>
      '(${this.runtimeType}) status $status and $otherStatus should not be present at the same time.';
}
