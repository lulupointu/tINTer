import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/matieres_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';

final _logger = Logger('UsersMatieresTable');

class UsersMatieresTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_matiere';
  final PostgreSQLConnection database;
  final MatieresTable matieresTable;

  UsersMatieresTable({@required this.database})
      : matieresTable = MatieresTable(database: database);

  Future<void> create() {
    _logger.info('Executing function create.');

    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      matiere_id int NOT NULL REFERENCES ${MatieresTable.name} (id),
      PRIMARY KEY (user_login, matiere_id)
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

  Future<void> addFromLogin({@required String login, @required String matiere}) async {
    _logger.info('Executing function addFromLogin with args: login=${login}, matiere=${matiere}');

    // get the matiere id from the matiere name
    int matiereId = await matieresTable.getIdFromName(matiere: matiere);

    final String query = "INSERT INTO $name VALUES (@login, @matiereId);";

    return database.query(query, substitutionValues: {
      'login': login,
      'matiereId': matiereId,
    });
  }

  Future<void> addMultipleFromLogin(
      {@required String login, @required List<String> matieres}) async {
    _logger.info('Executing function addMultipleFromLogin with args: login=${login}, matieres=${matieres}');

    if (matieres.length == 0 ) return;
    // get the matieres ids from the matieres names
    List<int> matieresIds =
        await matieresTable.getMultipleIdFromName(matieres: matieres);

    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < matieres.length; index++)
            "(@login, @matiereId$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'login': login,
      for (int index = 0; index < matieres.length; index++) ...{
        'matiereId$index': matieresIds[index],
      }
    });
  }

  Future<void> updateUser({@required String login, @required List<String> matieres}) async {
    _logger.info('Executing function updateUser with args: login=${login}, matieres=${matieres}');

    await removeAllFromLogin(login: login);

    return addMultipleFromLogin(login: login, matieres: matieres);
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    _logger.info('Executing function getFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login=@login "
        ") AS $name JOIN ${MatieresTable.name} "
        "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][MatieresTable.name]['name']
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
            ") AS $name JOIN ${MatieresTable.name} "
            "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) "login$index": logins[index]
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {
        for (String login in logins) login: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[MatieresTable.name]['name']);
      }

      return mapGoutMusicauxToUsers;
    });
  }

  Future<Map<String, List<String>>> getAllExceptOneFromLogin({@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login != @login "
        ") AS $name JOIN ${MatieresTable.name} "
        "ON (${MatieresTable.name}.id = $name.matiere_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      Map<String, List<String>> mapGoutMusicauxToUsers = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapGoutMusicauxToUsers.keys.contains(result[name]['user_login'])) {
          mapGoutMusicauxToUsers[result[name]['user_login']] = [];
        }
        mapGoutMusicauxToUsers[result[name]['user_login']]
            .add(result[MatieresTable.name]['name']);
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
