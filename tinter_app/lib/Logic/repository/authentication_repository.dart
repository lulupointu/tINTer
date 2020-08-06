import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class AuthenticationRepository {
  final TinterApiClient tinterApiClient;

  AuthenticationRepository({@required this.tinterApiClient}) :
        assert(tinterApiClient != null);

  Token logIn(String login, String password) {
    final Token token = tinterApiClient.logIn(login: login, password: password);

    // If their is no token, the authentication failed
    if (token == null) {
      print('Throw Error');
      throw AuthenticationWrongCredentialError();
    }

    return token;
  }

  Token logInWithToken(Token token) {
    final Token newToken = tinterApiClient.logInWithToken(token: token);

    // If their is no new token, the authentication failed
    if (newToken == null) {
      throw AuthenticationBadTokenError();
    }

    return newToken;
  }

}

