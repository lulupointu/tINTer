import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/user/user_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class UserRepository {
  final TinterApiClient tinterApiClient;

  UserRepository({@required this.tinterApiClient}) :
        assert(tinterApiClient != null);

  Future<User> getUser() async {
    // TODO: Write this method

    return User.fromJson({
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
  }

  Future<void> updateUser(User user) async {
    // TODO: Write this method
  }


}