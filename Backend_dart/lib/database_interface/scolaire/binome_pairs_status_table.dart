import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/models/scolaire/relation_status_binome_pair.dart';

//List<RelationStatusBinomePair> fakeListRelationStatusBinomePair = [
//  RelationStatusBinomePair((r) => r
//    ..binomePairId = fakeUsers[0].binomePairId
//    ..otherBinomePairId = fakeUsers[1].binomePairId
//    ..status = EnumRelationStatusBinomePair.liked,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[2].binomePairId
//      ..status = EnumRelationStatusBinomePair.none,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[3].binomePairId
//      ..status = EnumRelationStatusBinomePair.ignored,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[0].binomePairId
//      ..otherBinomePairId = fakeUsers[4].binomePairId
//      ..status = EnumRelationStatusBinomePair.askedBinome,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[1].binomePairId
//      ..otherBinomePairId = fakeUsers[0].binomePairId
//      ..status = EnumRelationStatusBinomePair.askedBinome,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[2].binomePairId
//      ..otherBinomePairId = fakeUsers[0].binomePairId
//      ..status = EnumRelationStatusBinomePair.ignored,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[3].binomePairId
//      ..otherBinomePairId = fakeUsers[0].binomePairId
//      ..status = EnumRelationStatusBinomePair.acceptedBinome,
//  ),
//  RelationStatusBinomePair(
//        (r) => r
//      ..binomePairId =  fakeUsers[4].binomePairId
//      ..otherBinomePairId = fakeUsers[0].binomePairId
//      ..status = EnumRelationStatusBinomePair.refusedBinome,
//  ),
//];

class RelationsStatusBinomePairsMatchesTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'relations_status_binome_pair';
  final PostgreSQLConnection database;

  RelationsStatusBinomePairsMatchesTable({@required this.database});

  Future<void> create() async {
    final String statusTypeCreateQuery = """
    CREATE TYPE \"statusBinomePair\" 
    AS ENUM ('none', 'ignored', 'liked', 'askedBinomePairMatch', 'acceptedBinomePairMatch', 'refusedBinomePairMatch')
    """;
    final String createTableQuery = """
    CREATE TABLE $name (
      \"binomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      \"otherBinomePairId\" int NOT NULL REFERENCES ${BinomePairsProfilesTable.name} (\"binomePairId\") ON DELETE CASCADE,
      \"status\" \"statusBinomePair\" NOT NULL,
      PRIMARY KEY (\"binomePairId\", \"otherBinomePairId\"),
      CHECK (\"binomePairId\" <> \"otherBinomePairId\")
    );
    """;

    
    final String createConstraintFunctionQuery = """
    CREATE FUNCTION relation_status_binome_pair_check() RETURNS trigger AS \$relation_status_binome_pair_check\$
    DECLARE
      \"otherStatus\" Text;
    BEGIN
    
        SELECT \"status\" INTO \"otherStatus\" FROM ${RelationsStatusBinomePairsMatchesTable.name} 
            WHERE \"binomePairId\"=OLD.\"otherBinomePairId\" AND \"otherBinomePairId\"=OLD.\"binomePairId\";
            
            
        IF NEW.\"status\" = 'ignored' THEN
          
          IF \"otherStatus\" = 'askedBinomePair' 
            OR \"otherStatus\" = 'acceptedBinomePair' 
            OR \"otherStatus\" = 'refusedBinomePair' 
            THEN
            UPDATE ${RelationsStatusBinomePairsMatchesTable.name} SET \"status\"='liked' WHERE \"binomePairId\"=OLD.\"otherBinomePairId\" AND \"otherBinomePairId\"=OLD.\"binomePairId\";
          END IF;
          
          RETURN NEW;
        END IF;
            
        IF OLD.\"status\" = 'none' AND NEW.\"status\" = 'liked' THEN
          RETURN NEW;
        END IF;
            
        IF OLD.\"status\" = 'ignored' AND NEW.\"status\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"status\" = 'liked' AND \"otherStatus\" = 'liked' AND NEW.\"status\" = 'askedBinomePair' THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"status\" = 'liked' AND \"otherStatus\" = 'askedBinomePair' AND
          (NEW.\"status\" = 'acceptedBinomePair' OR NEW.\"status\" = 'refusedBinomePair') THEN
          RETURN NEW;
        END IF;
        
        IF OLD.\"status\" = 'askBinomePair' AND \"otherStatus\" = 'liked' AND NEW.\"status\" = 'liked' THEN
          RETURN NEW;
        END IF;
        
        RAISE EXCEPTION 'Status % cannot be changed to % (the other \"status\" is %).', 
          OLD.\"status\", NEW.\"status\", \"otherStatus\"
          USING errcode='invalid_parameter_value';
    END;
    \$relation_status_binome_pair_check\$ LANGUAGE plpgsql;
    """;

    final String applyTableConstraintQuery = """
    CREATE TRIGGER relation_status_binome_pair_check BEFORE UPDATE ON $name
    FOR EACH ROW
    WHEN (pg_trigger_depth() < 1)
    EXECUTE FUNCTION relation_status_binome_pair_check();
    """;

    await database.query(statusTypeCreateQuery);
    await database.query(createTableQuery);
    await database.query(createConstraintFunctionQuery);
    return database.query(applyTableConstraintQuery);
  }

//  Future<void> populate() {
//    var queries = <Future>[
//      for (RelationStatusBinomePair relationStatus in fakeListRelationStatusBinomePair)
//        database.query("INSERT INTO $name VALUES (@binomePairId, @otherBinomePairId, @status);",
//            substitutionValues: relationStatus.toJson())
//    ];
//
//    return Future.wait(queries);
//  }

  Future<void> delete() {
    final List<Future> queries = [
      database.query("DROP TABLE IF EXISTS $name;"),
      database.query("DROP TYPE IF EXISTS \"statusBinomePair\";"),
      database.query("DROP FUNCTION IF EXISTS relation_status_binome_pair_check;")
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required RelationStatusBinomePair relationStatus}) async {
    final String query = "INSERT INTO $name VALUES (@binomePairId, @otherBinomePairId, @status);";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> addMultiple({@required List<RelationStatusBinomePair> listRelationStatusBinomePair}) async {
    if (listRelationStatusBinomePair.length == 0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < listRelationStatusBinomePair.length; index++)
            "(@binomePairId$index, @otherBinomePairId$index, @status$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusBinomePair.length; index++)
        ...listRelationStatusBinomePair[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update({@required RelationStatusBinomePair relationStatus}) async {
    final String query =
        "UPDATE $name SET \"status\"=@status WHERE \"binomePairId\"=@binomePairId AND \"otherBinomePairId\"=@otherBinomePairId;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> updateMultiple({@required List<RelationStatusBinomePair> listRelationStatusBinomePair}) async {
    if (listRelationStatusBinomePair.length == 0) return;
    final String query = "UPDATE $name AS old SET \"status\"=new.\"status\" "
        "FROM (VALUES " +
        [
          for (int index = 0; index < listRelationStatusBinomePair.length; index++)
            "(@binomePairId$index, @otherBinomePairId$index, @status$index)"
        ].join(',') +
        ") AS new(\"binomePairId\", \"otherBinomePairId\", \"status\")"
            "WHERE (old.\"binomePairId\"=new.\"binomePairId\" AND old.\"otherBinomePairId\"=new.\"otherBinomePairId\");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusBinomePair.length; index++)
        ...listRelationStatusBinomePair[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<RelationStatusBinomePair> getFromBinomePairIds(
      {@required int binomePairId, @required int otherBinomePairId}) async {
    final String query =
        "SELECT * FROM $name WHERE \"binomePairId\"=@binomePairId AND \"otherBinomePairId\"=@otherBinomePairId;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
      'otherBinomePairId': otherBinomePairId,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
            'One relationStatus requested (between $binomePairId and $otherBinomePairId) but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
            'One relationStatus requested (between $binomePairId and $otherBinomePairId) but got ${sqlResults.length}');
      }

      return RelationStatusBinomePair.fromJson(sqlResults[0][name]);
    });
  }

  Future<Map<String, RelationStatusBinomePair>> getAllFromBinomePairId({@required String binomePairId}) async {
    final String query = """
    SELECT * FROM $name WHERE \"binomePairId\"=@binomePairId;
    """;

    return database.mappedResultsQuery(query, substitutionValues: {
      'binomePairId': binomePairId,
    }).then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: 'No relationStatus were found for this user');
      }

      return {
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          result[name]['otherBinomePairId']: RelationStatusBinomePair.fromJson(result[name])
      };
    });
  }

  Future<List<RelationStatusBinomePair>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map((Map<String, Map<String, dynamic>> result) =>
          RelationStatusBinomePair.fromJson(result[name]))
          .toList();
    });
  }

  Future<void> remove({@required RelationStatusBinomePair relationStatus}) async {
    final String query =
        "DELETE FROM $name WHERE \"binomePairId\"=@binomePairId AND \"otherBinomePairId\"=@otherBinomePairId;";

    return database.query(query, substitutionValues: relationStatus.toJson());
  }

  Future<void> removeMultiple({@required List<RelationStatusBinomePair> listRelationStatusBinomePair}) async {
    if (listRelationStatusBinomePair.length == 0) return;
    final String query = "DELETE FROM $name WHERE (\"binomePairId\", \"otherBinomePairId\") IN (" +
        [
          for (int index = 0; index < listRelationStatusBinomePair.length; index++)
            '(@binomePairId$index, @otherBinomePairId$index)'
        ].join(',') +
        ");";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < listRelationStatusBinomePair.length; index++) ...{
        'binomePairId$index': listRelationStatusBinomePair[index].binomePairId,
        'otherBinomePairId$index': listRelationStatusBinomePair[index].otherBinomePairId,
      }
    });
  }

  Future<void> removeBinomePairId({@required String binomePairId}) async {
    final String query = "DELETE FROM $name WHERE \"binomePairId\"=@binomePairId OR \"otherBinomePairId\"=@binomePairId;";

    return database.query(query, substitutionValues: {'binomePairId': binomePairId});
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}

