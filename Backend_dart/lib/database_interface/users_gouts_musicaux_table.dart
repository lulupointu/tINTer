import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/student.dart';

class UsersGoutsMusicauxTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_gouts_musicaux';
  final PostgreSQLConnection database;
  final GoutsMusicauxTable goutsMusicauxTable;

  UsersGoutsMusicauxTable({@required this.database})
      : goutsMusicauxTable = GoutsMusicauxTable(database: database);

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${StaticProfileTable.name} (login) ON DELETE CASCADE,
      gout_musical_id int NOT NULL REFERENCES ${GoutsMusicauxTable.name} (id),
      PRIMARY KEY (user_login, gout_musical_id)
    );
    """;

    return database.query(query);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> addFromLogin({@required String login, @required String goutMusical}) async {
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
      for (int index = 0; index < goutsMusicaux.length; index++) ...{
        'login': login,
        'goutMusicalId$index': goutsMusicauxIds[index],
      }
    });
  }

  Future<void> updateUser(Student user) async {
    await removeAllFromLogin(login: user.login);

    return addMultipleFromLogin(login: user.login, goutsMusicaux: user.goutsMusicaux);
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login = @login "
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
    final String query = "DELETE FROM $name WHERE user_login=@login;";

    return database.query(query, substitutionValues: {
      'login': login,
    });
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}
