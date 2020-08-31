import 'package:postgres/postgres.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_associations_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_horaire_de_travail_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_matieres_table.dart';
import 'package:tinter_backend/database_interface/scolaire/binome_pairs_profiles_table.dart';
import 'package:tinter_backend/database_interface/user_management_table.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/binome/binome.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/scolaire/binome_pair_match.dart';

class BinomePairsManagementTable {
  final BinomePairsProfilesTable binomePairsTable;
  final BinomePairsAssociationsTable binomePairsAssociationsTable;
  final BinomePairsMatieresTable binomePairsMatieresTable;
  final BinomePairsHorairesDeTravailTable binomePairsHorairesDeTravailTable;
  final PostgreSQLConnection database;

  BinomePairsManagementTable({@required this.database})
      : binomePairsTable = BinomePairsProfilesTable(database: database),
        binomePairsAssociationsTable = BinomePairsAssociationsTable(database: database),
        binomePairsMatieresTable = BinomePairsMatieresTable(database: database),
        binomePairsHorairesDeTravailTable = BinomePairsHorairesDeTravailTable(database: database);

  Future<void> populate() {
    final List<Future> queries = [
      for (BuildBinomePair binomePair in fakeBinomePairs) ...[add(binomePair: binomePair)]
    ];

    return Future.wait(queries);
  }

  Future<void> create() async {
    await binomePairsTable.create();

    final List<Future> queries = [
      binomePairsAssociationsTable.create(),
      binomePairsMatieresTable.create(),
      binomePairsHorairesDeTravailTable.create(),
    ];

    return Future.wait(queries);
  }

  Future<void> delete() {
    final List<Future> queries = [
      binomePairsTable.delete(),
      binomePairsAssociationsTable.delete(),
      binomePairsMatieresTable.delete(),
      binomePairsHorairesDeTravailTable.delete(),
    ];

    return Future.wait(queries);
  }

  Future<void> add({@required BuildBinomePair binomePair}) async {
    await binomePairsTable.add(binomePairJson: binomePair.toJson());

    // Get the binome pair id
    int binomePairId = await binomePairsTable.getBinomePairIdFromLogin(login: binomePair.login);

    // Add the binome pair id to the binome pair
    binomePair = binomePair.rebuild((b) => b..binomePairId = binomePairId);

    final List<Future> queries = [
      binomePairsTable.update(binomePair: binomePair),
      binomePairsAssociationsTable.addMultipleFromBinomePairId(
          binomePairId: binomePair.binomePairId, associations: binomePair.associations.toList()),
      binomePairsMatieresTable.addMultipleFromBinomePairId(
          binomePairId: binomePair.binomePairId, matieres: binomePair.matieresPreferees.toList()),
      binomePairsHorairesDeTravailTable.addMultipleFromBinomePairId(
          binomePairId: binomePair.binomePairId, horairesDeTravail: binomePair.horairesDeTravail.toList()),
    ];

    return Future.wait(queries);
  }

  Future<void> update({@required BuildBinomePair binomePair}) async {

    final List<Future> queries = [
      binomePairsTable.update(binomePair: binomePair),
      binomePairsAssociationsTable.updateBinomePair(
          binomePairId: binomePair.binomePairId, associations: binomePair.associations.toList()),
      binomePairsMatieresTable.updateBinomePair(
          binomePairId: binomePair.binomePairId, matieres: binomePair.matieresPreferees.toList()),
      binomePairsHorairesDeTravailTable.updateBinomePair(
          binomePairId: binomePair.binomePairId, horairesDeTravail: binomePair.horairesDeTravail.toList()),
    ];

    return Future.wait(queries);
  }

  Future<void> removeFromBinomePairId(int binomePairId) {
    return binomePairsTable.remove(binomePairId: binomePairId);
  }

  Future<BuildBinomePair> getFromBinomePairId({@required int binomePairId}) async {
    final List<Future> queries = [
      binomePairsTable.getFromBinomePairId(binomePairId: binomePairId),
      binomePairsAssociationsTable.getFromBinomePairId(binomePairId: binomePairId),
      binomePairsMatieresTable.getFromBinomePairId(binomePairId: binomePairId),
      binomePairsHorairesDeTravailTable.getFromBinomePairId(binomePairId: binomePairId),
    ];

    List queriesResults = await Future.wait(queries);

    return BuildBinomePair.fromJson({
      ...queriesResults[0],
      'associations': queriesResults[1].map((Association association) => association.toJson()),
      'matieresPreferees': queriesResults[2],
      'horairesDeTravail': queriesResults[3],
    });
  }

  Future<BuildBinomePair> getFromLogin({@required String login}) async {
    final List<Future> queries = [
      binomePairsTable.getFromLogin(login: login),
      binomePairsAssociationsTable.getFromLogin(login: login),
      binomePairsMatieresTable.getFromLogin(login: login),
      binomePairsHorairesDeTravailTable.getFromLogin(login: login),
    ];

    List queriesResults = await Future.wait(queries);

    return BuildBinomePair.fromJson({
      ...queriesResults[0],
      'associations': queriesResults[1].map((Association association) => association.toJson()),
      'matieresPreferees': queriesResults[2],
      'horairesDeTravail': queriesResults[3],
    });
  }

  Future<Map<int, BuildBinomePair>> getAllExceptOneFromBinomePairId(
      {@required int binomePairId}) async {
    final Map<int, Map<String, dynamic>> otherBinomePairsJson = await database.mappedResultsQuery(
        "SELECT * FROM ${BinomePairsProfilesTable.name} "
            "WHERE binomePairId<>@binomePairId "
            ";",
        substitutionValues: {
          'binomePairId': binomePairId,
        }).then((queriesResults) {
      return {
        for (int index = 0; index < queriesResults.length; index++)
          queriesResults[index][BinomePairsProfilesTable.name]['binomePairId']: queriesResults[index]
          [BinomePairsProfilesTable.name]
      };
    });

    final List<Future> queries = [
      binomePairsAssociationsTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
      binomePairsMatieresTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
      binomePairsHorairesDeTravailTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (int binomePairId in otherBinomePairsJson.keys)
        binomePairId: BuildBinomePair.fromJson({
          ...otherBinomePairsJson[binomePairId],
          'associations':
          queriesResults[0][binomePairId].map((Association association) => association.toJson()),
          'matieresPreferees': queriesResults[1][binomePairId],
          'horairesDeTravail': queriesResults[2][binomePairId],
        })
    };
  }

  Future<Map<int, BuildBinomePair>> getAllExceptOneFromLogin(
      {@required String login}) async {
    final Map<int, Map<String, dynamic>> otherBinomePairsJson = await database.mappedResultsQuery(
        "SELECT * FROM ${BinomePairsProfilesTable.name} "
            "WHERE login<>@login AND \"otherLogin\"<>@login "
            ";",
        substitutionValues: {
          'login': login,
        }).then((queriesResults) {
      return {
        for (int index = 0; index < queriesResults.length; index++)
          queriesResults[index][BinomePairsProfilesTable.name]['binomePairId']: queriesResults[index]
          [BinomePairsProfilesTable.name]
      };
    });

    final List<Future> queries = [
      binomePairsAssociationsTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
      binomePairsMatieresTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
      binomePairsHorairesDeTravailTable.getMultipleFromBinomePairsId(binomePairsId: otherBinomePairsJson.keys.toList()),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (int binomePairId in otherBinomePairsJson.keys)
        binomePairId: BuildBinomePair.fromJson({
          ...otherBinomePairsJson[binomePairId],
          'associations':
          queriesResults[0][binomePairId].map((Association association) => association.toJson()),
          'matieresPreferees': queriesResults[1][binomePairId],
          'horairesDeTravail': queriesResults[2][binomePairId],
        })
    };
  }

Future<Map<int, BuildBinomePairMatch>> getMultipleFromBinomePairsId(
      {@required List<int> binomePairsId}) async {
    if (binomePairsId.length == 0) return {};

    final List<Future> queries = [
      binomePairsTable.getMultipleFromBinomePairsId(binomePairsId: binomePairsId),
      binomePairsAssociationsTable.getMultipleFromBinomePairsId(binomePairsId: binomePairsId),
      binomePairsMatieresTable.getMultipleFromBinomePairsId(binomePairsId: binomePairsId),
      binomePairsHorairesDeTravailTable.getMultipleFromBinomePairsId(binomePairsId: binomePairsId),
    ];

    List queriesResults = await Future.wait(queries);

    return {
      for (int binomePairId in queriesResults[2].keys)
        binomePairId: BuildBinomePairMatch.fromJson({
          ...queriesResults[0][binomePairId],
          'associations':
          queriesResults[1][binomePairId].map((Association association) => association.toJson()),
          'matieresPreferees': queriesResults[2][binomePairId],
          'horairesDeTravail': queriesResults[3][binomePairId],
        })
    };
  }
}

List<BuildBinomePair> fakeBinomePairs = [
  BuildBinomePair.getFromUsers(fakeUsers[1], fakeUsers[2]),
  BuildBinomePair.getFromUsers(fakeUsers[3], fakeUsers[4]),
];

//List<BuildBinomePair> fakeBinomePairs = [
//  BuildBinomePair.fromJson({
//    'binomePairId': 'fake_delsol_l',
//    'name': 'Lucas',
//    'surname': 'Delsol',
//    'email': 'lucas.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[0].toJson(), allAssociations[5].toJson()],
//    'year': TSPYear.TSP1A.serialize(),
//    'groupeOuSeul': 0.4,
//    'lieuDeVie': LieuDeVie.other.serialize(),
//    'horairesDeTravail': [
//      HoraireDeTravail.morning.serialize(),
//      HoraireDeTravail.afternoon.serialize()
//    ],
//    'enligneOuNon': 0.6,
//    'matieresPreferees': [allMatieres[0], allMatieres[2]],
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.9,
//    'feteOuCours': 0.5,
//    'aideOuSortir': 0.5,
//    'organisationEvenements': 0.8,
//    'goutsMusicaux': [allGoutsMusicaux[2], allGoutsMusicaux[3]],
//  }),
//  BuildBinomePair.fromJson({
//    'login': 'fake_coste_va',
//    'name': 'Valentine',
//    'surname': 'Coste',
//    'email': 'valentine.coste@telecom-sudparis.eu',
//    'school': School.IMTBS.serialize(),
//    'associations': [allAssociations[2].toJson(), allAssociations[5].toJson()],
//    'year': TSPYear.TSP3A.serialize(),
//    'groupeOuSeul': 0.2,
//    'lieuDeVie': LieuDeVie.maisel.serialize(),
//    'horairesDeTravail': [
//      HoraireDeTravail.morning.serialize(),
//      HoraireDeTravail.evening.serialize()
//    ],
//    'enligneOuNon': 0.1,
//    'matieresPreferees': [allMatieres[2]],
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.6,
//    'feteOuCours': 0.4,
//    'aideOuSortir': 0.7,
//    'organisationEvenements': 0.2,
//    'goutsMusicaux': [allGoutsMusicaux[4]],
//  }),
//  BuildBinomePair.fromJson({
//    'login': 'fake_delsol_b',
//    'name': 'Benoit',
//    'surname': 'Delsol',
//    'email': 'benoit.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[1].toJson(), allAssociations[4].toJson()],
//    'year': TSPYear.TSP3A.serialize(),
//    'groupeOuSeul': 0.9,
//    'lieuDeVie': LieuDeVie.other.serialize(),
//    'horairesDeTravail': [
//      HoraireDeTravail.evening.serialize(),
//      HoraireDeTravail.afternoon.serialize()
//    ],
//    'enligneOuNon': 0.4,
//    'matieresPreferees': [allMatieres[2], allMatieres[1]],
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.5,
//    'feteOuCours': 0.3,
//    'aideOuSortir': 0.12,
//    'organisationEvenements': 0.45,
//    'goutsMusicaux': [allGoutsMusicaux[7], allGoutsMusicaux[12]],
//  }),
//  BuildBinomePair.fromJson({
//    'login': 'fake_delsol_h',
//    'name': 'hugo',
//    'surname': 'delsol',
//    'email': 'hugo.delsol@telecom-sudparis.eu',
//    'school': School.TSP.serialize(),
//    'associations': [allAssociations[4].toJson(), allAssociations[8].toJson()],
//    'year': TSPYear.TSP1A.serialize(),
//    'groupeOuSeul': 0.4,
//    'lieuDeVie': LieuDeVie.maisel.serialize(),
//    'horairesDeTravail': [HoraireDeTravail.night.serialize()],
//    'enligneOuNon': 0.9,
//    'matieresPreferees': [allMatieres[1]],
//    'primoEntrant': true,
//    'attiranceVieAsso': 0.65,
//    'feteOuCours': 0.61,
//    'aideOuSortir': 0.19,
//    'organisationEvenements': 0.7,
//    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[8]],
//  }),
//  BuildBinomePair.fromJson({
//    'login': 'fake_vannier',
//    'name': 'emilien',
//    'surname': 'vannier',
//    'email': 'emilien.vannier@telecom_sudparis.eu',
//    'school': School.IMTBS.serialize(),
//    'associations': [allAssociations[1].toJson(), allAssociations[9].toJson()],
//    'year': TSPYear.TSP2A.serialize(),
//    'groupeOuSeul': 0.8,
//    'lieuDeVie': LieuDeVie.other.serialize(),
//    'horairesDeTravail': [
//      HoraireDeTravail.evening.serialize(),
//      HoraireDeTravail.afternoon.serialize()
//    ],
//    'enligneOuNon': 0.5,
//    'matieresPreferees': [allMatieres[0], allMatieres[2]],
//    'primoEntrant': false,
//    'attiranceVieAsso': 0.4,
//    'feteOuCours': 0.6,
//    'aideOuSortir': 0.4,
//    'organisationEvenements': 0.2,
//    'goutsMusicaux': [allGoutsMusicaux[5], allGoutsMusicaux[7]],
//  }),
//];
