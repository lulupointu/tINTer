import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_scolaire.dart';

List<RelationStatusScolaire> fakeListRelationStatusScolaire = [
  RelationStatusScolaire((r) => r
    ..login = fakeUsers[0].login
    ..otherLogin = fakeUsers[1].login
    ..statusScolaire = EnumRelationStatusScolaire.liked,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[0].login
      ..otherLogin = fakeUsers[2].login
      ..statusScolaire = EnumRelationStatusScolaire.none,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[0].login
      ..otherLogin = fakeUsers[3].login
      ..statusScolaire = EnumRelationStatusScolaire.ignored,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[0].login
      ..otherLogin = fakeUsers[4].login
      ..statusScolaire = EnumRelationStatusScolaire.askedBinome,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[1].login
      ..otherLogin = fakeUsers[0].login
      ..statusScolaire = EnumRelationStatusScolaire.askedBinome,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[2].login
      ..otherLogin = fakeUsers[0].login
      ..statusScolaire = EnumRelationStatusScolaire.ignored,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[3].login
      ..otherLogin = fakeUsers[0].login
      ..statusScolaire = EnumRelationStatusScolaire.acceptedBinome,
  ),
  RelationStatusScolaire(
        (r) => r
      ..login =  fakeUsers[4].login
      ..otherLogin = fakeUsers[0].login
      ..statusScolaire = EnumRelationStatusScolaire.refusedBinome,
  ),
];

class RelationsStatusScolaireTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_status_scolaire';
  final PostgreSQLConnection database;

  RelationsStatusScolaireTable({@required this.database});

  Future<void> create() async {
    final String statusTypeCreateQuery = """
    CREATE TYPE \"statusScolaire\" 
    AS ENUM ('none', 'ignored', 'liked', 'askedBinome', 'acceptedBinome', 'refusedBinome')
    """;
    final String createTableQuery = """
    CREATE TABLE $name (
      login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"otherLogin\" Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"statusScolaire\" Text NOT NULL,
      PRIMARY KEY (login, \"otherLogin\"),
      CHECK (login <> \"otherLogin\")
    );
    """;

    // This functions prevent anyone from modifying any field except
    // isValid which can only be changed from true to false.
    final String createConstraintFunctionQuery = """
    CREATE FUNCTION relation_status_scolaire_check() RETURNS trigger AS \$relation_status_scolaire_check\$
    DECLARE
      \"otherStatus\" Text;
    BEGIN
    
        SELECT \"statusScolaire\" INTO \"otherStatus\" FROM ${RelationsStatusScolaireTable.name} 
            WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            
            
        IF NEW.\"statusScolaire\" = 'ignored' THEN
          
          IF \"otherStatus\" = 'askedBinome' 
            OR \"otherStatus\" = 'acceptedBinome' 
            OR \"otherStatus\" = 'refusedBinome' 
            THEN
            UPDATE ${RelationsStatusScolaireTable.name} SET \"statusScolaire\"='liked' WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            DELETE FROM ${BinomePairsProfilesTable.name} WHERE \"login\"=NEW.login OR \"otherLogin\"=NEW.login;
          END IF;
          
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusScolaire\" = 'none' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusScolaire\" = 'ignored' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'liked' AND \"otherStatus\" = 'liked' AND NEW.\"statusScolaire\" = 'askedBinome' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'liked' AND \"otherStatus\" = 'askedBinome' AND
          (NEW.\"statusScolaire\" = 'acceptedBinome' OR NEW.\"statusScolaire\" = 'refusedBinome') THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusScolaire\" = 'askBinome' AND \"otherStatus\" = 'liked' AND NEW.\"statusScolaire\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        RAISE EXCEPTION 'Status % cannot be changed to % (the other \"statusScolaire\" is %).', 
          OLD.\"statusScolaire\", NEW.\"statusScolaire\", \"otherStatus\"
          USING errcode='invalid_parameter_value';
    END;
    \$relation_status_scolaire_check\$ LANGUAGE plpgsql;
    """;

    final String applyTableConstraintQuery = """
    CREATE TRIGGER relation_status_scolaire_check BEFORE UPDATE ON $name
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION relation_status_scolaire_check();
    """;

    await database.query(statusTypeCreateQuery);
    await database.query(createTableQuery);
    await database.query(createConstraintFunctionQuery);
    return database.query(applyTableConstraintQuery);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (RelationStatusScolaire relationStatus in fakeListRelationStatusScolaire)
        database.query("INSERT INTO $name VALUES (@login, @otherLogin, @statusScolaire);",
            substitutionValues: relationStatus.toJson())
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name;"),
      database.query("DROP TYPE IF EXISTS \"statusScolaire\";"),
      database.query("DROP FUNCTION IF EXISTS relation_status_scolaire_check;")
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required RelationStatusScolaire relationStatus}) async {
    final String query = "INSERT INTO $name VALUES (@login, @otherLogin, @statusScolaire);";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> addMultiple({@required List<RelationStatusScolaire> listRelationStatusScolaire}) async {
    if (listRelationStatusScolaire.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationStatusScolaire.length; index++)
            "(@login$index, @otherLogin$index, @statusScolaire$index)"
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
        "UPDATE $name SET \"statusScolaire\"=@statusScolaire WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> updateMultiple({@required List<RelationStatusScolaire> listRelationStatusScolaire}) async {
    if (listRelationStatusScolaire.length == 0) return;
    final String query = "UPDATE $name AS old SET \"statusScolaire\"=new.\"statusScolaire\" "
            "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationStatusScolaire.length; index++)
            "(@login$index, @otherLogin$index, @statusScolaire$index)"
        ].join(',') +
        ") AS new(login, \"otherLogin\", \"statusScolaire\")"
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
