import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

import 'authentication_repository.dart';

class NotificationRepository {
  final TinterAPIClient tinterAPIClient;
  final AuthenticationRepository authenticationRepository;

  NotificationRepository(
      {@required this.tinterAPIClient, @required this.authenticationRepository}) :
        assert(tinterAPIClient != null);


  Future<void> sendNotificationToken({@required String notificationToken}) async {

    Token token;
    try {
      token = await AuthenticationRepository.getAuthenticationToken();
    } catch (error) {
      throw error;
    }

    TinterApiResponse<void> tinterApiResponse;
    try {
      tinterApiResponse = await tinterAPIClient.sendNotificationToken(token: token, notificationToken: notificationToken);
    } on TinterAPIError catch(error) {
      await authenticationRepository.checkIfNewToken(
          oldToken: token, newToken: error.token);
      throw error;
    }

    await authenticationRepository.checkIfNewToken(
        oldToken: token, newToken: tinterApiResponse.token);
  }
}