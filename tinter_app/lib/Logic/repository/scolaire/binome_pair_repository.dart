import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/scolaire/build_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_binome_pair.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class BinomePairRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  BinomePairRepository({@required this.tinterAPIClient, @required this.authenticationRepository})
      : assert(tinterAPIClient != null);

  Future<bool> hasBinomePair() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      print('Cannot get BinomePair:');
      print(error);
      throw error;
    }
    print('getBinomePair using token ${token.token}');

    TinterApiResponse<bool> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.hasBinomePair(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<BuildBinomePair> getBinomePair() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getBinomePair using token ${token.token}');

    TinterApiResponse<BuildBinomePair> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getBinomePair(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
    return tinterApiResponse.value;
  }

  Future<List<SearchedBinomePair>> getAllSearchedBinomePairsScolaire() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getAllSearchedBinomePairsScolaire using token ${token.token}');

    TinterApiResponse<List<SearchedBinomePair>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllSearchedBinomePaired(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
    return tinterApiResponse.value;
  }

}
