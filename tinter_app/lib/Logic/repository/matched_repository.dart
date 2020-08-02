import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class MatchedRepository {
  final TinterApiClient tinterApiClient;

  MatchedRepository({@required this.tinterApiClient}) :
        assert(tinterApiClient != null);

  Future<List<Match>> getMatches() async {
    // TODO: Write this method
  }

  Future<void> updateMatchStatus(Match updatedMatch) {
    // TODO: Write this method
  }

}