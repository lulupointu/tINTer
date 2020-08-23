import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/associatif/user_associatif.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class UnknownUserError implements Exception {}

class UserSharedPartRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  UserSharedPartRepository({@required this.tinterAPIClient, @required this.authenticationRepository})
      : assert(tinterAPIClient != null);

  Future<BuildUserSharedPart> getUser() async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      print('Cannot get User:');
      print(error);
      throw error;
    }
    print('getUser using token ${token.token}');

    TinterApiResponse<BuildUserSharedPart> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.getUserSharedPart(token: token);
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw UnknownUserError();
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);

    return tinterApiResponse.value;
  }

  Future<bool> updateUser({@required BuildUserSharedPart user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.updateUserSharedPart(user: user, token: token)).token;

      // If not null this means that the profile picture has been updated
//      if (user.profilePictureLocalPath != null){
//        await tinterAPIClient.updateUserProfilePicture(
//            profilePictureLocalPath: user.profilePictureLocalPath, token: token);
//      }
    } on TinterAPIError catch (error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      print(error);
      return false;
    }

    await authenticationRepository.checkIfNewToken(oldToken: token, newToken: newToken);

    return true;
  }

  Future<void> createUser({@required BuildUserSharedPart user}) async {
    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    Token newToken;
    try {
      newToken = (await tinterAPIClient.createUserSharedPart(user: user, token: token)).token;
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

//  Future<UserSharedPart> getBasicUserInfo() async {
//    Token token;
//    try {
//      token = await AuthenticationRepository.getAuthenticationToken();
//    } catch (error) {
//      throw error;
//    }
//    print('getBasicUserInfo using token ${token.token}');
//
//    TinterApiResponse<UserSharedPart> tinterApiResponse;
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

//  Future<List<SearchedUserSharedPart>> getAllSearchedUsersSharedParts() async {
//    Token token;
//    try {
//      token = await AuthenticationRepository.getAuthenticationToken();
//    } catch (error) {
//      throw error;
//    }
//    print('getMultipleBasicUsersInfo using token ${token.token}');
//
//    TinterApiResponse<List<SearchedUserSharedPart>> tinterApiResponse;
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
    } on TinterAPIError catch (error) {
      throw UnknownUserError();
    }

    return tinterApiResponse.value;
  }

}
