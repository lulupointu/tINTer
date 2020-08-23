import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';

//List<RelationStatusScolaire> fakeListRelationStatusScolaire = [
//  RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[1].login,
//    status: EnumRelationStatusScolaire.liked,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[2].login,
//    status: EnumRelationStatusScolaire.none,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[3].login,
//    status: EnumRelationStatusScolaire.ignored,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[4].login,
//    status: EnumRelationStatusScolaire.askedBinome,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[1].login,
//    otherLogin: fakeStaticStudents[0].login,
//    status: EnumRelationStatusScolaire.askedBinome,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[2].login,
//    otherLogin: fakeStaticStudents[0].login,
//    status: EnumRelationStatusScolaire.ignored,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[3].login,
//    otherLogin: fakeStaticStudents[0].login,
//    status: EnumRelationStatusScolaire.acceptedBinome,
//  ),
//  RelationStatusScolaire(
//    login: fakeStaticStudents[4].login,
//    otherLogin: fakeStaticStudents[0].login,
//    status: EnumRelationStatusScolaire.refusedBinome,
//  ),
//];

class RelationsStatusScolaireTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_status_scolaire';
  final PostgreSQLConnection database;

  RelationsStatusScolaireTable({@required this.database});

  Future<void> create() async {
    final String statusTypeCreateQuery = """
    CREATE TYPE status 
    AS ENUM ('none', 'ignored', 'liked', 'askedBinome', 'acceptedBinome', 'refusedBinome')
    """;
    final String createTableQuery = """
    CREATE TABLE $name (
      login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"otherLogin\" Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      status Text NOT NULL,
      PRIMARY KEY (login, \"otherLogin\"),
      CHECK (login <> \"otherLogin\")
    );
    """;

    // This functions prevent anyone from modifying any field except
    // isValid which can only be changed from true to false.
    final String createConstraintFunctionQuery = """
    CREATE FUNCTION relation_status_check() RETURNS trigger AS \$relation_status_check\$
    DECLARE
      \"otherStatus\" Text;
    BEGIN
    
        SELECT status INTO \"otherStatus\" FROM ${RelationsStatusScolaireTable.name} 
            WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            
            
        IF NEW.status = 'ignored' THEN
          
          IF \"otherStatus\" = 'askedBinome' 
            OR \"otherStatus\" = 'acceptedBinome' 
            OR \"otherStatus\" = 'refusedBinome' 
            THEN
            UPDATE ${RelationsStatusScolaireTable.name} SET status='liked' WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
          END IF;
          
          RETURN NEW;
        END IF;
            
        IF OLD.status = 'none' AND NEW.status = 'liked' THEN
          RETURN NEW;
        END IF;
            
        IF OLD.status = 'ignored' AND NEW.status = 'liked' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.status = 'liked' AND \"otherStatus\" = 'liked' AND NEW.status = 'askedBinome' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.status = 'liked' AND \"otherStatus\" = 'askedBinome' AND
          (NEW.status = 'acceptedBinome' OR NEW.status = 'refusedBinome') THEN
          RETURN NEW;
        END IF;
        
        IF OLD.status = 'askBinome' AND \"otherStatus\" = 'liked' AND NEW.status = 'liked' THEN
          RETURN NEW;
        END IF;
        
        RAISE EXCEPTION 'Status % cannot be changed to % (the other status is %).', 
          OLD.status, NEW.status, \"otherStatus\"
          USING errcode='invalid_parameter_value';
    END;
    \$relation_status_check\$ LANGUAGE plpgsql;
    """;

    final String applyTableConstraintQuery = """
    CREATE TRIGGER relation_status_check BEFORE UPDATE ON $name
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION relation_status_check();
    """;

    await database.query(statusTypeCreateQuery);
    await database.query(createTableQuery);
    await database.query(createConstraintFunctionQuery);
    return database.query(applyTableConstraintQuery);
  }

//  Future<void> populate() {
//    var queries = <Future>[
//      for (RelationStatusScolaire relationStatus in fakeListRelationStatusScolaire)
//        database.query("INSERT INTO $name VALUES (@login, @otherLogin, @status);",
//            substitutionValues: relationStatus.toJson())
//    ];
//
//    return Future.wait(queries);
//  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name;"),
      database.query("DROP TYPE IF EXISTS status;"),
      database.query("DROP FUNCTION IF EXISTS relation_status_check;")
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required RelationStatusScolaire relationStatus}) async {
    final String query = "INSERT INTO $name VALUES (@login, @otherLogin, @status);";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> addMultiple({@required List<RelationStatusScolaire> listRelationStatusScolaire}) async {
    if (listRelationStatusScolaire.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationStatusScolaire.length; index++)
            "(@login$index, @otherLogin$index, @status$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusScolaire.length; index++)
        ...listRelationStatusScolaire[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update({@required RelationStatusScolaire relationStatus}) async {
    final String query =
        "UPDATE $name SET status=@status WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> updateMultiple({@required List<RelationStatusScolaire> listRelationStatusScolaire}) async {
    if (listRelationStatusScolaire.length == 0) return;
    final String query = "UPDATE $name AS old SET status=new.status "
            "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationStatusScolaire.length; index++)
            "(@login$index, @otherLogin$index, @status$index)"
        ].join(',') +
        ") AS new(login, \"otherLogin\", status)"
            "WHERE (old.login=new.login AND old.\"otherLogin\"=new.\"otherLogin\");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusScolaire.length; index++)
        ...listRelationStatusScolaire[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<RelationStatusScolaire> getFromLogins(
      {@required String login, @required String otherLogin}) async {
    final String query =
        "SELECT * FROM $name WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
      'otherLogin': otherLogin,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
                'One relationStatus requested (between $login and $otherLogin) but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
                'One relationStatus requested (between $login and $otherLogin) but got ${sqlResults.length}');
      }

      return RelationStatusScolaire.fromJson(sqlResults[0][name]);
    });
  }

  Future<Map<String, RelationStatusScolaire>> getAllFromLogin({@required String login}) async {
    final String query = """
    SELECT * FROM $name WHERE login=@login;
    """;

    return database.mappedResultsQuery(query, substitutionValues: {
      'login': login,
    }).then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'No relationStatus were found for this user');
      }

      return {
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          result[name]['otherLogin']: RelationStatusScolaire.fromJson(result[name])
      };
    });
  }

  Future<List<RelationStatusScolaire>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map((Map<String, Map<String, dynamic>> result) =>
              RelationStatusScolaire.fromJson(result[name]))
          .toList();
    });
  }

  Future<void> remove({@required RelationStatusScolaire relationStatus}) async {
    final String query =
        "DELETE FROM $name WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> removeMultiple({@required List<RelationStatusScolaire> listRelationStatusScolaire}) async {
    if (listRelationStatusScolaire.length == 0) return;
    final String query = "DELETE FROM $name WHERE (login, \"otherLogin\") IN (" +
        [
          for (int index = 0; index < listRelationStatusScolaire.length; index++)
            '(@login$index, @otherLogin$index)'
        ].join(',') +
        ");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusScolaire.length; index++) ...{
        'login$index': listRelationStatusScolaire[index].login,
        'otherLogin$index': listRelationStatusScolaire[index].otherLogin,
      }
    });
  }

  Future<void> removeLogin({@required String login}) async {
    final String query = "DELETE FROM $name WHERE login=@login OR \"otherLogin\"=@login;";

    return database.query(query, substitutionValues: {'login': login});
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

//Future<void> main() async {
//  final tinterDatabase = TinterDatabase();
//  await tinterDatabase.open();
//
//  final relationStatusTable = RelationsStatusScolaireTable(database: tinterDatabase.connection);
//  await relationStatusTable.delete();
//  await relationStatusTable.create();
//  await relationStatusTable.populate();
//
//  // Test getters
//  print(await relationStatusTable.getAll());
//  print(await relationStatusTable.getFromLogins(
//      login: fakeStaticStudents[0].login, otherLogin: fakeStaticStudents[1].login));
//  print(await relationStatusTable.getAllFromLogin(login: fakeStaticStudents[0].login));
//
//  // Test removers
//  await relationStatusTable.remove(relationStatus: fakeListRelationStatusScolaire[0]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable.removeMultiple(
//      listRelationStatusScolaire: [fakeListRelationStatusScolaire[1], fakeListRelationStatusScolaire[2]]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable.removeAll();
//  print(await relationStatusTable.getAll());
//
//  // Test adders
//  await relationStatusTable.add(relationStatus: fakeListRelationStatusScolaire[0]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable
//      .addMultiple(listRelationStatusScolaire: [fakeListRelationStatusScolaire[1], fakeListRelationStatusScolaire[2]]);
//  print(await relationStatusTable.getAll());
//
//  // Test update
//  final newRelation = RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[1].login,
//    status: EnumRelationStatusScolaire.none,
//  );
//  await relationStatusTable.update(relationStatus: newRelation);
//  print(await relationStatusTable.getAll());
//  final newRelation1 = RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[2].login,
//    status: EnumRelationStatusScolaire.acceptedBinome,
//  );
//  final newRelation2 = RelationStatusScolaire(
//    login: fakeStaticStudents[0].login,
//    otherLogin: fakeStaticStudents[3].login,
//    status: EnumRelationStatusScolaire.refusedBinome,
//  );
//  await relationStatusTable.updateMultiple(listRelationStatusScolaire: [newRelation1, newRelation2]);
//  print(await relationStatusTable.getAll());
//
//  await tinterDatabase.close();
//}
