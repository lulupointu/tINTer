import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/profiles_table.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/session.dart';

List<Session> fakeSessions = [
  Session(
    token: 'fsdfnldsjflqm54fq64654F6Q4F654F566sf',
    login: fakeUsers[0].login,
    creationDate: DateTime(2020, DateTime.april, 1),
    isValid: false,
  ),
  Session(
    token: 'fsfsd54fsd124a65321aze564132xwc',
    login: fakeUsers[0].login,
    creationDate: DateTime(2020, DateTime.august, 1),
    isValid: true,
  ),
  Session(
    token: 'geh4fg65128DS94G132DF',
    login: fakeUsers[1].login,
    creationDate: DateTime(2020, DateTime.may, 1),
    isValid: false,
  ),
  Session(
    token: 'AZ78GDF1312HGFJ984U1538g6df7g9',
    login: fakeUsers[1].login,
    creationDate: DateTime(2020, DateTime.july, 1),
    isValid: true,
  ),
  Session(
    token: 'e8a7z9812b3vn216k79uh8153dqs',
    login: fakeUsers[1].login,
    creationDate: DateTime(2020, DateTime.april, 1),
    isValid: true,
  ),
  Session(
    token: 'd8z79g15df31gf68b79gn1654o3h15',
    login: fakeUsers[2].login,
    creationDate: DateTime(2020, DateTime.june, 1),
    isValid: false,
  ),
  Session(
    token: 'qd5468t4y1654TER98Y415345f68dsdf',
    login: fakeUsers[2].login,
    creationDate: DateTime(2020, DateTime.july, 1),
    isValid: true,
  ),
  Session(
    token: 'dsqd43153D4QSD46Q23d4sq6sd41q23s0d2D1SQ',
    login: fakeUsers[3].login,
    creationDate: DateTime(2020, DateTime.april, 1),
    isValid: false,
  ),
  Session(
    token: '8R7ZE965GF4B132886IK513521D3231xw13d64',
    login: fakeUsers[4].login,
    creationDate: DateTime(2020, DateTime.june, 1),
    isValid: true,
  ),
  Session(
    token: 'ds564g84u120cvb1n6846545645654C6XW54C8DS98451',
    login: fakeUsers[4].login,
    creationDate: DateTime(2020, DateTime.august, 1),
    isValid: true,
  ),
];

class SessionsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'sessions';
  final PostgreSQLConnection database;

  SessionsTable({@required this.database});

  Future<void> create() async {
    final String createTableQuery = """
    CREATE TABLE $name (
      token Text PRIMARY KEY,
      login Text NOT NULL REFERENCES ${StaticProfileTable.name} (login) ON DELETE CASCADE,
      \"creationDate\" Text NOT NULL,
      \"isValid\" Boolean NOT NULL
    );
    """;

    // This functions prevent anyone from modifying any field except
    // isValid which can only be changed from true to false.
    final String createConstraintFunctionQuery = """
    CREATE FUNCTION session_table_check() RETURNS trigger AS \$session_table_check\$
    BEGIN
        IF OLD.token != NEW.token THEN
            RAISE EXCEPTION 'token cannot be changed.';
        END IF;
        IF OLD.login != NEW.login THEN
            RAISE EXCEPTION 'name cannot be changed.';
        END IF;
        IF OLD.\"creationDate\" != NEW.\"creationDate\" THEN
            RAISE EXCEPTION 'creationDate cannot be changed.';
        END IF;
        IF (old.\"isValid\" = 'f') AND (old.\"isValid\" != new.\"isValid\") THEN
            RAISE EXCEPTION 'isValid cannot be changed from false to true.';
        END IF;
        
        RETURN NEW;
    END;
    \$session_table_check\$ LANGUAGE plpgsql;
    """;

    final String applyTableConstraintQuery = """
    CREATE TRIGGER session_table_check BEFORE UPDATE ON $name
    FOR EACH ROW EXECUTE FUNCTION session_table_check();
    """;

    await database.query(createTableQuery);
    await database.query(createConstraintFunctionQuery);
    return database.query(applyTableConstraintQuery);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (Session session in fakeSessions)
        database.query("INSERT INTO $name VALUES (@token, @login, @creationDate, @isValid);",
            substitutionValues: session.toJson())
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name;"),
      database.query("DROP FUNCTION IF EXISTS session_table_check;"),
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required Session session}) async {
    final String query = "INSERT INTO $name VALUES (@token, @login, @creationDate, @isValid);";

    return database.query(query, substitutionValues: session.toJson());
  }

  Future<void> addMultiple({@required List<Session> sessions}) async {
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < sessions.length; index++)
            "(@token$index, @login$index, @creationDate$index, @isValid$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < sessions.length; index++)
        ...sessions[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update({@required Session session}) async {
    final String query = "UPDATE $name "
        "SET token=@token, login=@login, \"creationDate\"=@creationDate, \"isValid\"=@isValid "
        "WHERE token=@token;";

    return database.query(query, substitutionValues: session.toJson());
  }

  Future<void> updateMultiple({@required List<Session> sessions}) async {
    final String query = "UPDATE $name AS old "
        "SET token=new.token, login=new.login, \"creationDate\"=new.\"creationDate\", \"isValid\"=new.\"isValid\" "
        "FROM (VALUES " +
        [
          for (int index = 0; index < sessions.length; index++)
            "(@token$index, @login$index, @creationDate$index, @isValid$index::boolean)"
        ].join(',') +
        ") AS new(token, login, \"creationDate\", \"isValid\") "
            "WHERE old.token=new.token;";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < sessions.length; index++)
        ...sessions[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> invalidAllFromLogin({@required String login}) async {
    final String query = "UPDATE $name AS old "
        "SET \"isValid\"='f' WHERE login=@login;";

    return database.query(query, substitutionValues: {'login': login
    });
  }


  Future<Session> getFromToken({@required String token}) async {
    final String query = "SELECT * FROM $name WHERE token=@token;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'token': token,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error: 'The token $token correspond to multiple sessions');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'No session associated with the token $token');
      }

      return Session.fromJson(sqlResults[0][name]);
    });
  }

  Future<List<Session>> getMultipleFromTokens({@required List<String> tokens}) async {
    final String query = "SELECT * FROM $name WHERE token IN (" +
        [for (int index = 0; index < tokens.length; index++) '@$index'].join(', ') +
        ");";

    return database
        .mappedResultsQuery(
      query,
      substitutionValues:
          tokens.asMap().map((int key, String token) => MapEntry(key.toString(), token)),
    )
        .then((sqlResults) {
      if (sqlResults.length != tokens.length) {
        throw EmptyResponseToDatabaseQuery(
            error: '${tokens.length} association requested but got 0');
      }

      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          Session.fromJson(result[name])
      ];
    });
  }

  Future<bool> isValidFromToken({@required String token}) async {
    final String query = "SELECT \"isValid\" FROM $name WHERE token=@token;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'token': token,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error: 'The token $token correspond to multiple sessions');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'No session associated with the token $token');
      }

      return sqlResults[0][name]['isValid'];
    });
  }

  Future<List<Session>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map((Map<String, Map<String, dynamic>> result) => Session.fromJson(result[name]))
          .toList();
    });
  }

  Future<void> removeFromToken({@required String token}) async {
    final String query = "DELETE FROM $name WHERE token=@token;";

    return database.query(query, substitutionValues: {
      'token': token,
    });
  }

  Future<void> removeMultipleFromTokens({@required List<String> tokens}) async {
    final String query = "DELETE FROM $name WHERE token IN (" +
        [for (int index = 0; index < tokens.length; index++) '@$index'].join(',') +
        ");";

    return database.query(query,
        substitutionValues:
            tokens.asMap().map((int key, String token) => MapEntry(key.toString(), token)));
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

Future<void> main() async {
  final tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final associationTable = SessionsTable(database: tinterDatabase.connection);
  await associationTable.delete();
  await associationTable.create();
  await associationTable.populate();

  // Test getters
  print(await associationTable.getAll());
  print(await associationTable.getFromToken(token: fakeSessions[0].token));
  print(await associationTable
      .getMultipleFromTokens(tokens: [fakeSessions[1].token, fakeSessions[2].token]));

  // Test removers
  await associationTable.removeFromToken(token: fakeSessions[0].token);
  print(await associationTable.getAll());
  await associationTable
      .removeMultipleFromTokens(tokens: [fakeSessions[1].token, fakeSessions[2].token]);
  print(await associationTable.getAll());
  await associationTable.removeAll();
  print(await associationTable.getAll());

  // Test adders
  await associationTable.add(session: fakeSessions[0]);
  print(await associationTable.getAll());
  await associationTable.addMultiple(sessions: [fakeSessions[1], fakeSessions[2], fakeSessions[3], fakeSessions[4]]);
  print(await associationTable.getAll());

  // Test update
  final newSession = Session(
    token: 'flidsjfljsdlfksd54f65sd13',
    login: fakeSessions[0].login,
    creationDate: fakeSessions[0].creationDate,
    isValid: false,
  );
  await associationTable.update(session: newSession);
  print(await associationTable.getAll());
  final newSession1 = Session(
    token: fakeSessions[1].token,
    login: fakeSessions[1].login,
    creationDate: fakeSessions[1].creationDate,
    isValid: false,
  );
  final newSession2 = Session(
    token: fakeSessions[2].token,
    login: fakeSessions[2].login,
    creationDate: fakeSessions[2].creationDate,
    isValid: false,
  );
  await associationTable.updateMultiple(sessions: [newSession1, newSession2]);
  print(await associationTable.getAll());
  await associationTable.invalidAllFromLogin(login: fakeUsers[1].login);
  print(await associationTable.getAll());

  await tinterDatabase.close();
}
