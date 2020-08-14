import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/relation_status.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class DiscoverRepository {
  final TinterApiClient tinterApiClient;
  final AuthenticationRepository authenticationRepository;

  DiscoverRepository({@required this.tinterApiClient, @required this.authenticationRepository}) :
        assert(tinterApiClient != null);

  Future<List<Match>> getMatches() async {
    Token token;
    try {
      token = await authenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    TinterApiResponse<List<Match>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterApiClient.getDiscoverMatches(token: token, limit: 4, offset: 0);
    } on TinterAPIError catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<void> updateMatchStatus({@required RelationStatus relationStatus}) async {
    Token token;
    try {
      token = await authenticationRepository.getAuthenticationToken();
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterApiClient.updateMatchRelationStatus(relationStatus: relationStatus, token: token)).token;
    } catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: newToken);
  }

}