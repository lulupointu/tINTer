import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/user.dart';

main() {
  final user = User.fromJson({
    'name': 'Lucas',
    'surname': 'Delsol',
    'email': 'lucasdelsol@telecom-sudparis.eu',
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

  print(user.toJson());

}