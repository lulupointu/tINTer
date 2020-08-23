import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class DiscoverMatchesRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  DiscoverMatchesRepository({@required this.tinterAPIClient, @required this.authenticationRepository}) :
        assert(tinterAPIClient != null);

  Future<List<Match>> getMatches({@required int limit, @required int offset}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    TinterApiResponse<List<Match>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getDiscoverMatches(token: token, limit: limit, offset: offset);
    } on TinterAPIError catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<void> updateMatchStatus({@required RelationStatusAssociatif relationStatus}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.updateMatchRelationStatus(relationStatus: relationStatus, token: token)).token;
    } catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: newToken);
  }

}