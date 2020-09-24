import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class UnknownUserError implements Exception {}

class UserRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  UserRepository({@required this.tinterAPIClient, @required this.authenticationRepository})
      : assert(tinterAPIClient != null);

  Future<bool> isKnown() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      print('isKnown Cannot get User:');
      print(error);
      throw error;
    }
    print('getUser using token ${token.token}');

    TinterApiResponse<bool> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.isKnownUser(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<BuildUser> getUser() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      print('getUser Cannot get User:');
      print(error);
      throw error;
    }
    print('getUser using token ${token.token}');

    TinterApiResponse<BuildUser> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getUser(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<bool> updateUser({@required BuildUser user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.updateUser(user: user, token: token)).token;

      // If not null this means that the profile picture has been updated
      if (user.profilePictureLocalPath != null){
        await tinterAPIClient.updateUserProfilePicture(
            profilePictureLocalPath: user.profilePictureLocalPath, token: token);
      }
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      print(error);
      return false;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);

    return true;
  }

  Future<void> createUser({@required BuildUser user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.createUser(user: user, token: token)).token;

      // If not null this means that the profile picture has been updated
      if (user.profilePictureLocalPath != null) {
        await tinterAPIClient.updateUserProfilePicture(
            profilePictureLocalPath: user.profilePictureLocalPath, token: token);
      }
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);
  }

  Future<List<SearchedUserScolaire>> getAllSearchedUsersScolaire() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }
    print('getMultipleBasicUsersInfo using token ${token.token}');

    TinterApiResponse<List<SearchedUserScolaire>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllSearchedUsersScolaires(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
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

    TinterApiResponse<List<SearchedUserAssociatif>> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getAllSearchedUsersAssociatifs(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
    return tinterApiResponse.value;
  }

//  Future<User> getBasicUserInfo() async {
//    Token token;
//    try {
//      token = await AuthenticationRepository.getAuthenticationToken();
//    } catch (error) {
//      throw error;
//    }
//    print('getBasicUserInfo using token ${token.token}');
//
//    TinterApiResponse<User> tinterApiResponse;
//    try {
//      tinterApiResponse = await tinterAPIClient.getStaticStudent(token: token);
//    } on TinterAPIError catch (error) {
//      await authenticationRepository.checkIfNewToken(
//          oldToken: token, newToken: error.token);
//      throw UnknownUserError();
//    }
//
//    await authenticationRepository.checkIfNewToken(
//        oldToken: token, newToken: tinterApiResponse.token);
//    return tinterApiResponse.value;
//  }

//  Future<List<SearchedUser>> getAllSearchedUsersSharedParts() async {
//    Token token;
//    try {
//      token = await AuthenticationRepository.getAuthenticationToken();
//    } catch (error) {
//      throw error;
//    }
//    print('getMultipleBasicUsersInfo using token ${token.token}');
//
//    TinterApiResponse<List<SearchedUser>> tinterApiResponse;
//    try {
//      tinterApiResponse = await tinterAPIClient.getAllSearchedUsersSharedPartsSharedPart(token: token);
//    } on TinterAPIError catch (error) {
//      await authenticationRepository.checkIfNewToken(
//          oldToken: token, newToken: error.token);
//      throw UnknownUserError();
//    }
//
//    await authenticationRepository.checkIfNewToken(
//        oldToken: token, newToken: tinterApiResponse.token);
//    return tinterApiResponse.value;
//  }

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
    } on TinterAPIError catch (_) {
      throw UnknownUserError();
    }

    return tinterApiResponse.value;
  }
}
