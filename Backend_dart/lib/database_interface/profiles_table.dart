import 'dart:math';

import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/users_associations_table.dart';
import 'package:tinter_backend/database_interface/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/gouts_musicaux.dart';
import 'package:tinter_backend/models/student.dart';
import 'package:tinter_backend/models/user.dart';

List<User> fakeUsers = [
  User.fromJson({
    'login': 'fake_delsol_l',
    'name': 'Lucas',
    'surname': 'Delsol',
    'email': 'lucas.delsol@telecom-sudparis.eu',
    'primoEntrant': false,
    'associations': [allAssociations[0], allAssociations[5]],
    'attiranceVieAsso': 0.9,
    'feteOuCours': 0.5,
    'aideOuSortir': 0.5,
    'organisationEvenements': 0.8,
    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
  }),
  User.fromJson({
    'login': 'fake_coste_va',
    'name': 'Valentine',
    'surname': 'Coste',
    'email': 'valentine.coste@telecom-sudparis.eu',
    'primoEntrant': false,
    'associations': [allAssociations[2], allAssociations[5]],
    'attiranceVieAsso': 0.6,
    'feteOuCours': 0.4,
    'aideOuSortir': 0.7,
    'organisationEvenements': 0.2,
    'goutsMusicaux': [allGoutsMusicaux[4]],
  }),
  User.fromJson({
    'login': 'fake_delsol_b',
    'name': 'Benoit',
    'surname': 'Delsol',
    'email': 'benoit.delsol@telecom-sudparis.eu',
    'primoEntrant': true,
    'associations': [allAssociations[1], allAssociations[4]],
    'attiranceVieAsso': 0.5,
    'feteOuCours': 0.3,
    'aideOuSortir': 0.12,
    'organisationEvenements': 0.45,
    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
  }),
  User.fromJson({
    'login': 'fake_delsol_h',
    'name': 'hugo',
    'surname': 'delsol',
    'email': 'hugo.delsol@telecom-sudparis.eu',
    'primoEntrant': true,
    'associations': [allAssociations[4], allAssociations[8]],
    'attiranceVieAsso': 0.65,
    'feteOuCours': 0.61,
    'aideOuSortir': 0.19,
    'organisationEvenements': 0.7,
    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
  }),
  User.fromJson({
    'login': 'fake_vannier',
    'name': 'emilien',
    'surname': 'vannier',
    'email': 'emilien.vannier@telecom_sudparis.eu',
    'primoEntrant': false,
    'associations': [allAssociations[1], allAssociations[9]],
    'attiranceVieAsso': 0.4,
    'feteOuCours': 0.6,
    'aideOuSortir': 0.4,
    'organisationEvenements': 0.2,
    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[7]],
  }),
];

class UsersTable {
  // WARNING: the name must have only lower case letter.
  final String name = 'users';
  final PostgreSQLConnection database;
  final UsersAssociationsTable usersAssociationsTable;
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;

  UsersTable({
    @required this.database,
    @required this.usersAssociationsTable,
    @required this.usersGoutsMusicauxTable,
  });

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      login Text PRIMARY KEY,
      name Text NOT NULL,
      surname Text NOT NULL,
      email Text NOT NULL,
      \"primoEntrant\" Boolean NOT NULL,
      \"attiranceVieAsso\" decimal NOT NULL CHECK (\"attiranceVieAsso\" >= 0 AND \"attiranceVieAsso\" <= 1),
      \"feteOuCours\" decimal NOT NULL CHECK (\"feteOuCours\" >= 0 AND \"feteOuCours\" <= 1),
      \"aideOuSortir\" decimal NOT NULL CHECK (\"aideOuSortir\" >= 0 AND \"aideOuSortir\" <= 1),
      \"organisationEvenements\" decimal NOT NULL CHECK (\"organisationEvenements\" >= 0 AND \"organisationEvenements\" <= 1),
    );
    """;

    return database.query(query);
  }

  Future<void> populate() async {
    // add students except their goutsMusicaux and their associations.
    // Note: we have to do this first in order not to break
    // the constraints on user association table and user gout musicaux table
    var queries = <Future>[
      for (Student user in fakeUsers)
        database.query(
            "INSERT INTO $name "
            "VALUES ("
            "@login,"
            "@name,"
            "@surname,"
            "@email,"
            "@primoEntrant,"
            "@attiranceVieAsso,"
            "@feteOuCours,"
            "@aideOuSortir,"
            "@organisationEvenements"
            ");",
            substitutionValues: {
              "login": user.login,
              "name": user.name,
              "surname": user.surname,
              "email": user.email,
              "primoEntrant": user.primoEntrant,
              "attiranceVieAsso": user.attiranceVieAsso,
              "feteOuCours": user.feteOuCours,
              "aideOuSortir": user.aideOuSortir,
              "organisationEvenements": user.organisationEvenements,
            })
    ];

    await Future.wait(queries);

    // add gout musicaux and associations
    var associationsQueries = <Future>[
      for (Student user in fakeUsers) ...[
        usersGoutsMusicauxTable.addMultipleFromLogin(
            login: user.login, goutsMusicaux: user.goutsMusicaux),
        usersAssociationsTable.addMultipleFromLogin(
            login: user.login, associations: user.associations)
      ]
    ];
    return Future.wait(associationsQueries);
  }

  Future<void> delete() {
    final String query = """
      DROP TABLE $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required User user}) async {
    // add user except his goutsMusicaux and his associations.
    // Note: we have to do this first in order not to break
    // the constraints on user association table and user gout musicaux table
    await database.query(
        "INSERT INTO $name "
        "VALUES ("
        "@login,"
        "@name,"
        "@surname,"
        "@email,"
        "@primoEntrant,"
        "@attiranceVieAsso,"
        "@feteOuCours,"
        "@aideOuSortir,"
        "@organisationEvenements"
        ");",
        substitutionValues: {
          "login": user.login,
          "name": user.name,
          "surname": user.surname,
          "email": user.email,
          "primoEntrant": user.primoEntrant,
          "attiranceVieAsso": user.attiranceVieAsso,
          "feteOuCours": user.feteOuCours,
          "aideOuSortir": user.aideOuSortir,
          "organisationEvenements": user.organisationEvenements,
        });

    // add gout musicaux and associations
    var queries = <Future>[
      usersGoutsMusicauxTable.addMultipleFromLogin(
          login: user.login, goutsMusicaux: user.goutsMusicaux),
      usersAssociationsTable.addMultipleFromLogin(
          login: user.login, associations: user.associations)
    ];
    return Future.wait(queries);
  }

  Future<void> update({@required User user}) async {
    final List<Future> queries = [
    database.query(
        "UPDATE $name "
            "SET"
            "\"attiranceVieAsso\"=@attiranceVieAsso,"
            "\"feteOuCours\"=@feteOuCours,"
            "\"aideOuSortir\"=@aideOuSortir,"
            "\"organisationEvenements\"=@organisationEvenements"
            "WHERE login=@login;",
        substitutionValues: {
          "login": user.login,
          "attiranceVieAsso": user.attiranceVieAsso,
          "feteOuCours": user.feteOuCours,
          "aideOuSortir": user.aideOuSortir,
          "organisationEvenements": user.organisationEvenements,
        }),
      usersAssociationsTable.updateUser(user),
      usersGoutsMusicauxTable.updateUser(user)
    ];

    return Future.wait(queries);
  }


  Future<Association> get({@required User user}) async {
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

  Future<List<Association>> getMultiple({@required List<Association> associations}) async {
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
  print(await associationTable.get(association: allAssociations[0]));
  print(await associationTable
      .getMultiple(associations: [allAssociations[1], allAssociations[2]]));

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
    'logoUrl': allAssociations[0].logoUrl,
  });
  await associationTable.update(
      oldAssociation: allAssociations[0], association: newAssociation);
  print(await associationTable.getAll());
  final newAssociation1 = Association.fromJson({
    'name': allAssociations[1].name,
    'description': 'brand new DESCRIPTION 1 !',
    'logoUrl': allAssociations[1].logoUrl,
  });
  final newAssociation2 = Association.fromJson({
    'name': allAssociations[2].name,
    'description': 'brand new DESCRIPTION 2 !',
    'logoUrl': allAssociations[2].logoUrl,
  });
  await associationTable.updateMultiple(associations: [newAssociation1, newAssociation2]);
  print(await associationTable.get(association: allAssociations[0]));

  await tinterDatabase.close();
}
