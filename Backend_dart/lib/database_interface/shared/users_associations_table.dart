import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/shared/associations_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';

final _logger = Logger('UsersAssociationsTable');

class UsersAssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_associations';
  final PostgreSQLConnection database;
  final AssociationsTable associationsTable;

  UsersAssociationsTable({@required this.database})
      : associationsTable = AssociationsTable(database: database);

  Future<void> create() {
    _logger.info('Executing function create.');

    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      association_id int NOT NULL REFERENCES ${AssociationsTable.name} (id),
      PRIMARY KEY (user_login, association_id)
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

  Future<void> addFromLogin(
      {@required String login, @required Association association}) async {
    _logger.info('Executing function addFromLogin with args: association=${association}, association=${association}');

    // get the association id from the association name
    int associationId =
        await associationsTable.getIdFromName(associationName: association.name);

    final String query = "INSERT INTO $name VALUES (@login, @associationId);";

    return database.query(query, substitutionValues: {
      'login': login,
      'associationId': associationId,
    });
  }

  Future<void> addMultipleFromLogin(
      {@required login, @required List<Association> associations}) async {
    _logger.info('Executing function addMultipleFromLogin with args: associations=${associations}, associations=${associations}');

    if (associations.length == 0 ) return;
    // get the associations ids from the associations names
    List<int> associationsIds =
        await associationsTable.getMultipleIdFromName(associations: associations);

    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < associations.length; index++)
            "(@login, @associationId$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      'login': login,
      for (int index = 0; index < associations.length; index++) ...{
        'associationId$index': associationsIds[index],
      }
    });
  }

  Future<void> updateUser({@required String login, @required List<Association> associations}) async {
    _logger.info('Executing function updateUser with args: associations=${associations}, associations=${associations}');

    await removeAllFromLogin(login: login);

    return addMultipleFromLogin(login: login, associations: associations);
  }

  Future<List<Association>> getFromLogin({@required String login}) async {
    _logger.info('Executing function getFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login = @login "
        ") AS $name JOIN ${AssociationsTable.name} "
        "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          Association.fromJson(sqlResults[index][AssociationsTable.name])
      ];
    });
  }

  Future<Map<String, List<Association>>> getMultipleFromLogins(
      {@required List<String> logins}) async {
    _logger.info('Executing function getMultipleFromLogins with args: logins=${logins}');

    if (logins.length == 0) return {};
    final String query = "SELECT * "
            "FROM ("
            "SELECT * FROM $name WHERE user_login IN (" +
        [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
        ")"
            ") AS $name JOIN ${AssociationsTable.name} "
            "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) "login$index": logins[index]
    }).then((sqlResults) {
      Map<String, List<Association>> mapListAssociationToUsers = {
        for (String login in logins) login: []
      };

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        mapListAssociationToUsers[result[name]['user_login']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToUsers;
    });
  }

  Future<Map<String, List<Association>>> getAllExceptOneFromLogin(
      {@required String login}) async {
    _logger.info('Executing function getAllExceptOneFromLogin with args: login=${login}');

    final String query = "SELECT * "
        "FROM ("
        "SELECT * FROM $name WHERE user_login != @login "
        ") AS $name JOIN ${AssociationsTable.name} "
        "ON (${AssociationsTable.name}.id = $name.association_id);";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      Map<String, List<Association>> mapListAssociationToUsers = {};

      for (Map<String, Map<String, dynamic>> result in sqlResults) {
        if (!mapListAssociationToUsers.keys.contains(result[name]['user_login'])) {
          mapListAssociationToUsers[result[name]['user_login']] = [];
        }
        mapListAssociationToUsers[result[name]['user_login']]
            .add(Association.fromJson(result[AssociationsTable.name]));
      }

      return mapListAssociationToUsers;
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
