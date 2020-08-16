import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/user/user_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/static_student.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class UnknownUserError implements Exception {}

class UserRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  UserRepository({@required this.tinterAPIClient, @required this.authenticationRepository})
      : assert(tinterAPIClient != null);

  Future<User>  getUser() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getUser using token ${token.token}');

    TinterApiResponse<User> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getUser(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<bool> updateUser({@required User user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.updateUser(user: user, token: token)).token;
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      print(error);
      return false;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);

    return true;
  }

  Future<void> createUser({@required User user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.createUser(user: user, token: token)).token;
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);

  }

  Future<StaticStudent> getBasicUserInfo() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getBasicUserInfo using token ${token.token}');

    TinterApiResponse<StaticStudent> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getStaticStudent(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
    return tinterApiResponse.value;
  }
}
