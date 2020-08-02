import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/association.dart';


main() {
  Match match1 = Match.fromJson({
    'name': 'Valentine',
    'surname': 'Coste',
    'score': 99,
    'state': 0,
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
  });


}