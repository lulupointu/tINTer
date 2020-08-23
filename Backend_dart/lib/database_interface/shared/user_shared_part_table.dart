import 'dart:convert';

import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/associatif/gouts_musicaux.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/shared/user_shared_part.dart';

class UsersSharedPartTable {
  final UsersTable usersTable;
  final UsersAssociationsTable usersAssociationsTable;
  final PostgreSQLConnection database;

  UsersSharedPartTable({@required this.database})
      : usersTable = UsersTable(database: database),
        usersAssociationsTable = UsersAssociationsTable(database: database);

  Future<void> populate() async {
    final List<Future> queries = [
      for (BuildUserSharedPart userSharedPart in fakeUsersSharedPart) ...[
        usersTable.add(userJson: userSharedPart.toJson()),
        usersAssociationsTable.addMultipleFromLogin(
            login: userSharedPart.login, associations: userSharedPart.associations.toList())
      ]
    ];

    return Future.wait(queries);
  }

  Future<void> update(BuildUserAssociatif userAssociatif) {
    final Map<String, dynamic> userAssociatifJson = userAssociatif.toJson();

    final List<Future> queries = [
      usersTable.update(userJson: userAssociatifJson),
    ];

    return Future.wait(queries);
  }

  Future<void> removeFromLogin(String login) {
    return usersTable.remove(login: login);
  }

  Future<BuildUserSharedPart> getFromLogin({@required String login}) async {
    final List<Future> queries = [
      usersTable.getFromLogin(login: login),
      usersAssociationsTable.getFromLogin(login: login),
    ];

    List queriesResults = await Future.wait(queries);

    return BuildUserSharedPart.fromJson({
      ...queriesResults[0],
      'associations': queriesResults[1].map(
        (Association association) => association.toJson(),
      ),
    });
  }
}

List<BuildUserSharedPart> fakeUsersSharedPart = [
  BuildUserSharedPart.fromJson({
    'login': 'fake_delsol_l',
    'name': 'Lucas',
    'surname': 'Delsol',
    'email': 'lucas.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[0].toJson(), allAssociations[5].toJson()],
  }),
  BuildUserSharedPart.fromJson({
    'login': 'fake_coste_va',
    'name': 'Valentine',
    'surname': 'Coste',
    'email': 'valentine.coste@telecom-sudparis.eu',
    'school': School.IMTBS.serialize(),
    'associations': [allAssociations[2].toJson(), allAssociations[5].toJson()],
  }),
  BuildUserSharedPart.fromJson({
    'login': 'fake_delsol_b',
    'name': 'Benoit',
    'surname': 'Delsol',
    'email': 'benoit.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[1].toJson(), allAssociations[4].toJson()],
  }),
  BuildUserSharedPart.fromJson({
    'login': 'fake_delsol_h',
    'name': 'hugo',
    'surname': 'delsol',
    'email': 'hugo.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[4].toJson(), allAssociations[8].toJson()],
  }),
  BuildUserSharedPart.fromJson({
    'login': 'fake_vannier',
    'name': 'emilien',
    'surname': 'vannier',
    'email': 'emilien.vannier@telecom_sudparis.eu',
    'school': School.IMTBS.serialize(),
    'associations': [allAssociations[1].toJson(), allAssociations[9].toJson()],
  }),
];
