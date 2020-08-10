import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/student.dart';

class UsersGoutsMusicauxTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users_gouts_musicaux';
  final PostgreSQLConnection database;
  final GoutsMusicauxTable goutsMusicauxTable;

  UsersGoutsMusicauxTable({@required this.database, @required this.goutsMusicauxTable});

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      user_login Text NOT NULL REFERENCES users (login),
      gout_musical_id int NOT NULL REFERENCES gouts_musicaux (id),
      PRIMARY KEY (user_id, gout_musical_id)
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
      {@required String login, @required String goutMusical}) async {
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
        "FROM (SELECT $name WHERE login=@login)"
        "JOIN ${GoutsMusicauxTable.name} "
        "ON ${GoutsMusicauxTable.name}.id=$name.id;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      return [
        for (int index = 0; index < sqlResults.length; index++)
          sqlResults[index][name]['name']
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


