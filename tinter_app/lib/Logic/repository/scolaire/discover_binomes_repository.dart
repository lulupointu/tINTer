import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class DiscoverBinomesRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  DiscoverBinomesRepository({@required this.tinterAPIClient, @required this.authenticationRepository}) :
        assert(tinterAPIClient != null);

  Future<List<BuildBinome>> getBinomes({@required int limit, @required int offset}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    TinterApiResponse<List<BuildBinome>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getDiscoverBinomes(token: token, limit: limit, offset: offset);
    } on TinterAPIError catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<void> updateBinomeStatus({@required RelationStatusScolaire relationStatus}) async {
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
      newToken = (await tinterAPIClient.updateBinomeRelationStatus(relationStatus: relationStatus, token: token)).token;
    } catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: newToken);
  }

}