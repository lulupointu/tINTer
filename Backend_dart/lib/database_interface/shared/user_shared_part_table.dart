//import 'package:postgres/postgres.dart';
//import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
//import 'package:tinter_backend/database_interface/scolaire/users_horaires_de_travail.dart';
//import 'package:tinter_backend/database_interface/scolaire/users_matieres_table.dart';
//import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
//import 'package:tinter_backend/database_interface/user_table.dart';
//import 'package:tinter_backend/models/associatif/association.dart';
//import 'package:meta/meta.dart';
//import 'package:tinter_backend/models/shared/user.dart';
//
//class UsersSharedPartTable {
//  final UsersTable usersTable;
//  final UsersAssociationsTable usersAssociationsTable;
//  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;
//  final UsersMatieresTable usersMatieresTable;
//  final UsersHorairesDeTravailTable usersHorairesDeTravailTable;
//  final PostgreSQLConnection database;
//
//  UsersSharedPartTable({@required this.database})
//      : usersTable = UsersTable(database: database),
//        usersAssociationsTable = UsersAssociationsTable(database: database),
//        usersGoutsMusicauxTable = UsersGoutsMusicauxTable(database: database),
//        usersMatieresTable = UsersMatieresTable(database: database),
//        usersHorairesDeTravailTable = UsersHorairesDeTravailTable(database: database);
//
//  Future<void> populate() async {
//    final List<Future> queries = [
//      for (BuildUser userSharedPart in fakeUsers) ...[
//        usersTable.add(userJson: userSharedPart.toJson()),
//        usersAssociationsTable.addMultipleFromLogin(
//            login: userSharedPart.login, associations: userSharedPart.associations.toList())
//      ]
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<void> add({@required BuildUser userSharedPart}) {
//    return usersTable.add(userJson: userSharedPart.toJson());
//  }
//
//  Future<void> update({@required BuildUser userSharedPart}) {
//    final Map<String, dynamic> userSharedPartJson = userSharedPart.toJson();
//
//    final List<Future> queries = [
//      usersTable.update(userJson: userSharedPartJson),
//    ];
//
//    return Future.wait(queries);
//  }
//
//  Future<void> removeFromLogin(String login) {
//    return usersTable.remove(login: login);
//  }
//
//  Future<BuildUser> getFromLogin({@required String login}) async {
//    final List<Future> queries = [
//      usersTable.getFromLogin(login: login),
//      usersAssociationsTable.getFromLogin(login: login),
//    ];
//
//    List queriesResults = await Future.wait(queries);
//
//    return BuildUser.fromJson({
//      ...queriesResults[0],
//      'associations': queriesResults[1].map(
//        (Association association) => association.toJson(),
//      ),
//    });
//  }
//}
//
//List<BuildUser> fakeUsers = [
//  BuildUser.fromJson({
//    'login': 'fake_delsol_l',
//    'name': 'Lucas',
//    'surname': 'Delsol',
//    'email': 'lucas.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[0].toJson(), allAssociations[5].toJson()],
//  }),
//  BuildUser.fromJson({
//    'login': 'fake_coste_va',
//    'name': 'Valentine',
//    'surname': 'Coste',
//    'email': 'valentine.coste@telecom-sudparis.eu',
//    'school': School.IMTBS.serialize(),
//    'associations': [allAssociations[2].toJson(), allAssociations[5].toJson()],
//  }),
//  BuildUser.fromJson({
//    'login': 'fake_delsol_b',
//    'name': 'Benoit',
//    'surname': 'Delsol',
//    'email': 'benoit.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[1].toJson(), allAssociations[4].toJson()],
//  }),
//  BuildUser.fromJson({
//    'login': 'fake_delsol_h',
//    'name': 'hugo',
//    'surname': 'delsol',
//    'email': 'hugo.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[4].toJson(), allAssociations[8].toJson()],
//  }),
//  BuildUser.fromJson({
//    'login': 'fake_vannier',
//    'name': 'emilien',
//    'surname': 'vannier',
//    'email': 'emilien.vannier@telecom_sudparis.eu',
//    'school': School.IMTBS.serialize(),
//    'associations': [allAssociations[1].toJson(), allAssociations[9].toJson()],
//  }),
//];
