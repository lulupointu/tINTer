import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/relation_status_associatif.dart';

List<RelationStatusAssociatif> fakeListRelationStatusAssociatif = [
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[1].login
      ..status = EnumRelationStatusAssociatif.liked,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[2].login
      ..status = EnumRelationStatusAssociatif.none,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[3].login
      ..status = EnumRelationStatusAssociatif.ignored,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[0].login
      ..otherLogin = fakeUsers[4].login
      ..status = EnumRelationStatusAssociatif.askedParrain,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[1].login
      ..otherLogin = fakeUsers[0].login
      ..status = EnumRelationStatusAssociatif.askedParrain,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[2].login
      ..otherLogin = fakeUsers[0].login
      ..status = EnumRelationStatusAssociatif.ignored,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[3].login
      ..otherLogin = fakeUsers[0].login
      ..status = EnumRelationStatusAssociatif.acceptedParrain,
  ),
  RelationStatusAssociatif(
    (r) => r
      ..login = fakeUsers[4].login
      ..otherLogin = fakeUsers[0].login
      ..status = EnumRelationStatusAssociatif.refusedParrain,
  ),
];

final _logger = Logger('RelationsStatusAssociatifTable');

class RelationsStatusAssociatifTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relation_status_associatif';
  final PostgreSQLConnection database;

  RelationsStatusAssociatifTable({@required this.database});

  Future<void> create() async {
    _logger.info('Executing function create.');

    final String statusTypeCreateQuery = """
    CREATE TYPE \"statusAssociatif\" 
    AS ENUM ('none', 'ignored', 'liked', 'askedParrain', 'acceptedParrain', 'refusedParrain')
    """;
    final String createTableQuery = """
    CREATE TABLE $name (
      login Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"otherLogin\" Text NOT NULL REFERENCES ${UsersTable.name} (login) ON DELETE CASCADE,
      \"statusAssociatif\" Text NOT NULL,
      PRIMARY KEY (login, \"otherLogin\"),
      CHECK (login <> \"otherLogin\")
    );
    """;


    final String createConstraintFunctionQuery = """
    CREATE FUNCTION relation_status_associatif_check() RETURNS trigger AS \$relation_status_associatif_check\$
    DECLARE
      \"otherStatus\" Text;
    BEGIN
    
        SELECT \"statusAssociatif\" INTO \"otherStatus\" FROM ${RelationsStatusAssociatifTable.name} 
            WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
            
            
        IF NEW.\"statusAssociatif\" = 'ignored' THEN
          
          IF \"otherStatus\" = 'askedParrain' 
            OR \"otherStatus\" = 'acceptedParrain' 
            OR \"otherStatus\" = 'refusedParrain' 
            THEN
            UPDATE ${RelationsStatusAssociatifTable.name} SET \"statusAssociatif\"='liked' WHERE login=OLD.\"otherLogin\" AND \"otherLogin\"=OLD.login;
          END IF;
          
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusAssociatif\" = 'none' AND NEW.\"statusAssociatif\" = 'liked' THEN
          RETURN NEW;
        END IF;
            
        IF OLD.\"statusAssociatif\" = 'ignored' AND NEW.\"statusAssociatif\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusAssociatif\" = 'liked' AND \"otherStatus\" = 'liked' AND NEW.\"statusAssociatif\" = 'askedParrain' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusAssociatif\" = 'liked' AND \"otherStatus\" = 'askedParrain' AND
          (NEW.\"statusAssociatif\" = 'acceptedParrain' OR NEW.\"statusAssociatif\" = 'refusedParrain') THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"statusAssociatif\" = 'askParrain' AND \"otherStatus\" = 'liked' AND NEW.\"statusAssociatif\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        RAISE EXCEPTION 'Status % cannot be changed to % (the other \"statusAssociatif\" is %).', 
          OLD.\"statusAssociatif\", NEW.\"statusAssociatif\", \"otherStatus\"
          USING errcode='invalid_parameter_value';
    END;
    \$relation_status_associatif_check\$ LANGUAGE plpgsql;
    """;

    final String applyTableConstraintQuery = """
    CREATE TRIGGER relation_status_associatif_check BEFORE UPDATE ON $name
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION relation_status_associatif_check();
    """;

    await database.query(statusTypeCreateQuery);
    await database.query(createTableQuery);
    await database.query(createConstraintFunctionQuery);
    return database.query(applyTableConstraintQuery);
  }

  Future<void> populate() {
    _logger.info('Executing function populate.');

    var queries = <Future>[
      for (RelationStatusAssociatif relationStatus in fakeListRelationStatusAssociatif)
        database.query("INSERT INTO $name VALUES (@login, @otherLogin, @status);",
            substitutionValues: relationStatus.toJson())
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    _logger.info('Executing function delete.');

    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name CASCADE;"),
      database.query("DROP TYPE IF EXISTS \"statusAssociatif\" CASCADE;"),
      database.query("DROP FUNCTION IF EXISTS relation_status_associatif_check CASCADE;")
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required RelationStatusAssociatif relationStatus}) async {
    _logger.info('Executing function add with args: relationStatus=${relationStatus}');

    final String query = "INSERT INTO $name VALUES (@login, @otherLogin, @status);";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> addMultiple(
      {@required List<RelationStatusAssociatif> listRelationStatusAssociatif}) async {
    _logger.info('Executing function addMultiple with args: listRelationStatusAssociatif=${listRelationStatusAssociatif}');

    if (listRelationStatusAssociatif.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationStatusAssociatif.length; index++)
            "(@login$index, @otherLogin$index, @status$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusAssociatif.length; index++)
        ...listRelationStatusAssociatif[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update({@required RelationStatusAssociatif relationStatus}) async {
    _logger.info('Executing function update with args: relationStatus=${relationStatus}');

    final String query =
        "UPDATE $name SET \"statusAssociatif\"=@status WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> updateMultiple(
      {@required List<RelationStatusAssociatif> listRelationStatusAssociatif}) async {
    _logger.info('Executing function updateMultiple with args: listRelationStatusAssociatif=${listRelationStatusAssociatif}');

    if (listRelationStatusAssociatif.length == 0) return;
    final String query =
        "UPDATE $name AS old SET \"statusAssociatif\"=new.\"statusAssociatif\" "
                "FROM (VALUES " +
            [
              for (int index = 0; index < listRelationStatusAssociatif.length; index++)
                "(@login$index, @otherLogin$index, @status$index)"
            ].join(',') +
            ") AS new(login, \"otherLogin\", \"statusAssociatif\")"
                "WHERE (old.login=new.login AND old.\"otherLogin\"=new.\"otherLogin\");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusAssociatif.length; index++)
        ...listRelationStatusAssociatif[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<RelationStatusAssociatif> getFromLogins(
      {@required String login, @required String otherLogin}) async {
    _logger.info('Executing function getFromLogins with args: login=${login}, otherLogin=${otherLogin}');

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

      return RelationStatusAssociatif.fromJson({
        'login': sqlResults[0][name]['login'],
        'otherLogin': sqlResults[0][name]['otherLogin'],
        'status': sqlResults[0][name]['statusAssociatif'],
      });
    });
  }

  Future<Map<String, RelationStatusAssociatif>> getAllFromLogin(
      {@required String login}) async {
    _logger.info('Executing function getAllFromLogin with args: login=${login}');

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
          result[name]['otherLogin']: RelationStatusAssociatif.fromJson({
            'login': result[name]['login'],
            'otherLogin': result[name]['otherLogin'],
            'status': result[name]['statusAssociatif'],
          })
      };
    });
  }

  Future<List<RelationStatusAssociatif>> getAll() async {
    _logger.info('Executing function getAll.');

    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map(
              (Map<String, Map<String, dynamic>> result) => RelationStatusAssociatif.fromJson({
                    'login': result[name]['login'],
                    'otherLogin': result[name]['otherLogin'],
                    'status': result[name]['statusAssociatif'],
                  }))
          .toList();
    });
  }

  Future<void> remove({@required RelationStatusAssociatif relationStatus}) async {
    _logger.info('Executing function remove with args: relationStatus=${relationStatus}');

    final String query =
        "DELETE FROM $name WHERE login=@login AND \"otherLogin\"=@otherLogin;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> removeMultiple(
      {@required List<RelationStatusAssociatif> listRelationStatusAssociatif}) async {
    _logger.info('Executing function removeMultiple with args: listRelationStatusAssociatif=${listRelationStatusAssociatif}');

    if (listRelationStatusAssociatif.length == 0) return;
    final String query = "DELETE FROM $name WHERE (login, \"otherLogin\") IN (" +
        [
          for (int index = 0; index < listRelationStatusAssociatif.length; index++)
            '(@login$index, @otherLogin$index)'
        ].join(',') +
        ");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusAssociatif.length; index++) ...{
        'login$index': listRelationStatusAssociatif[index].login,
        'otherLogin$index': listRelationStatusAssociatif[index].otherLogin,
      }
    });
  }

  Future<void> removeLogin({@required String login}) async {
    _logger.info('Executing function removeLogin with args: login=${login}');

    final String query = "DELETE FROM $name WHERE login=@login OR \"otherLogin\"=@login;";

    return database.query(query, substitutionValues: {'login': login});
  }

  Future<void> removeAll() {
    _logger.info('Executing function removeAll.');

    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

//Future<void> main() async {
//  final tinterDatabase = TinterDatabase();
//  await tinterDatabase.open();
//
//  final relationStatusTable = RelationsStatusAssociatifTable(database: tinterDatabase.connection);
//  await relationStatusTable.delete();
//  await relationStatusTable.create();
//  await relationStatusTable.populate();
//
//  // Test getters
//  print(await relationStatusTable.getAll());
//  print(await relationStatusTable.getFromLogins(
//      login: fakeUsers[0].login, otherLogin: fakeUsers[1].login));
//  print(await relationStatusTable.getAllFromLogin(login: fakeUsers[0].login));
//
//  // Test removers
//  await relationStatusTable.remove(relationStatus: fakeListRelationStatusAssociatif[0]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable.removeMultiple(
//      listRelationStatusAssociatif: [fakeListRelationStatusAssociatif[1], fakeListRelationStatusAssociatif[2]]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable.removeAll();
//  print(await relationStatusTable.getAll());
//
//  // Test adders
//  await relationStatusTable.add(relationStatus: fakeListRelationStatusAssociatif[0]);
//  print(await relationStatusTable.getAll());
//  await relationStatusTable
//      .addMultiple(listRelationStatusAssociatif: [fakeListRelationStatusAssociatif[1], fakeListRelationStatusAssociatif[2]]);
//  print(await relationStatusTable.getAll());
//
//  // Test update
//  final newRelation = RelationStatusAssociatif(
//    login: fakeUsers[0].login,
//    otherLogin: fakeUsers[1].login,
//    status: EnumRelationStatusAssociatif.none,
//  );
//  await relationStatusTable.update(relationStatus: newRelation);
//  print(await relationStatusTable.getAll());
//  final newRelation1 = RelationStatusAssociatif(
//    login: fakeUsers[0].login,
//    otherLogin: fakeUsers[2].login,
//    status: EnumRelationStatusAssociatif.acceptedParrain,
//  );
//  final newRelation2 = RelationStatusAssociatif(
//    login: fakeUsers[0].login,
//    otherLogin: fakeUsers[3].login,
//    status: EnumRelationStatusAssociatif.refusedParrain,
//  );
//  await relationStatusTable.updateMultiple(listRelationStatusAssociatif: [newRelation1, newRelation2]);
//  print(await relationStatusTable.getAll());
//
//  await tinterDatabase.close();
//}
