import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/shared/user.dart';

final _logger = Logger('NotificationTable');

class NotificationTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'notifications';
  final PostgreSQLConnection database;

  NotificationTable({@required this.database});

  Future<void> create() async {
    _logger.info('Executing function create.');

    final String createTableQuery = """
    CREATE TABLE $name (
      login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      token Text NOT NULL,
      PRIMARY KEY (login, token)
      );
    """;

    return database.query(createTableQuery);
  }

  Future<void> delete() async {
    _logger.info('Executing function delete.');

    return database.query("DROP TABLE IF EXISTS $name CASCADE;");
  }

  Future<void> add({@required String login, @required String token}) async {
    _logger.info('Executing function addBasicInfo with args: login=${login}, token=${token}');

    var queries = <Future>[
      database.query("INSERT INTO $name VALUES (@login, @token);", substitutionValues: {
        'login': login,
        'token': token,
      }),
    ];

    return Future.wait(queries);
  }

  Future<List<String>> getFromLogin({@required String login}) async {
    _logger.info('Executing function getFromLogin with args: login=${login}');

    final String query = "SELECT * FROM $name "
        "WHERE $name.login=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${login}) but got 0');
      }

      return List<String>.from(queriesResults.map((Map<String, dynamic> result) => result[name]['token']));
    });
  }

  Future<Map<String, List<String>>> getFromLogins(
      {@required List<String> logins}) async {
    _logger.info('Executing function getFromLogins with args: logins=${logins}');

    if (logins.length == 0) return {};
    final String query = "SELECT * FROM $name "
            "WHERE $name.login IN (" +
        [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
        ");";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) 'login$index': logins[index]
    }).then((queriesResults) {
      final Map<String, List<String>> results = {};

      for (int index = 0; index < queriesResults.length; index++)
        results[queriesResults[index][name]['login']] == null
            ? results[queriesResults[index][name]['login']] = [
                queriesResults[index][name]['token']
              ]
            : results[queriesResults[index][name]['login']]
                .add(queriesResults[index][name]['token']);

      return results;
    });
  }

  Future<void> remove({@required String login}) async {
    _logger.info('Executing function remove with args: login=${login}');

    final String query = "DELETE FROM $name WHERE login=@login;";

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
