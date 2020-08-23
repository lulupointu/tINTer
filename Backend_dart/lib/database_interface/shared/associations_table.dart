import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';

class AssociationsTable {
  // WARNING: the name must have only lower case letter.
  static final String name = 'associations';
  final PostgreSQLConnection database;

  AssociationsTable({@required this.database});

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      id SERIAL PRIMARY KEY,
      name Text UNIQUE NOT NULL,
      description Text NOT NULL
    );
    """;

    return database.query(query);
  }

  Future<void> populate() {
    var queries = <Future>[
      for (Association association in allAssociations)
        database.query("INSERT INTO $name VALUES (DEFAULT, @name, @description);",
            substitutionValues: {
              'name': association.name,
              'description': association.description,
            })
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required Association association}) async {
    final String query = "INSERT INTO $name VALUES (DEFAULT, @name, @description);";

    return database.query(query, substitutionValues: {
      'name': association.name,
      'description': association.description,
    });
  }

  Future<void> addMultiple({@required List<Association> associations}) async {
    if (associations.length==0) return;
    final String query = "INSERT INTO $name VALUES" +
        [
          for (int index = 0; index < associations.length; index++)
            "(DEFAULT, @name$index, @description$index, @logoUrl$index)"
        ].join(',') +
        ';';

    return database.query(query, substitutionValues: {
      for (int index = 0; index < associations.length; index++)
        ...associations[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<void> update(
      {@required Association oldAssociation, @required Association association}) async {
    final String query =
        "UPDATE $name SET name=@name, description=@description WHERE name=@old_name;";

    return database.query(query, substitutionValues: {
      'name': association.name,
      'description': association.description,
      'old_name': oldAssociation.name,
    });
  }

  Future<void> updateMultiple({@required List<Association> associations}) async {
    if (associations.length == 0) return;
    final String query =
        "UPDATE $name AS old SET name=new.name, description=new.description "
            "FROM (VALUES " +
            [
              for (int index = 0; index < associations.length; index++)
                "(@name$index, @description$index, @logoUrl$index)"
            ].join(',') +
            ") AS new(name, description)"
                "WHERE old.name=new.name;";

    return database.query(query, substitutionValues: {
      for (int index = 0; index < associations.length; index++)
        ...associations[index]
            .toJson()
            .map((String key, dynamic value) => MapEntry('$key$index', value))
    });
  }

  Future<Association> getFromName({@required Association association}) async {
    final String query = "SELECT * FROM $name WHERE name=@name;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'name': association.name,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
            'One association requested (${association.name} but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
            'One association requested (${association.name} but got ${sqlResults.length}');
      }

      return Association.fromJson(sqlResults[0][name]);
    });
  }

  Future<List<Association>> getMultipleFromName({@required List<Association> associations}) async {
    if (associations.length == 0) return [];
    final String query = """
    SELECT * FROM $name WHERE name IN (
    """ +
        [for (int index = 0; index < associations.length; index++) '@$index'].join(',') +
        ");";

    return database
        .mappedResultsQuery(
      query,
      substitutionValues: associations.asMap().map(
              (int key, Association association) => MapEntry(key.toString(), association.name)),
    )
        .then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: '${associations.length} association requested but got 0');
      }

      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          Association.fromJson(result[name])
      ];
    });
  }

  Future<int> getIdFromName({@required String associationName}) async {
    final String query = "SELECT id FROM $name WHERE name=@name;";

    return database.mappedResultsQuery(query, substitutionValues: {
      'name': associationName,
    }).then((sqlResults) {
      if (sqlResults.length > 1) {
        throw InvalidResponseToDatabaseQuery(
            error:
            'One association requested (${associationName} but got ${sqlResults.length}');
      } else if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error:
            'One association requested (${associationName} but got ${sqlResults.length}');
      }

      return sqlResults[0][name]['id'];
    });
  }

  Future<List<int>> getMultipleIdFromName({@required List<Association> associations}) async {
    if (associations.length == 0) return [];
    final String query = """
    SELECT id FROM $name WHERE name IN (
    """ +
        [for (int index = 0; index < associations.length; index++) '@$index'].join(',') +
        ");";

    return database
        .mappedResultsQuery(
      query,
      substitutionValues: associations.asMap().map(
              (int key, Association association) => MapEntry(key.toString(), association.name)),
    )
        .then((sqlResults) {
      if (sqlResults.length == 0) {
        throw EmptyResponseToDatabaseQuery(
            error: '${associations.length} association requested but got 0');
      }

      return [
        for (Map<String, Map<String, dynamic>> result in sqlResults)
          result[name]['id']
      ];
    });
  }

  Future<List<Association>> getAll() async {
    final String query = "SELECT * FROM $name";

    return database.mappedResultsQuery(query).then((sqlResults) {
      return sqlResults
          .map(
              (Map<String, Map<String, dynamic>> result) => Association.fromJson(result[name]))
          .toList();
    });
  }

  Future<void> remove({@required Association association}) async {
    final String query = "DELETE FROM $name WHERE name=@name;";

    return database.query(query, substitutionValues: {
      'name': association.name,
    });
  }

  Future<void> removeMultiple({@required List<Association> associations}) async {
    if (associations.length == 0) return;
    final String query = "DELETE FROM $name WHERE name IN (" +
        [for (int index = 0; index < associations.length; index++) '@$index'].join(',') +
        ");";

    return database.query(query,
        substitutionValues: associations.asMap().map((int key, Association associations) =>
            MapEntry(key.toString(), associations.name)));
  }

  Future<void> removeAll() {
    final String query = "DELETE FROM $name;";

    return database.query(query);
  }
}


Future<void> main() async {
  final tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  final associationTable = AssociationsTable(database: tinterDatabase.connection);
  await associationTable.delete();
  await associationTable.create();
  await associationTable.populate();

  // Test getters
  print(await associationTable.getAll());
  print(await associationTable.getFromName(association: allAssociations[0]));
  print(await associationTable
      .getMultipleFromName(associations: [allAssociations[1], allAssociations[2]]));

  // Test removers
  await associationTable.remove(association: allAssociations[0]);
  print(await associationTable.getAll());
  await associationTable
      .removeMultiple(associations: [allAssociations[1], allAssociations[2]]);
  print(await associationTable.getAll());
  await associationTable.removeAll();
  print(await associationTable.getAll());

  // Test adders
  await associationTable.add(association: allAssociations[0]);
  print(await associationTable.getAll());
  await associationTable.addMultiple(associations: [allAssociations[1], allAssociations[2]]);
  print(await associationTable.getAll());

  // Test update
  final newAssociation = Association.fromJson({
    'name': allAssociations[0].name,
    'description': 'brand new DESCRIPTION !',
  });
  await associationTable.update(
      oldAssociation: allAssociations[0], association: newAssociation);
  print(await associationTable.getAll());
  final newAssociation1 = Association.fromJson({
    'name': allAssociations[1].name,
    'description': 'brand new DESCRIPTION 1 !',
  });
  final newAssociation2 = Association.fromJson({
    'name': allAssociations[2].name,
    'description': 'brand new DESCRIPTION 2 !'
  });
  await associationTable.updateMultiple(associations: [newAssociation1, newAssociation2]);
  print(await associationTable.getFromName(association: allAssociations[0]));

  await tinterDatabase.close();
}