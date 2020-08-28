import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/shared/user.dart';

class UsersHorairesDeTravailTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_horaires_de_travail';
  final PostgreSQLConnection database;

  UsersHorairesDeTravailTable({@required this.database});

  Future<void> create() async {
    final String createType = """
        CREATE TYPE HorairesDeTravail AS ENUM ('morning', 'afternoon', 'evening', 'night');
        """;

    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"horairesDeTravail\" HorairesDeTravail NOT NULL,
      PRIMARY KEY (user_login, \"horairesDeTravail\")
    );
    """;

    await database.query(createType);

    return database.query(query);
  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name CASCADE;"),
      database.query("DROP TYPE IF EXISTS HorairesDeTravail CASCADE;"),
    ];

    return Future.wait(queries);
  }

  Future<void> addFromLogin(
      {@required String login, @required HoraireDeTravail horaireDeTravail}) async {
    final String query = "INSERT INTO $name VALUES (@login, @HoraireDeTravail);";

    return database.query(query, substitutionValues: {
      'login': login,
      'HoraireDeTravail': horaireDeTravail.serialize(),
    });
  }

  Future<void> addMultipleFromLogin(
      {@required String login, @required List<HoraireDeTravail> horairesDeTravail}) async {
    if (horairesDeTravail.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < horairesDeTravail.length; index++)
            "(@login, @HoraireDeTravail$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'login': login,
      for (int index = 0; index < horairesDeTravail.length; index++) ...{
        'HoraireDeTravail$index': horairesDeTravail[index].serialize(),
      }
    });
  }

  Future<void> updateUser(
      {@required String login, @required List<HoraireDeTravail> horairesDeTravail}) async {
    await removeAllFromLogin(login: login);

    return addMultipleFromLogin(login: login, horairesDeTravail: horairesDeTravail);
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name WHERE user_login=@login ";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][name]['horairesDeTravail']
      ];
    });
  }

  Future<Map<String, List<String>>> getMultipleFromLogins(
      {@required List<String> logins}) async {
    if (logins.length == 0) return {};
    final String query = "SELECT * FROM $name WHERE user_login IN (" +
        [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
        ")";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) "login$index": logins[index]
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {
        for (String login in logins) login: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[name]['horairesDeTravail']);
      }

      return mapGoutMusicauxToUsers;
    });
  }

  Future<Map<String, List<String>>> getAllExceptOneFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name WHERE user_login != @login ";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapGoutMusicauxToUsers.keys.contains(result[name]['user_login'])) {
          mapGoutMusicauxToUsers[result[name]['user_login']] = [];
        }
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[name]['horairesDeTravail']);
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
