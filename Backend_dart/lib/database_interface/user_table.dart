import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/shared/user_shared_part.dart';

class UsersTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'users';
  final PostgreSQLConnection database;

  UsersTable({
    @required this.database,
  });

  Future<void> create() async {
    final List<Future> createTypeQueries = [
      database.query("CREATE TYPE School AS ENUM ('TSP', 'IMTBS');"),
      database.query("CREATE TYPE GroupeOuSeul AS ENUM ('groupe', 'seul');"),
      database.query("CREATE TYPE LieuDeVie AS ENUM ('maisel', 'other');"),
      database.query("CREATE TYPE OutilDeTravail AS ENUM ('online', 'faceToFace');"),
      database.query("CREATE TYPE TSPYear AS ENUM ('TSP1A', 'TSP2A', 'TSP3A');"),
    ];

    // This function ensures that only primoEntrant and year can be changed and that they can only be changed once
    final String createConstraintFunctionQuery = """
    CREATE FUNCTION constraints_check() RETURNS trigger AS \$constraints_check\$
    BEGIN
        IF OLD.login != NEW.login THEN
            RAISE EXCEPTION 'login cannot be changed.';
        END IF;
        IF OLD.name != NEW.name THEN
            RAISE EXCEPTION 'name cannot be changed.';
        END IF;
        IF OLD.surname != NEW.surname THEN
            RAISE EXCEPTION 'surname cannot be changed.';
        END IF;
        IF OLD.email != NEW.email THEN
            RAISE EXCEPTION 'email cannot be changed.';
        END IF;
        IF (NOT old.\"primoEntrant\" IS NULL) AND (old.\"primoEntrant\" != new.\"primoEntrant\") THEN
            RAISE EXCEPTION 'primoEntrant cannot be changed after having been set once.';
        END IF;
        IF (NOT old.year IS NULL) AND (old.year != new.year) THEN
            RAISE EXCEPTION 'year cannot be changed after having been set once.';
        END IF;

        RETURN NEW;
    END;
    \$constraints_check\$ LANGUAGE plpgsql;
    """;

    final String createTableQuery = """
    CREATE TABLE $name (
      login Text PRIMARY KEY,
      name Text NOT NULL,
      surname Text NOT NULL,
      email Text NOT NULL,
      school School NOT NULL,
      \"primoEntrant\" Boolean,
      year TSPYear,
      \"attiranceVieAsso\" DOUBLE PRECISION CHECK (\"attiranceVieAsso\" >= 0 AND \"attiranceVieAsso\" <= 1),
      \"feteOuCours\" DOUBLE PRECISION CHECK (\"feteOuCours\" >= 0 AND \"feteOuCours\" <= 1),
      \"aideOuSortir\" DOUBLE PRECISION CHECK (\"aideOuSortir\" >= 0 AND \"aideOuSortir\" <= 1),
      \"organisationEvenements\" DOUBLE PRECISION CHECK (\"organisationEvenements\" >= 0 AND \"organisationEvenements\" <= 1),
      \"groupeOuSeul\" GroupeOuSeul,
      \"lieuDeVie\" LieuDeVie,
      \"enligneOuNon\" OutilDeTravail
      );
    """;

    await Future.wait([
      ...createTypeQueries,
      database.query(createConstraintFunctionQuery),
    ]);

    return database.query(createTableQuery);
  }

  Future<void> delete() async {
    final List<Future> queries = [
      database.query("DROP FUNCTION IF EXISTS constraints_check"),
      database.query("DROP TYPE IF EXISTS School CASCADE;"),
      database.query("DROP TYPE IF EXISTS GroupeOuSeul CASCADE;"),
      database.query("DROP TYPE IF EXISTS LieuDeVie CASCADE;"),
      database.query("DROP TYPE IF EXISTS OutilDeTravail CASCADE;"),
      database.query("DROP TYPE IF EXISTS TSPYear CASCADE;"),
    ];

    await database.query("DROP TABLE IF EXISTS $name CASCADE;");

    return Future.wait(queries);
  }

  Future<void> add({@required Map<String, dynamic> userJson}) async {
    // Login is needed to identify the user
    assert(userJson.containsKey('login'));

    // Remove any useless input
    userJson.removeWhere((String key, dynamic value) => value == null || value is List);

    var queries = <Future>[
      database.query(
          "INSERT INTO $name "
                  "(" +
              userJson.keys.join(', ') +
              ") "
                  "VALUES (" +
              [for (String key in userJson.keys) '@$key'].join(', ') +
              ");",
          substitutionValues: userJson),
    ];

    return Future.wait(queries);
  }

  Future<void> update({@required Map<String, dynamic> userJson}) async {
    // Login is needed to identify the user
    assert(userJson.containsKey('login'));

    // Remove any useless input
    userJson.removeWhere((String key, dynamic value) => value == null || value is List);

    final List<Future> queries = [
      database.query(
          "UPDATE $name "
                  "SET " +
              [for (String key in userJson.keys) '\"$key\"=@$key'].join(', ') +
              " WHERE login=@login;",
          substitutionValues: userJson),
    ];

    return Future.wait(queries);
  }

  Future<Map<String, dynamic>> getFromLogin({@required String login}) async {
    final String query = "SELECT * FROM $name "
        "WHERE $name.login=@login;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((queriesResults) {
      if (queriesResults[0].length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'One profile requested (${login}) but got 0');
      }

      return queriesResults[0][name];
    });
  }

  Future<Map<String, Map<String, dynamic>>> getMultipleFromLogin(
      {@required List<String> logins}) async {
    if (logins.length == 0) return {};
    final String query = "SELECT * FROM $name "
            "WHERE $name.login IN (" +
        [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
        ");";

    return database.mappedResultsQuery(query, substitutionValues: {
      for (int index = 0; index < logins.length; index++) 'login$index': logins[index]
    }).then((queriesResults) {
      return {
        for (int index = 0; index < logins.length; index++)
          queriesResults[index][name]['login']: queriesResults[index][name]
      };
    });
  }

//  Future<Map<String, Map<String, dynamic>>> getAllExceptOneFromLogin(
//      {@required String login, @required primoEntrant}) async {
//    final String query = "SELECT * FROM $name "
//        "WHERE login<>@login AND \"primoEntrant\"=@primoEntrant;";
//
//    return database.mappedResultsQuery(query, substitutionValues: {
//      'login': login,
//      'primoEntrant': primoEntrant
//    }).then((queriesResults) {
//      return {
//        for (int index = 0; index < queriesResults.length; index++)
//          queriesResults[index][name]['login']: queriesResults[index][name]
//      };
//    });
//  }

  Future<void> remove({@required String login}) async {
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
