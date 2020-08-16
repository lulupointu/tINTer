import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/student.dart';

class UsersAssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_associations';
  final PostgreSQLConnection database;
  final AssociationsTable associationsTable;

  UsersAssociationsTable({@required this.database})
      : associationsTable = AssociationsTable(database: database);

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES ${StaticProfileTable.name} (login) ON DELETE CASCADE,
      association_id int NOT NULL REFERENCES associations (id),
      PRIMARY KEY (user_login, association_id)
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

  Future<void> addFromLogin(
      {@required String login, @required Association association}) async {
    // get the association id from the association name
    int associationId = await associationsTable.getIdFromName(associationName: association.name);

    final String query = "INSERT INTO $name VALUES (@login, @associationId);";

    return database.query(query, substitutionValues: {
      'login': login,
      'associationId': associationId,
    });
  }

  Future<void> addMultipleFromLogin(
      {@required login, @required List<Association> associations}) async {
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
      for (int index = 0; index < associations.length; index++) ...{
        'login': login,
        'associationId$index': associationsIds[index],
      }
    });
  }

  Future<void> updateUser(Student user) async {
    await removeAllFromLogin(login: user.login);

    return addMultipleFromLogin(login: user.login, associations: user.associations);
  }

  Future<List<Association>> getFromLogin({@required String login}) async {
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
