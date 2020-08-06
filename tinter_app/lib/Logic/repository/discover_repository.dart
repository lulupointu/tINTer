import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class DiscoverRepository {
  final TinterApiClient tinterApiClient;

  DiscoverRepository({@required this.tinterApiClient}) :
        assert(tinterApiClient != null);

  Future<List<Match>> getMatches() async {
    // TODO: Write this method
    
    return [
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Name2',
        'surname': 'Surname2',
        'score': 65,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'AssociationX',
            description: 'This is the X association',
          ),
          Association(
            name: 'AssociationY',
            description: 'This is the Y association',
          ),
        ],
        'attiranceVieAsso': 0.21,
        'feteOuCours': 0.94,
        'aideOuSortir': 0.43,
        'organisationEvenements': 0.45,
        'goutsMusicaux': ['Pop', 'Rock', 'ok']
      }),
      Match.fromJson({
        'name': 'Name3',
        'surname': 'Surname3',
        'score': 23,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'AssociationZ',
            description: 'This is the Z association',
          ),
          Association(
            name: 'AssociationZZ',
            description: 'This is the ZZ association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock', 'Mock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'primoEntrant': true,
        'status': MatchStatus.none,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
      Match.fromJson({
        'name': 'Valentine',
        'surname': 'Coste',
        'score': 99,
        'status': MatchStatus.none,
        'primoEntrant': true,
        'associations': [
          Association(
            name: 'Association1',
            description: 'This is the first association',
          ),
          Association(
            name: 'Association2',
            description: 'This is the second association',
          ),
          Association(
            name: 'Association3',
            description: 'This is the third association',
          ),
        ],
        'attiranceVieAsso': 0.56,
        'feteOuCours': 0.24,
        'aideOuSortir': 0.41,
        'organisationEvenements': 0.12,
        'goutsMusicaux': ['Pop', 'Rock']
      }),
    ];
  }

  Future<void> updateMatchStatus(Match updatedMatch) {
    // TODO: Write this method
  }

}