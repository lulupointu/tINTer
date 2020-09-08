import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/associatif/users_gouts_musicaux_table.dart';
import 'package:tinter_backend/database_interface/scolaire/users_horaires_de_travail.dart';
import 'package:tinter_backend/database_interface/scolaire/users_matieres_table.dart';
import 'package:tinter_backend/database_interface/shared/users_associations_table.dart';
import 'package:tinter_backend/database_interface/user_table.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/associatif/gouts_musicaux.dart';
import 'package:tinter_backend/models/scolaire/matieres.dart';
import 'package:tinter_backend/models/shared/user.dart';

class UsersManagementTable {
  final UsersTable usersTable;
  final UsersAssociationsTable usersAssociationsTable;
  final UsersGoutsMusicauxTable usersGoutsMusicauxTable;
  final UsersMatieresTable usersMatieresTable;
  final UsersHorairesDeTravailTable usersHorairesDeTravailTable;
  final PostgreSQLConnection database;

  UsersManagementTable({@required this.database})
      : usersTable = UsersTable(database: database),
        usersAssociationsTable = UsersAssociationsTable(database: database),
        usersGoutsMusicauxTable = UsersGoutsMusicauxTable(database: database),
        usersMatieresTable = UsersMatieresTable(database: database),
        usersHorairesDeTravailTable = UsersHorairesDeTravailTable(database: database);

  Future<void> populate() {
    final List<Future> queries = [
      for (BuildUser user in fakeUsers) ...[add(user: user)]
    ];

    return Future.wait(queries);
  }

  Future<void> create() async {
    await usersTable.create();

    final List<Future> queries = [
      usersAssociationsTable.create(),
      usersGoutsMusicauxTable.create(),
      usersMatieresTable.create(),
      usersHorairesDeTravailTable.create(),
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final List<Future> queries = [
      usersTable.delete(),
      usersAssociationsTable.delete(),
      usersGoutsMusicauxTable.delete(),
      usersMatieresTable.delete(),
      usersHorairesDeTravailTable.delete(),
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required BuildUser user}) async {
    await usersTable.addBasicInfo(userJson: user.toJson());

    final List<Future> queries = [
      usersTable.update(user: user),
      usersAssociationsTable.addMultipleFromLogin(
          login: user.login, associations: user.associations.toList()),
      usersGoutsMusicauxTable.addMultipleFromLogin(
          login: user.login, goutsMusicaux: user.goutsMusicaux.toList()),
      usersMatieresTable.addMultipleFromLogin(
          login: user.login, matieres: user.matieresPreferees.toList()),
      usersHorairesDeTravailTable.addMultipleFromLogin(
          login: user.login, horairesDeTravail: user.horairesDeTravail.toList()),
    ];

    return Future.wait(queries);
  }

  Future<void> update({@required BuildUser user}) async {

    final List<Future> queries = [
      usersTable.update(user: user),
      usersAssociationsTable.updateUser(
          login: user.login, associations: user.associations.toList()),
      usersGoutsMusicauxTable.updateUser(
          login: user.login, goutsMusicaux: user.goutsMusicaux.toList()),
      usersMatieresTable.updateUser(
          login: user.login, matieres: user.matieresPreferees.toList()),
      usersHorairesDeTravailTable.updateUser(
          login: user.login, horairesDeTravail: user.horairesDeTravail.toList()),
    ];

    return Future.wait(queries);
  }

  Future<void> removeFromLogin(String login) {
    return usersTable.remove(login: login);
  }

  Future<BuildUser> getFromLogin({@required String login}) async {
    final List<Future> queries = [
      usersTable.getFromLogin(login: login),
      usersAssociationsTable.getFromLogin(login: login),
      usersGoutsMusicauxTable.getFromLogin(login: login),
      usersMatieresTable.getFromLogin(login: login),
      usersHorairesDeTravailTable.getFromLogin(login: login),
    ];

    List queriesResults = await Future.wait(queries);

    return BuildUser.fromJson({
      ...queriesResults[0],
      'associations': queriesResults[1].map((Association association) => association.toJson()),
      'goutsMusicaux': queriesResults[2],
      'matieresPreferees': queriesResults[3],
      'horairesDeTravail': queriesResults[4],
    });
  }

  Future<Map<String, BuildUser>> getAll(
      ) async {
    final Map<String, Map<String, dynamic>> otherUsersJson = await database.mappedResultsQuery(
        "SELECT * FROM ${UsersTable.name};",
        substitutionValues: {
        }).then((queriesResults) {
      return {
        for (int index = 0; index < queriesResults.length; index++)
          queriesResults[index][UsersTable.name]['login']: queriesResults[index]
          [UsersTable.name]
      };
    });

    final List<Future> queries = [
      usersAssociationsTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersGoutsMusicauxTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersMatieresTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersHorairesDeTravailTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (String login in otherUsersJson.keys)
        login: BuildUser.fromJson({
          ...otherUsersJson[login],
          'associations':
          queriesResults[0][login].map((Association association) => association.toJson()),
          'goutsMusicaux': queriesResults[1][login],
          'matieresPreferees': queriesResults[2][login],
          'horairesDeTravail': queriesResults[3][login],
        })
    };
  }


  Future<Map<String, BuildUser>> getAllExceptOneFromLogin(
      {@required String login, bool primoEntrant, TSPYear year, School school}) async {
    final Map<String, Map<String, dynamic>> otherUsersJson = await database.mappedResultsQuery(
        "SELECT * FROM ${UsersTable.name} "
            "WHERE login<>@login " +
            ((primoEntrant != null) ? "AND \"primoEntrant\"<>@primoEntrant " : "") +
            ((year != null) ? "AND \"year\"=@year " : "") +
            ((school != null) ? "AND \"school\"=@school " : "") +
            ";",
        substitutionValues: {
          'login': login,
          'year': (year != null) ? year.serialize() : null,
          'school': (school != null) ? school.serialize() : null,
          'primoEntrant': primoEntrant,
        }).then((queriesResults) {
      return {
        for (int index = 0; index < queriesResults.length; index++)
          queriesResults[index][UsersTable.name]['login']: queriesResults[index]
          [UsersTable.name]
      };
    });

    final List<Future> queries = [
      usersAssociationsTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersGoutsMusicauxTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersMatieresTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
      usersHorairesDeTravailTable.getMultipleFromLogins(logins: otherUsersJson.keys.toList()),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (String login in otherUsersJson.keys)
        login: BuildUser.fromJson({
          ...otherUsersJson[login],
          'associations':
          queriesResults[0][login].map((Association association) => association.toJson()),
          'goutsMusicaux': queriesResults[1][login],
          'matieresPreferees': queriesResults[2][login],
          'horairesDeTravail': queriesResults[3][login],
        })
    };
  }

  Future<Map<String, BuildUser>> getMultipleFromLogins(
      {@required List<String> logins}) async {
    if (logins.length == 0) return {};

    final List<Future> queries = [
      usersTable.getMultipleFromLogin(logins: logins),
      usersAssociationsTable.getMultipleFromLogins(logins: logins),
      usersGoutsMusicauxTable.getMultipleFromLogins(logins: logins),
      usersMatieresTable.getMultipleFromLogins(logins: logins),
      usersHorairesDeTravailTable.getMultipleFromLogins(logins: logins),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (String login in queriesResults[2].keys)
        login: BuildUser.fromJson({
          ...queriesResults[0][login],
          'associations':
          queriesResults[1][login].map((Association association) => association.toJson()),
          'goutsMusicaux': queriesResults[2][login],
          'matieresPreferees': queriesResults[3][login],
          'horairesDeTravail': queriesResults[4][login],
        })
    };
  }
}

List<BuildUser> fakeUsers = [
  BuildUser.fromJson({
    'login': 'fake_delsol_l',
    'name': 'Lucas',
    'surname': 'Delsol',
    'email': 'lucas.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[0].toJson(), allAssociations[5].toJson()],
    'year': TSPYear.TSP1A.serialize(),
    'groupeOuSeul': 0.4,
    'lieuDeVie': LieuDeVie.other.serialize(),
    'horairesDeTravail': [
      HoraireDeTravail.morning.serialize(),
      HoraireDeTravail.afternoon.serialize()
    ],
    'enligneOuNon': 0.6,
    'matieresPreferees': [allMatieres[0], allMatieres[2]],
    'primoEntrant': true,
    'attiranceVieAsso': 0.9,
    'feteOuCours': 0.5,
    'aideOuSortir': 0.5,
    'organisationEvenements': 0.8,
    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
  }),
  BuildUser.fromJson({
    'login': 'fake_coste_va',
    'name': 'Valentine',
    'surname': 'Coste',
    'email': 'valentine.coste@telecom-sudparis.eu',
    'school': School.IMTBS.serialize(),
    'associations': [allAssociations[2].toJson(), allAssociations[5].toJson()],
    'year': TSPYear.TSP3A.serialize(),
    'groupeOuSeul': 0.2,
    'lieuDeVie': LieuDeVie.maisel.serialize(),
    'horairesDeTravail': [
      HoraireDeTravail.morning.serialize(),
      HoraireDeTravail.evening.serialize()
    ],
    'enligneOuNon': 0.1,
    'matieresPreferees': [allMatieres[2]],
    'primoEntrant': true,
    'attiranceVieAsso': 0.6,
    'feteOuCours': 0.4,
    'aideOuSortir': 0.7,
    'organisationEvenements': 0.2,
    'goutsMusicaux': [allGoutsMusicaux[4]],
  }),
  BuildUser.fromJson({
    'login': 'fake_delsol_b',
    'name': 'Benoit',
    'surname': 'Delsol',
    'email': 'benoit.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[1].toJson(), allAssociations[4].toJson()],
    'year': TSPYear.TSP3A.serialize(),
    'groupeOuSeul': 0.9,
    'lieuDeVie': LieuDeVie.other.serialize(),
    'horairesDeTravail': [
      HoraireDeTravail.evening.serialize(),
      HoraireDeTravail.afternoon.serialize()
    ],
    'enligneOuNon': 0.4,
    'matieresPreferees': [allMatieres[2], allMatieres[1]],
    'primoEntrant': true,
    'attiranceVieAsso': 0.5,
    'feteOuCours': 0.3,
    'aideOuSortir': 0.12,
    'organisationEvenements': 0.45,
    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
  }),
  BuildUser.fromJson({
    'login': 'fake_delsol_h',
    'name': 'hugo',
    'surname': 'delsol',
    'email': 'hugo.delsol@telecom-sudparis.eu',
    'school': School.TSP.serialize(),
    'associations': [allAssociations[4].toJson(), allAssociations[8].toJson()],
    'year': TSPYear.TSP1A.serialize(),
    'groupeOuSeul': 0.4,
    'lieuDeVie': LieuDeVie.maisel.serialize(),
    'horairesDeTravail': [HoraireDeTravail.night.serialize()],
    'enligneOuNon': 0.9,
    'matieresPreferees': [allMatieres[1]],
    'primoEntrant': true,
    'attiranceVieAsso': 0.65,
    'feteOuCours': 0.61,
    'aideOuSortir': 0.19,
    'organisationEvenements': 0.7,
    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
  }),
  BuildUser.fromJson({
    'login': 'fake_vannier',
    'name': 'emilien',
    'surname': 'vannier',
    'email': 'emilien.vannier@telecom_sudparis.eu',
    'school': School.IMTBS.serialize(),
    'associations': [allAssociations[1].toJson(), allAssociations[9].toJson()],
    'year': TSPYear.TSP2A.serialize(),
    'groupeOuSeul': 0.8,
    'lieuDeVie': LieuDeVie.other.serialize(),
    'horairesDeTravail': [
      HoraireDeTravail.evening.serialize(),
      HoraireDeTravail.afternoon.serialize()
    ],
    'enligneOuNon': 0.5,
    'matieresPreferees': [allMatieres[0], allMatieres[2]],
    'primoEntrant': false,
    'attiranceVieAsso': 0.4,
    'feteOuCours': 0.6,
    'aideOuSortir': 0.4,
    'organisationEvenements': 0.2,
    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[7]],
  }),
];
