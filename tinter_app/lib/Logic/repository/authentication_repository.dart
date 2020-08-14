import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

class AuthenticationRepository {
  final TinterApiClient tinterApiClient;
  AuthenticationBloc authenticationBloc;
  final storage = new FlutterSecureStorage();

  AuthenticationRepository({@required this.tinterApiClient}) : assert(tinterApiClient != null);

  void init({@required authenticationBloc}) {
    this.authenticationBloc = authenticationBloc;
  }

  Future<Token> logIn(String login, String password) async {
    Token token;
    try {
      token = (await tinterApiClient.logIn(login: login, password: password)).token;
    } catch (error) {
      print(error);
      throw AuthenticationWrongCredentialError();
    }

    // If their is no new token, the authentication failed
    if (token == null) {
      throw AuthenticationWrongCredentialError();
    }

    return token;
  }

  Future<Token> authenticateWithToken(Token token) async {
    Token newToken;
    try {
      newToken = (await tinterApiClient.authenticateWithToken(token: token)).token;
    } catch (error) {
      print(error);
      throw AuthenticationBadTokenError();
    }

    // If their is no new token, the authentication failed
    if (newToken == null) {
      throw AuthenticationBadTokenError();
    }

    return newToken;
  }

  Future<Token> getAuthenticationToken() async {
    return Token.fromJson(jsonDecode(await storage.read(key: 'authenticationToken')));
  }

  Future<void> checkIfNewToken({@required Token oldToken, @required Token newToken}) async {
    if (newToken.token == null) {
      print('New token is null');
      return;
    }
    if (oldToken.token != newToken.token) {
      print('Storing new token: ${newToken.token}');
      await storage.write(key: 'authenticationToken', value: jsonEncode(newToken));
    }
  }
}
