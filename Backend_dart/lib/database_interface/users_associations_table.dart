import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/student.dart';

class UsersAssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_associations';
  final PostgreSQLConnection database;
  final AssociationsTable associationsTable;

  UsersAssociationsTable({@required this.database, @required this.associationsTable});

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES users (login),
      association_id int NOT NULL REFERENCES associations (id),
      PRIMARY KEY (user_id, association_id)
    );
    """;

    return database.query(query);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE $name;
    """;

    return database.query(query);
  }

  Future<void> addFromLogin(
      {@required String login, @required Association association}) async {
    // get the association id from the association name
    int associationId = await associationsTable.getIdFromName(association: association);

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
        "FROM (SELECT $name WHERE login=@login)"
        "JOIN ${AssociationsTable.name} "
        "ON ${AssociationsTable.name}.id=$name.id;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          Association.fromJson(sqlResults[index][name])
      ];
    });
  }

  Future<void> removeAllFromLogin({@required String login}) {
    final String query = "DELETE FROM $name WHERE login=@login;";

    return database.query(query, substitutionValues: {
      'login': login,
    });
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}


