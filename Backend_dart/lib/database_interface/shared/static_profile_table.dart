//import 'package:postgres/postgres.dart';
//import 'package:tinter_backend/database_interface/database_interface.dart';
//import 'package:meta/meta.dart';
//import 'package:tinter_backend/models/shared/static_student.dart';
//
//List<StaticStudent> fakeStaticStudents = [
//  StaticStudent.fromJson({
//    'login': 'fake_delsol_l',
//    'name': 'Lucas',
//    'surname': 'Delsol',
//    'email': 'lucas.delsol@telecom-sudparis.eu',
//  }),
//  StaticStudent.fromJson({
//    'login': 'fake_coste_va',
//    'name': 'Valentine',
//    'surname': 'Coste',
//    'email': 'valentine.coste@telecom-sudparis.eu',
//  }),
//  StaticStudent.fromJson({
//    'login': 'fake_delsol_b',
//    'name': 'Benoit',
//    'surname': 'Delsol',
//    'email': 'benoit.delsol@telecom-sudparis.eu',
//  }),
//  StaticStudent.fromJson({
//    'login': 'fake_delsol_h',
//    'name': 'hugo',
//    'surname': 'delsol',
//    'email': 'hugo.delsol@telecom-sudparis.eu',
//  }),
//  StaticStudent.fromJson({
//    'login': 'fake_vannier',
//    'name': 'emilien',
//    'surname': 'vannier',
//    'email': 'emilien.vannier@telecom_sudparis.eu',
//  }),
//];
//
//class StaticProfileTable {
//  // WARNING: the name must have only lower case letter.
//  static final String name = 'static_profiles';
//  final PostgreSQLConnection database;
//
//  StaticProfileTable({@required this.database});
//
//  Future<void> create() async {
//    final String createTSPYearType = """
//    CREATE TYPE TSPYear AS ENUM ('TSP1A', 'TSP2A', 'TSP3A');
//    """;
//
//    final String createTableQuery = """
//    CREATE TABLE $name (
//      login Text UNIQUE NOT NULL,
//      name Text NOT NULL,
//      surname Text NOT NULL,
//      email Text NOT NULL,
//      \"primoEntrant\" Boolean,
//      year TSPYear,
//    );
//    """;
//
//    // This function ensures that only primoEntrant and year can be changed and that they can only be changed once
//    final String createConstraintFunctionQuery = """
//    CREATE FUNCTION constraints_check() RETURNS trigger AS \$constraints_check\$
//    BEGIN
//        IF OLD.login != NEW.login THEN
//            RAISE EXCEPTION 'login cannot be changed.';
//        END IF;
//        IF OLD.name != NEW.name THEN
//            RAISE EXCEPTION 'name cannot be changed.';
//        END IF;
//        IF OLD.surname != NEW.surname THEN
//            RAISE EXCEPTION 'surname cannot be changed.';
//        END IF;
//        IF OLD.email != NEW.email THEN
//            RAISE EXCEPTION 'email cannot be changed.';
//        END IF;
//        IF (NOT old.\"primoEntrant\" IS NULL) AND (old.\"primoEntrant\" != new.\"primoEntrant\") THEN
//            RAISE EXCEPTION 'primoEntrant cannot be changed after having been set once.';
//        END IF;
//        IF (NOT old.year IS NULL) AND (old.year != new.year) THEN
//            RAISE EXCEPTION 'year cannot be changed after having been set once.';
//        END IF;
//
//        RETURN NEW;
//    END;
//    \$constraints_check\$ LANGUAGE plpgsql;
//    """;
//
//    final String applyTableConstraintQuery = """
//    CREATE TRIGGER constraints_check BEFORE UPDATE ON $name
//    FOR EACH ROW EXECUTE FUNCTION constraints_check();
//    """;
//
//    await database.query(createTSPYearType);
//    await database.query(createTableQuery);
//    await database.query(createConstraintFunctionQuery);
//    return database.query(applyTableConstraintQuery);
//  }
//
//  Future<void> populate() {
//    var queries = <Future>[
//      for (StaticStudent staticProfile in fakeStaticStudents)
//        database.query(
//            "INSERT INTO $name VALUES (@login, @name, @surname, @email, @primoEntrant, @year);",
//            substitutionValues: {
//              'login': staticProfile.login,
//              'name': staticProfile.name,
//              'surname': staticProfile.surname,
//              'email': staticProfile.email,
//              'primoEntrant': staticProfile.primoEntrant
//            })
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<void> delete() {
//    final List<Future> queries = [
//      database.query("DROP TABLE IF EXISTS $name;"),
//      database.query("DROP FUNCTION IF EXISTS constraints_check;"),
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<void> add({@required StaticStudent staticProfile, bool primoEntrant, TSPYear year}) {
//    final String query =
//        "INSERT INTO $name VALUES (@login, @name, @surname, @email, @primoEntrant, @year);";
//
//    return database.query(query, substitutionValues: {
//      'login': staticProfile.login,
//      'name': staticProfile.name,
//      'surname': staticProfile.surname,
//      'email': staticProfile.email,
//      'primoEntrant': primoEntrant,
//      'year': year,
//    });
//  }
//
//  Future<void> addMultiple(
//      {@required List<StaticStudent> staticProfiles, List<bool> primoEntrants, List<
//          TSPYear> years,}) async {
//    if (staticProfiles.length == 0) return;
//    final String query = "INSERT INTO $name VALUES" +
//        [
//          for (int index = 0; index < staticProfiles.length; index++)
//            "(@login$index, @name$index, @surname$index, @email$index, @primoEntrant$index, @year$index)"
//        ].join(',') +
//        ';';
//
//    return database.query(query, substitutionValues: {
//    for (int index = 0; index < staticProfiles.length; index++)
//    ...{
//    ...staticProfiles[index]
//        .toJson()
//        .map((String key, dynamic value) => MapEntry('$key$index', value)),
//    'primoEntrant': primoEntrants[index],
//    'TSPYear': years[index];
//    }
//    });
//  }
//
//  Future<void> update(
//      {@required StaticStudent staticProfile, bool primoEntrant, TSPYear year}) async {
//    final String query =
//        "UPDATE $name SET login=@login, name=@name, surname=@surname, email=@email, \"primoEntrant\"=@primoEntrant, year=@year WHERE login=@login;";
//
//    return database.query(query, substitutionValues: {
//      'login': staticProfile.login,
//      'name': staticProfile.name,
//      'surname': staticProfile.surname,
//      'email': staticProfile.email,
//      'primoEntrant': primoEntrant,
//      'year': year,
//    });
//  }
//
//  Future<void> updateMultiple(
//      {@required List<StaticStudent> staticProfiles, List<bool> primoEntrants, List<
//          TSPYear> years}) async {
//    if (staticProfiles.length == 0) return;
//    final String query =
//        "UPDATE $name AS old SET login=new.login, name=new.name, surname=new.surname, email=new.email, \"primoEntrant\"=\"newPrimoEntrant\", year=new.year "
//            "FROM (VALUES " +
//            [
//              for (int index = 0; index < staticProfiles.length; index++)
//                "(@login$index, @name$index, @surname$index, @email$index, @primoEntrant$index :: boolean, @year$index :: TSPYear)"
//            ].join(',') +
//            ") AS new(login, name, surname, email, \"newPrimoEntrant\", year)"
//                "WHERE old.name=new.name;";
//
//    return database.query(query, substitutionValues: {
//      for (int index = 0; index < staticProfiles.length; index++)
//        ...{
//          ...staticProfiles[index]
//              .toJson()
//              .map((String key, dynamic value) => MapEntry('$key$index', value)),
//          'primoEntrant': primoEntrants[index],
//          'TSPYear': years[index],
//        }
//    });
//  }
//
//  Future<StaticStudent> getFromLogin({@required String login}) async {
//    final String query = "SELECT * FROM $name WHERE login=@login;";
//
//    return database.mappedResultsQuery(query, substitutionValues: {
//      'login': login,
//    }).then((sqlResults) {
//      if (sqlResults.length > 1) {
//        throw InvalidResponseToDatabaseQuery(
//            error: 'One staticProfile requested (${name} but got ${sqlResults.length}');
//      } else if (sqlResults.length == 0) {
//        throw EmptyResponseToDatabaseQuery(
//            error: 'One staticProfile requested (${name} but got ${sqlResults.length}');
//      }
//
//      return StaticStudent.fromJson(sqlResults[0][name]);
//    });
//  }
//
//  Future<List<StaticStudent>> getMultipleFromLogin({@required List<String> logins}) async {
//    if (logins.length == 0) return [];
//    final String query = """
//    SELECT * FROM $name WHERE login IN (
//    """ +
//        [for (int index = 0; index < logins.length; index++) '@$index'].join(',') +
//        ");";
//
//    return database
//        .mappedResultsQuery(
//      query,
//      substitutionValues:
//      logins.asMap().map((int key, String login) => MapEntry(key.toString(), login)),
//    )
//        .then((sqlResults) {
//      if (sqlResults.length == 0) {
//        throw EmptyResponseToDatabaseQuery(
//            error: '${logins.length} staticProfile requested but got 0');
//      }
//
//      return [
//        for (Map<String, Map<String, dynamic>> result in sqlResults)
//          StaticStudent.fromJson(result[name])
//      ];
//    });
//  }
//
//  Future<List<StaticStudent>> getAll() async {
//    final String query = "SELECT * FROM $name";
//
//    return database.mappedResultsQuery(query).then((sqlResults) {
//      return sqlResults
//          .map((Map<String, Map<String, dynamic>> result) =>
//          StaticStudent.fromJson(result[name]))
//          .toList();
//    });
//  }
//
//  Future<Map<String, StaticStudent>> getAllExceptOneFromLogin(
//      {@required String login, @required bool primoEntrant}) async {
//    final List<Future> queries = [
//      database.mappedResultsQuery(
//          "SELECT * FROM $name JOIN "
//              "WHERE login!=@login AND \"primoEntrant\"=@primoEntrant;",
//          substitutionValues: {
//            'login': login,
//            'primoEntrant': 'primoEntrant',
//          }),
//    ];
//
//    return Future.wait(queries).then((queriesResults) {
//      return {
//        for (int index = 0; index < queriesResults[0].length; index++)
//          queriesResults[0][index][name]['login']:
//          StaticStudent.fromJson(queriesResults[0][index][name])
//      };
//    });
//  }
//
//  Future<void> removeFromLogin({@required String login}) async {
//    final String query = "DELETE FROM $name WHERE login=@login;";
//
//    return database.query(query, substitutionValues: {
//      'login': login,
//    });
//  }
//
//  Future<void> removeMultiple({@required List<StaticStudent> staticProfiles}) async {
//    if (staticProfiles.length == 0) return;
//    final String query = "DELETE FROM $name WHERE login IN (" +
//        [for (int index = 0; index < staticProfiles.length; index++) '@$index'].join(',') +
//        ");";
//
//    return database.query(query,
//        substitutionValues: staticProfiles.asMap().map(
//                (int key, StaticStudent staticProfiles) =>
//                MapEntry(key.toString(), staticProfiles.login)));
//  }
//
//  Future<void> removeAll() {
//    final String query = "DELETE FROM $name;";
//
//    return database.query(query);
//  }
//}
//
//Future<void> main() async {
//  final tinterDatabase = TinterDatabase();
//  await tinterDatabase.open();
//
//  final staticProfileTable = StaticProfileTable(database: tinterDatabase.connection);
//  await staticProfileTable.delete();
//  await staticProfileTable.create();
//  await staticProfileTable.populate();
//
//  // Test getters
//  print(await staticProfileTable.getAll());
//  print(await staticProfileTable.getFromLogin(login: fakeStaticStudents[0].login));
//  print(await staticProfileTable.getMultipleFromLogin(
//      logins: [fakeStaticStudents[1].login, fakeStaticStudents[2].login]));
//
//  // Test removers
//  await staticProfileTable.removeFromLogin(login: fakeStaticStudents[0].login);
//  print(await staticProfileTable.getAll());
//  await staticProfileTable
//      .removeMultiple(staticProfiles: [fakeStaticStudents[1], fakeStaticStudents[2]]);
//  print(await staticProfileTable.getAll());
//  await staticProfileTable.removeAll();
//  print(await staticProfileTable.getAll());
//
//  // Test adders
//  await staticProfileTable.add(staticProfile: fakeStaticStudents[0]);
//  print(await staticProfileTable.getAll());
//  await staticProfileTable
//      .addMultiple(staticProfiles: [fakeStaticStudents[1], fakeStaticStudents[2]]);
//  print(await staticProfileTable.getAll());
//
//  // Test update
//  await staticProfileTable.updateMultiple(staticProfiles: [
//    StaticStudent(
//      login: fakeStaticStudents[0].login,
//      name: fakeStaticStudents[0].name,
//      surname: fakeStaticStudents[0].surname,
//      email: fakeStaticStudents[0].email,
//      primoEntrant: true,
//    ),
//    StaticStudent(
//      login: fakeStaticStudents[1].login,
//      name: fakeStaticStudents[1].name,
//      surname: fakeStaticStudents[1].surname,
//      email: fakeStaticStudents[1].email,
//      primoEntrant: true,
//    ),
//    StaticStudent(
//      login: fakeStaticStudents[2].login,
//      name: fakeStaticStudents[2].name,
//      surname: fakeStaticStudents[2].surname,
//      email: fakeStaticStudents[2].email,
//      primoEntrant: true,
//    ),
//    StaticStudent(
//      login: fakeStaticStudents[3].login,
//      name: fakeStaticStudents[3].name,
//      surname: fakeStaticStudents[3].surname,
//      email: fakeStaticStudents[3].email,
//      primoEntrant: true,
//    ),
//    StaticStudent(
//      login: fakeStaticStudents[4].login,
//      name: fakeStaticStudents[4].name,
//      surname: fakeStaticStudents[4].surname,
//      email: fakeStaticStudents[4].email,
//      primoEntrant: true,
//    )
//  ]);
//
//  await tinterDatabase.close();
//}
