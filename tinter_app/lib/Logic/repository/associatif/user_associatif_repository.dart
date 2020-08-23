import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/shared/static_student.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/associatif/user_associatif.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class UnknownUserError implements Exception {}

class UserAssociatifRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  UserAssociatifRepository({@required this.tinterAPIClient, @required this.authenticationRepository})
      : assert(tinterAPIClient != null);

  Future<UserAssociatif> getUser() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      print('Cannot get User:');
      print(error);
      throw error;
    }
    print('getUser using token ${token.token}');

    TinterApiResponse<UserAssociatif> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getUserAssociatif(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<bool> updateUser({@required UserAssociatif user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.updateUserAssociatif(user: user, token: token)).token;

      // If not null this means that the profile picture has been updated
      if (user.profilePictureLocalPath != null){
        await tinterAPIClient.updateUserProfilePicture(
            profilePictureLocalPath: user.profilePictureLocalPath, token: token);
      }
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      print(error);
      return false;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);

    return true;
  }

  Future<void> createUser({@required UserAssociatif user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.createUserAssociatif(user: user, token: token)).token;
      if (user.profilePictureLocalPath != null){
        await tinterAPIClient.updateUserProfilePicture(
            profilePictureLocalPath: user.profilePictureLocalPath, token: token);
      }
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

  Future<List<SearchedUserAssociatif>> getAllSearchedUsersAssociatifs() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getMultipleBasicUsersInfo using token ${token.token}');

    TinterApiResponse<List<SearchedUserAssociatif>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllSearchedUsersAssociatifsAssociatif(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
    return tinterApiResponse.value;
  }

  Future<void> deleteUserAccount() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getMultipleBasicUsersInfo using token ${token.token}');

    TinterApiResponse<void> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.deleteUserAccount(token: token);
    } on TinterAPIError catch (error) {
      throw UnknownUserError();
    }

    return tinterApiResponse.value;
  }

}
