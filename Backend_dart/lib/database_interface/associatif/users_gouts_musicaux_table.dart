import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/gouts_musicaux_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';

final _logger = Logger('UsersGoutsMusicauxTable');

class UsersGoutsMusicauxTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_gouts_musicaux';
  final PostgreSQLConnection database;
  final GoutsMusicauxTable goutsMusicauxTable;

  UsersGoutsMusicauxTable({@required this.database})
      : goutsMusicauxTable = GoutsMusicauxTable(database: database);

  Future<void> create() {
    _logger.info('Executing function create.');
    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      gout_musical_id int NOT NULL REFERENCES ${GoutsMusicauxTable.name} (id),
      PRIMARY KEY (user_login, gout_musical_id)
    );
    """;

    return database.query(query);
  }

  Future<void> delete() {
    _logger.info('Executing function delete.');

    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> addFromLogin({@required String login, @required String goutMusical}) async {
    _logger.info('Executing function addFromLogin with args: login=${login}, goutMusical=${goutMusical}');

    // get the goutMusical id from the goutMusical name
    int goutMusicalId = await goutsMusicauxTable.getIdFromName(goutMusical: goutMusical);

    final String query = "INSERT INTO $name VALUES (@login, @goutMusicalId);";

    return database.query(query, substitutionValues: {
      'login': login,
      'goutMusicalId': goutMusicalId,
    });
  }

  Future<void> addMultipleFromLogin(
      {@required String login, @required List<String> goutsMusicaux}) async {
    _logger.info('Executing function addMultipleFromLogin with args: login=${login}, goutsMusicaux=${goutsMusicaux}');

    if (goutsMusicaux.length == 0) return;
    // get the goutsMusicaux ids from the goutsMusicaux names
    List<int> goutsMusicauxIds =
        await goutsMusicauxTable.getMultipleIdFromName(goutsMusicaux: goutsMusicaux);

    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < goutsMusicaux.length; index++)
            "(@login, @goutMusicalId$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'login': login,
      for (int index = 0; index < goutsMusicaux.length; index++) ...{
        'goutMusicalId$index': goutsMusicauxIds[index],
      }
    });
  }

  Future<void> updateUser(
      {@required String login, @required List<String> goutsMusicaux}) async {
    _logger.info('Executing function updateUser with args: login=${login}, goutsMusicaux=${goutsMusicaux}');

    await removeAllFromLogin(login: login);

    return addMultipleFromLogin(login: login, goutsMusicaux: goutsMusicaux);
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    _logger.info('Executing function getFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login=@login "
        ") AS $name JOIN ${GoutsMusicauxTable.name} "
        "ON (${GoutsMusicauxTable.name}.id = $name.gout_musical_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][GoutsMusicauxTable.name]['name']
      ];
    });
  }

  Future<Map<String, List<String>>> getMultipleFromLogins(
      {@required List<String> logins}) async {
    _logger.info('Executing function getMultipleFromLogins with args: logins=${logins}');

    if (logins.length == 0) return {};
    final String query = "SELECT * "
            "FROM ("
            "SELECT * FROM $name WHERE user_login IN (" +
        [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
        ")"
            ") AS $name JOIN ${GoutsMusicauxTable.name} "
            "ON (${GoutsMusicauxTable.name}.id = $name.gout_musical_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) "login$index": logins[index]
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {
        for (String login in logins) login: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[GoutsMusicauxTable.name]['name']);
      }

      return mapGoutMusicauxToUsers;
    });
  }

  Future<Map<String, List<String>>> getAllExceptOneFromLogin({@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login != @login "
        ") AS $name JOIN ${GoutsMusicauxTable.name} "
        "ON (${GoutsMusicauxTable.name}.id = $name.gout_musical_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapGoutMusicauxToUsers.keys.contains(result[name]['user_login'])) {
          mapGoutMusicauxToUsers[result[name]['user_login']] = [];
        }
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[GoutsMusicauxTable.name]['name']);
      }

      return mapGoutMusicauxToUsers;
    });
  }

  Future<void> removeAllFromLogin({@required String login}) {
    _logger.info('Executing function removeAllFromLogin with args: login=${login}');

    final String query = "DELETE FROM $name WHERE user_login=@login;";

    return database.query(query, substitutionValues: {
      'login': login,
    });
  }

  Future<void> removeAll() {
    _logger.info('Executing function removeAll.');

    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}
