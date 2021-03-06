//import 'dart:convert';
//
//import 'package:built_value/serializer.dart';
//import 'package:postgres/postgres.dart';
//import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
//import 'package:tinter_backend/database_interface/shared/user_shared_part_table.dart';
//import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
//import 'package:tinter_backend/database_interface/user_table.dart';
//import 'package:tinter_backend/models/associatif/association.dart';
//import 'package:tinter_backend/models/associatif/gouts_musicaux.dart';
//import 'package:meta/meta.dart';
//import 'package:tinter_backend/models/serializers.dart';
//import 'package:built_value/src/bool_serializer.dart';
//import 'package:tinter_backend/models/shared/user.dart';
//
//class UsersAssociatifsTable {
//  final UsersTable usersTable;
//  final UsersAssociationsTable usersAssociationsTable;
//  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;
//  final PostgreSQLConnection database;
//
//  UsersAssociatifsTable({@required this.database})
//      : usersTable = UsersTable(database: database),
//        usersAssociationsTable = UsersAssociationsTable(database: database),
//        usersGoutsMusicauxTable = UsersGoutsMusicauxTable(database: database);
//
//  Future<void> populate() {
//    final List<Future> queries = [
//      for (BuildUser userAssociatif in fakeUsersAssociatifs)
//        update(userAssociatif: userAssociatif)
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<void> update({@required BuildUser userAssociatif}) {
//    final Map<String, dynamic> userAssociatifJson = userAssociatif.toJson();
//
//    final List<Future> queries = [
//      usersTable.update(userJson: userAssociatifJson),
//      usersAssociationsTable.updateUser(
//          login: userAssociatif.login, associations: userAssociatif.associations.toList()),
//      usersGoutsMusicauxTable.updateUser(
//          login: userAssociatif.login, goutsMusicaux: userAssociatif.goutsMusicaux.toList()),
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<BuildUser> getFromLogin({@required String login}) async {
//    final List<Future> queries = [
//      usersTable.getFromLogin(login: login),
//      usersAssociationsTable.getFromLogin(login: login),
//      usersGoutsMusicauxTable.getFromLogin(login: login),
//    ];
//
//    List queriesResults = await Future.wait(queries);
//
//    return BuildUser.fromJson({
//      ...queriesResults[0],
//      'associations': queriesResults[1].map((Association association) => association.toJson()),
//      'goutsMusicaux': queriesResults[2],
//    });
//  }
//
//  Future<Map<String, BuildUser>> getAllExceptOneFromLogin(
//      {@required String login, @required bool primoEntrant}) async {
//    final Map<String, Map<String, dynamic>> otherUsersJson = await database.mappedResultsQuery(
//        "SELECT * FROM ${UsersTable.name} "
//        "WHERE login<>@login AND \"primoEntrant\"<>@primoEntrant;",
//        substitutionValues: {
//          'login': login,
//          'primoEntrant': primoEntrant
//        }).then((queriesResults) {
//      return {
//        for (int index = 0; index < queriesResults.length; index++)
//          queriesResults[index][UsersTable.name]['login']: queriesResults[index]
//              [UsersTable.name]
//      };
//    });
//
//    final List<Future> queries = [
//      usersAssociationsTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
//      usersGoutsMusicauxTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
//    ];
//
//    List queriesResults = await Future.wait(queries);
//
//    return {
//      for (String login in otherUsersJson.keys)
//        login: BuildUser.fromJson({
//          ...otherUsersJson[login],
//          'associations':
//              queriesResults[0][login].map((Association association) => association.toJson()),
//          'goutsMusicaux': queriesResults[1][login],
//        })
//    };
//  }
//
//  Future<void> removeFromLogin(String login) {
//    return usersTable.remove(login: login);
//  }
//}
//
//List<BuildUser> fakeUsersAssociatifs = [
//  BuildUser.fromJson({
//    'login': fakeUsers[0].login,
//    'name': fakeUsers[0].name,
//    'surname': fakeUsers[0].surname,
//    'email': fakeUsers[0].email,
//    'school': fakeUsers[0].school.serialize(),
//    'associations': fakeUsers[0].associations.map((Association association) => association.toJson()),
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.9,
//    'feteOuCours': 0.5,
//    'aideOuSortir': 0.5,
//    'organisationEvenements': 0.8,
//    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
//  }),
//  BuildUser.fromJson({
//    'login': fakeUsers[1].login,
//    'name': fakeUsers[1].name,
//    'surname': fakeUsers[1].surname,
//    'email': fakeUsers[1].email,
//    'school': fakeUsers[1].school.serialize(),
//    'associations': fakeUsers[1].associations.map((Association association) => association.toJson()),
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.6,
//    'feteOuCours': 0.4,
//    'aideOuSortir': 0.7,
//    'organisationEvenements': 0.2,
//    'goutsMusicaux': [allGoutsMusicaux[4]],
//  }),
//  BuildUser.fromJson({
//    'login': fakeUsers[2].login,
//    'name': fakeUsers[2].name,
//    'surname': fakeUsers[2].surname,
//    'email': fakeUsers[2].email,
//    'school': fakeUsers[2].school.serialize(),
//    'associations': fakeUsers[2].associations.map((Association association) => association.toJson()),
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.5,
//    'feteOuCours': 0.3,
//    'aideOuSortir': 0.12,
//    'organisationEvenements': 0.45,
//    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
//  }),
//  BuildUser.fromJson({
//    'login': fakeUsers[3].login,
//    'name': fakeUsers[3].name,
//    'surname': fakeUsers[3].surname,
//    'email': fakeUsers[3].email,
//    'school': fakeUsers[3].school.serialize(),
//    'associations': fakeUsers[3].associations.map((Association association) => association.toJson()),
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.65,
//    'feteOuCours': 0.61,
//    'aideOuSortir': 0.19,
//    'organisationEvenements': 0.7,
//    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
//  }),
//  BuildUser.fromJson({
//    'login': fakeUsers[4].login,
//    'name': fakeUsers[4].name,
//    'surname': fakeUsers[4].surname,
//    'email': fakeUsers[4].email,
//    'school': fakeUsers[4].school.serialize(),
//    'associations': fakeUsers[4].associations.map((Association association) => association.toJson()),
//    'primoEntrant': false,
//    'attiranceVieAsso': 0.4,
//    'feteOuCours': 0.6,
//    'aideOuSortir': 0.4,
//    'organisationEvenements': 0.2,
//    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[7]],
//  }),
//];
//
////import 'dart:convert';
////import 'dart:math';
////
////import 'package:postgres/postgres.dart';
////import 'package:tinter_backend/database_interface/database_interface.dart';
////import 'package:tinter_backend/database_interface/shared/static_profile_table.dart';
////import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
////import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
////import 'package:tinter_backend/models/associatif/association.dart';
////import 'package:meta/meta.dart';
////import 'package:tinter_backend/models/associatif/gouts_musicaux.dart';
////import 'package:tinter_backend/models/associatif/user_associatif.dart';
////
////List<User> fakeUsers = [
////  User.fromJson({
////    'login': fakeStaticStudents[0].login,
////    'name': fakeStaticStudents[0].name,
////    'surname': fakeStaticStudents[0].surname,
////    'email': fakeStaticStudents[0].email,
////    'primoEntrant': fakeStaticStudents[0].primoEntrant,
////    'associations': [allAssociations[0], allAssociations[5]],
////    'attiranceVieAsso': 0.9,
////    'feteOuCours': 0.5,
////    'aideOuSortir': 0.5,
////    'organisationEvenements': 0.8,
////    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
////  }),
////  User.fromJson({
////    'login': fakeStaticStudents[1].login,
////    'name': fakeStaticStudents[1].name,
////    'surname': fakeStaticStudents[1].surname,
////    'email': fakeStaticStudents[1].email,
////    'primoEntrant': fakeStaticStudents[1].primoEntrant,
////    'associations': [allAssociations[2], allAssociations[5]],
////    'attiranceVieAsso': 0.6,
////    'feteOuCours': 0.4,
////    'aideOuSortir': 0.7,
////    'organisationEvenements': 0.2,
////    'goutsMusicaux': [allGoutsMusicaux[4]],
////  }),
////  User.fromJson({
////    'login': fakeStaticStudents[2].login,
////    'name': fakeStaticStudents[2].name,
////    'surname': fakeStaticStudents[2].surname,
////    'email': fakeStaticStudents[2].email,
////    'primoEntrant': fakeStaticStudents[2].primoEntrant,
////    'associations': [allAssociations[1], allAssociations[4]],
////    'attiranceVieAsso': 0.5,
////    'feteOuCours': 0.3,
////    'aideOuSortir': 0.12,
////    'organisationEvenements': 0.45,
////    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
////  }),
////  User.fromJson({
////    'login': fakeStaticStudents[3].login,
////    'name': fakeStaticStudents[3].name,
////    'surname': fakeStaticStudents[3].surname,
////    'email': fakeStaticStudents[3].email,
////    'primoEntrant': fakeStaticStudents[3].primoEntrant,
////    'associations': [allAssociations[4], allAssociations[8]],
////    'attiranceVieAsso': 0.65,
////    'feteOuCours': 0.61,
////    'aideOuSortir': 0.19,
////    'organisationEvenements': 0.7,
////    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
////  }),
////  User.fromJson({
////    'login': fakeStaticStudents[4].login,
////    'name': fakeStaticStudents[4].name,
////    'surname': fakeStaticStudents[4].surname,
////    'email': fakeStaticStudents[4].email,
////    'primoEntrant': fakeStaticStudents[4].primoEntrant,
////    'associations': [allAssociations[1], allAssociations[9]],
////    'attiranceVieAsso': 0.4,
////    'feteOuCours': 0.6,
////    'aideOuSortir': 0.4,
////    'organisationEvenements': 0.2,
////    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[7]],
////  }),
////];
////
////class UsersAssociatifsTable {
////  // WARNING: the name must have only lower case letter.
////  static final String name = 'users_associatifs';
////  final PostgreSQLConnection database;
////  final StaticProfileTable staticProfileTable;
////  final UsersAssociationsTable usersAssociationsTable;
////  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;
////
////  UsersAssociatifsTable({
////    @required this.database,
////  })  : staticProfileTable = StaticProfileTable(database: database),
////        usersAssociationsTable = UsersAssociationsTable(database: database),
////        usersGoutsMusicauxTable = UsersGoutsMusicauxTable(database: database);
////
////  Future<void> create() {
////    final String query = """
////    CREATE TABLE $name (
////      login Text PRIMARY KEY REFERENCES ${StaticProfileTable.name} (login) ON DELETE CASCADE,
////      \"attiranceVieAsso\" DOUBLE PRECISION NOT NULL CHECK (\"attiranceVieAsso\" >= 0 AND \"attiranceVieAsso\" <= 1),
////      \"feteOuCours\" DOUBLE PRECISION NOT NULL CHECK (\"feteOuCours\" >= 0 AND \"feteOuCours\" <= 1),
////      \"aideOuSortir\" DOUBLE PRECISION NOT NULL CHECK (\"aideOuSortir\" >= 0 AND \"aideOuSortir\" <= 1),
////      \"organisationEvenements\" DOUBLE PRECISION NOT NULL CHECK (\"organisationEvenements\" >= 0 AND \"organisationEvenements\" <= 1)
////    );
////    """;
////
////    return database.query(query);
////  }
////
////  Future<void> populate() async {
////    // add students except their goutsMusicaux and their associations.
////    // Note: we have to do this first in order not to break
////    // the constraints on user association table and user gout musicaux table
////    var queries = <Future>[
////      for (User user in fakeUsers)
////        database.query(
////            "INSERT INTO $name "
////            "VALUES ("
////            "@login,"
////            "@attiranceVieAsso,"
////            "@feteOuCours,"
////            "@aideOuSortir,"
////            "@organisationEvenements"
////            ");",
////            substitutionValues: {
////              "login": user.login,
////              "attiranceVieAsso": user.attiranceVieAsso,
////              "feteOuCours": user.feteOuCours,
////              "aideOuSortir": user.aideOuSortir,
////              "organisationEvenements": user.organisationEvenements,
////            })
////    ];
////
////    await Future.wait(queries);
////
////    // add gout musicaux and associations
////    var associationsQueries = <Future>[
////      for (User user in fakeUsers) ...[
////        usersGoutsMusicauxTable.addMultipleFromLogin(
////            login: user.login, goutsMusicaux: user.goutsMusicaux),
////        usersAssociationsTable.addMultipleFromLogin(
////            login: user.login, associations: user.associations)
////      ]
////    ];
////    return Future.wait(associationsQueries);
////  }
////
////  Future<void> delete() {
////    final String query = """
////      DROP TABLE IF EXISTS $name;
////    """;
////
////    return database.query(query);
////  }
////
////  Future<void> add({@required User user}) async {
////    var queries = <Future>[
////      database.query(
////          "INSERT INTO $name "
////          "VALUES ("
////          "@login,"
////          "@attiranceVieAsso,"
////          "@feteOuCours,"
////          "@aideOuSortir,"
////          "@organisationEvenements"
////          ");",
////          substitutionValues: {
////            "login": user.login,
////            "attiranceVieAsso": user.attiranceVieAsso,
////            "feteOuCours": user.feteOuCours,
////            "aideOuSortir": user.aideOuSortir,
////            "organisationEvenements": user.organisationEvenements,
////          }),
////      usersGoutsMusicauxTable.addMultipleFromLogin(
////          login: user.login, goutsMusicaux: user.goutsMusicaux),
////      usersAssociationsTable.addMultipleFromLogin(
////          login: user.login, associations: user.associations)
////    ];
////
////    return Future.wait(queries);
////  }
////
////  Future<void> update({@required User user}) async {
////    final List<Future> queries = [
////      database.query(
////          "UPDATE $name "
////          "SET"
////          "\"attiranceVieAsso\"=@attiranceVieAsso,"
////          "\"feteOuCours\"=@feteOuCours,"
////          "\"aideOuSortir\"=@aideOuSortir,"
////          "\"organisationEvenements\"=@organisationEvenements "
////          "WHERE login=@login;",
////          substitutionValues: {
////            "login": user.login,
////            "attiranceVieAsso": user.attiranceVieAsso,
////            "feteOuCours": user.feteOuCours,
////            "aideOuSortir": user.aideOuSortir,
////            "organisationEvenements": user.organisationEvenements,
////          }),
////      usersAssociationsTable.updateUser(login: user.login, associations: user.associations),
////      usersGoutsMusicauxTable.updateUser(user)
////    ];
////
////    return Future.wait(queries);
////  }
////
////  Future<User> getFromLogin({@required String login}) async {
////    final List<Future> queries = [
////      database.mappedResultsQuery(
////          "SELECT * FROM $name JOIN ${StaticProfileTable.name} "
////          "ON $name.login=${StaticProfileTable.name}.login "
////          "WHERE $name.login=@login;",
////          substitutionValues: {
////            'login': login,
////          }),
////      usersAssociationsTable.getFromLogin(login: login),
////      usersGoutsMusicauxTable.getFromLogin(login: login),
////    ];
////
////    return Future.wait(queries).then((queriesResults) {
////      if (queriesResults[0].length == 0) {
////        throw EmptyResponseToDatabaseQuery(
////            error: 'One staticProfile requested (${name} but got 0');
////      }
////
////      return User.fromJson({
////        ...queriesResults[0][0][name],
////        ...queriesResults[0][0][StaticProfileTable.name],
////        ...{'associations': queriesResults[1], 'goutsMusicaux': queriesResults[2]}
////      });
////    });
////  }
////
////  Future<Map<String, User>> getMultipleFromLogin({@required List<String> logins}) async {
////    if (logins.length==0) return {};
////    final List<Future> queries = [
////      database.mappedResultsQuery(
////          "SELECT * FROM $name JOIN ${StaticProfileTable.name} "
////                  "ON $name.login=${StaticProfileTable.name}.login "
////                  "WHERE $name.login IN (" +
////              [for (int index = 0; index < logins.length; index++) "@login$index"].join(',') +
////              ");",
////          substitutionValues: {
////            for (int index = 0; index < logins.length; index++) 'login$index': logins[index]
////          }),
////      usersAssociationsTable.getMultipleFromLogins(logins: logins),
////      usersGoutsMusicauxTable.getMultipleFromLogins(logins: logins),
////    ];
////
////    return Future.wait(queries).then((queriesResults) {
////      return {
////        for (int index = 0; index < logins.length; index++)
////          queriesResults[0][index][name]['login']: User.fromJson({
////            ...queriesResults[0][index][name],
////            ...queriesResults[0][index][StaticProfileTable.name],
////            ...{
////              'associations': queriesResults[1][queriesResults[0][index][name]['login']],
////              'goutsMusicaux': queriesResults[2][queriesResults[0][index][name]['login']]
////            }
////          })
////      };
////    });
////  }
////
////  Future<Map<String, User>> getAllExceptOneFromLogin({@required String login, @required bool primoEntrant}) async {
////    final List<Future> queries = [
////      database.mappedResultsQuery(
////          "SELECT * FROM $name JOIN ${StaticProfileTable.name} "
////          "ON $name.login=${StaticProfileTable.name}.login "
////          "WHERE $name.login!=@login AND ${StaticProfileTable.name}.\"primoEntrant\"=@primoEntrant;",
////          substitutionValues: {
////            'login': login,
////            'primoEntrant': primoEntrant,
////          }),
////      usersAssociationsTable.getAllExceptOneFromLogin(login: login),
////      usersGoutsMusicauxTable.getAllExceptOneFromLogin(login: login),
////    ];
////
////    return Future.wait(queries).then((queriesResults) {
////      return {
////        for (int index = 0; index < queriesResults[0].length; index++)
////          queriesResults[0][index][name]['login']: User.fromJson({
////            ...queriesResults[0][index][name],
////            ...queriesResults[0][index][StaticProfileTable.name],
////            ...{
////              'associations': queriesResults[1][queriesResults[0][index][name]['login']],
////              'goutsMusicaux': queriesResults[2][queriesResults[0][index][name]['login']],
////            }
////          })
////      };
////    });
////  }
////
////  Future<void> remove({@required String login}) async {
////    final String query = "DELETE FROM $name WHERE login=@login;";
////
////    return Future.wait([
////      usersGoutsMusicauxTable.removeAllFromLogin(login: login),
////      usersAssociationsTable.removeAllFromLogin(login: login),
////      database.query(query, substitutionValues: {
////        'login': login,
////      }),
////    ]);
////  }
////
////  Future<void> removeMultiple({@required List<Association> associations}) async {
////    if (associations.length == 0) return;
////    final String query = "DELETE FROM $name WHERE name IN (" +
////        [for (int index = 0; index < associations.length; index++) '@$index'].join(',') +
////        ");";
////
////    return database.query(query,
////        substitutionValues: associations.asMap().map((int key, Association associations) =>
////            MapEntry(key.toString(), associations.name)));
////  }
////
////  Future<void> removeAll() {
////    final String query = "DELETE FROM $name;";
////
////    return database.query(query);
////  }
////}
