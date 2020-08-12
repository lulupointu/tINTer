import 'dart:convert';
import 'dart:math';

import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/static_profile_table.dart';
import 'package:tinter_backend/database_interface/users_associations_table.dart';
import 'package:tinter_backend/database_interface/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/gouts_musicaux.dart';
import 'package:tinter_backend/models/student.dart';
import 'package:tinter_backend/models/user.dart';

List<User> fakeUsers = [
  User.fromJson({
    'login': fakeStaticStudents[0].login,
    'name': fakeStaticStudents[0].name,
    'surname': fakeStaticStudents[0].surname,
    'email': fakeStaticStudents[0].email,
    'primoEntrant': fakeStaticStudents[0].primoEntrant,
    'associations': [allAssociations[0], allAssociations[5]],
    'attiranceVieAsso': 0.9,
    'feteOuCours': 0.5,
    'aideOuSortir': 0.5,
    'organisationEvenements': 0.8,
    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
  }),
  User.fromJson({
    'login': fakeStaticStudents[1].login,
    'name': fakeStaticStudents[1].name,
    'surname': fakeStaticStudents[1].surname,
    'email': fakeStaticStudents[1].email,
    'primoEntrant': fakeStaticStudents[1].primoEntrant,
    'associations': [allAssociations[2], allAssociations[5]],
    'attiranceVieAsso': 0.6,
    'feteOuCours': 0.4,
    'aideOuSortir': 0.7,
    'organisationEvenements': 0.2,
    'goutsMusicaux': [allGoutsMusicaux[4]],
  }),
  User.fromJson({
    'login': fakeStaticStudents[2].login,
    'name': fakeStaticStudents[2].name,
    'surname': fakeStaticStudents[2].surname,
    'email': fakeStaticStudents[2].email,
    'primoEntrant': fakeStaticStudents[2].primoEntrant,
    'associations': [allAssociations[1], allAssociations[4]],
    'attiranceVieAsso': 0.5,
    'feteOuCours': 0.3,
    'aideOuSortir': 0.12,
    'organisationEvenements': 0.45,
    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
  }),
  User.fromJson({
    'login': fakeStaticStudents[3].login,
    'name': fakeStaticStudents[3].name,
    'surname': fakeStaticStudents[3].surname,
    'email': fakeStaticStudents[3].email,
    'primoEntrant': fakeStaticStudents[3].primoEntrant,
    'associations': [allAssociations[4], allAssociations[8]],
    'attiranceVieAsso': 0.65,
    'feteOuCours': 0.61,
    'aideOuSortir': 0.19,
    'organisationEvenements': 0.7,
    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
  }),
  User.fromJson({
    'login': fakeStaticStudents[4].login,
    'name': fakeStaticStudents[4].name,
    'surname': fakeStaticStudents[4].surname,
    'email': fakeStaticStudents[4].email,
    'primoEntrant': fakeStaticStudents[4].primoEntrant,
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
  static final String name = 'users';
  final PostgreSQLConnection database;
  final StaticProfileTable staticProfileTable;
  final UsersAssociationsTable usersAssociationsTable;
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;

  UsersTable({
    @required this.database,
    @required this.staticProfileTable,
    @required this.usersAssociationsTable,
    @required this.usersGoutsMusicauxTable,
  });

  Future<void> create() {
    final String query = """
    CREATE TABLE $name (
      login Text PRIMARY KEY REFERENCES ${StaticProfileTable.name} (login),
      \"attiranceVieAsso\" DOUBLE PRECISION NOT NULL CHECK (\"attiranceVieAsso\" >= 0 AND \"attiranceVieAsso\" <= 1),
      \"feteOuCours\" DOUBLE PRECISION NOT NULL CHECK (\"feteOuCours\" >= 0 AND \"feteOuCours\" <= 1),
      \"aideOuSortir\" DOUBLE PRECISION NOT NULL CHECK (\"aideOuSortir\" >= 0 AND \"aideOuSortir\" <= 1),
      \"organisationEvenements\" DOUBLE PRECISION NOT NULL CHECK (\"organisationEvenements\" >= 0 AND \"organisationEvenements\" <= 1)
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
            "@attiranceVieAsso,"
            "@feteOuCours,"
            "@aideOuSortir,"
            "@organisationEvenements"
            ");",
            substitutionValues: {
              "login": user.login,
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
      DROP TABLE IF EXISTS $name;
    """;

    return database.query(query);
  }

  Future<void> add({@required User user}) async {
    var queries = <Future>[
      database.query(
          "INSERT INTO $name "
          "VALUES ("
          "@login,"
          "@attiranceVieAsso,"
          "@feteOuCours,"
          "@aideOuSortir,"
          "@organisationEvenements"
          ");",
          substitutionValues: {
            "login": user.login,
            "attiranceVieAsso": user.attiranceVieAsso,
            "feteOuCours": user.feteOuCours,
            "aideOuSortir": user.aideOuSortir,
            "organisationEvenements": user.organisationEvenements,
          }),
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

  Future<User> getFromLogin({@required String login}) async {
    final List<Future> queries = [
      database.mappedResultsQuery(
          "SELECT * FROM $name JOIN ${StaticProfileTable.name} "
          "ON $name.login=${StaticProfileTable.name}.login "
          "WHERE $name.login=@login;",
          substitutionValues: {
            'login': login,
          }),
      usersAssociationsTable.getFromLogin(login: login),
      usersGoutsMusicauxTable.getFromLogin(login: login),
    ];

    return Future.wait(queries).then((queriesResults) {
      return User.fromJson({
        ...queriesResults[0][0][name],
        ...queriesResults[0][0][StaticProfileTable.name],
        ...{'associations': queriesResults[1], 'goutsMusicaux': queriesResults[2]}
      });
    });
  }

  Future<Map<String, User>> getMultipleFromLogin({@required List<String> logins}) async {
    final List<Future> queries = [
      database.mappedResultsQuery(
          "SELECT * FROM $name JOIN ${StaticProfileTable.name} "
              "ON $name.login=${StaticProfileTable.name}.login "
              "WHERE $name.login IN (" +
              [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
              ");",
          substitutionValues: {
            for (int index = 0; index < logins.length; index++) 'login$index': logins[index]
          }),
      usersAssociationsTable.getMultipleFromLogins(logins: logins),
      usersGoutsMusicauxTable.getMultipleFromLogins(logins: logins),
    ];

    return Future.wait(queries).then((queriesResults) {
      return {
        for (int index = 0; index < logins.length; index++)
          queriesResults[0][index][name]['login']: User.fromJson({
            ...queriesResults[0][index][name],
            ...queriesResults[0][index][StaticProfileTable.name],
            ...{
              'associations': queriesResults[1][queriesResults[0][index][name]['login']],
              'goutsMusicaux': queriesResults[2][queriesResults[0][index][name]['login']]
            }
          })
      };
    });
  }

//  Future<List<Student>> getAll() async {
//    final String query = "SELECT * FROM $name";
//
//    return database.mappedResultsQuery(query).then((sqlResults) {
//      return sqlResults
//          .map(
//              (Map<String, Map<String, dynamic>> result) => Association.fromJson(result[name]))
//          .toList();
//    });
//  }

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
