import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

abstract class AuthenticationError implements Exception {
  String getMessage();
}

class AuthenticationBadConnexionError extends AuthenticationError {
  @override
  String getMessage() => 'Impossible de se connecter au serveur. Es-tu bien connecté?';
}

class AuthenticationWrongCredentialError extends AuthenticationError {
  @override
  String getMessage() => 'Login ou mot de passe incorrect.';
}

class AuthenticationBadTokenError extends AuthenticationError {
  @override
  String getMessage() => 'Token rejeté, tentez de vous reconnecter';
}

class AuthenticationEmptyCredentialError extends AuthenticationError {
  @override
  String getMessage() => 'Le login et le mot de passe ne doivent pas être vides';
}

class NotAuthenticatedError extends AuthenticationError {
  @override
  String getMessage() => 'Tried to use server while not in authenticated state.';

}

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final storage = new FlutterSecureStorage();

  AuthenticationBloc({@required this.authenticationRepository})
      : super(AuthenticationInitialState()) {
    authenticationRepository.init(authenticationBloc: this);
  }

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    switch (event.runtimeType) {
      case AuthenticationLoggedRequestSentEvent:
        yield* _mapAuthenticationLoggedRequestSentEventToState(event);
        return;
      case AuthenticationLogWithTokenRequestSentEvent:
        yield* _mapAuthenticationLoggedRequestWithTokenSentEventToState(event);
        return;
      case AuthenticationSuccessfulEvent:
        yield* _mapAuthenticationSuccessfulEventToState(event);
        return;
      case AuthenticationLoggedFailedEvent:
        print('yield error state');
        yield AuthenticationFailureState(
            error: (event as AuthenticationLoggedFailedEvent).error);
        return;
      case AuthenticationLoggedOutEvent:
        yield* _mapAuthenticationLoggedOutEventToState(event);
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedRequestSentEventToState(
      AuthenticationLoggedRequestSentEvent event) async* {
    yield AuthenticationLoadingState();

    // Try to authenticate
    Token token;
    try {
      token = await authenticationRepository.logIn(event.login, event.password);
    } on AuthenticationError catch (error) {
      add(AuthenticationLoggedFailedEvent(error: error));
      return;
    }

    add(AuthenticationSuccessfulEvent(token: token));
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedRequestWithTokenSentEventToState(
      AuthenticationLogWithTokenRequestSentEvent event) async* {
    yield AuthenticationInitializingState();

    String encodedToken = await storage.read(key: 'authenticationToken');
    // If the encodedToken is null, it's because we never authenticated in this app.
    if (encodedToken == null) {
      yield AuthenticationNotAuthenticatedState();
      return;
    }

    Token token = Token.fromJson(jsonDecode(encodedToken));

    // Try to authenticate
    Token newToken;
    try {
      newToken = await authenticationRepository.authenticateWithToken(token);
    } on AuthenticationError catch (error) {
      add(AuthenticationLoggedFailedEvent(error: error));
      return;
    }

    add(AuthenticationSuccessfulEvent(token: newToken));
  }

  String get token {
    if (state is AuthenticationSuccessfulState) {
      return (state as AuthenticationSuccessfulState).token.token;
    }
    return null;
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutEventToState(
      AuthenticationEvent event) async* {

    // Delete the current token
    await storage.delete(key: 'authenticationToken');

    yield AuthenticationNotAuthenticatedState();
  }

  Stream<AuthenticationState> _mapAuthenticationSuccessfulEventToState(
      AuthenticationSuccessfulEvent event) async* {

    // Save the token that was used or gotten when authenticating;
    await storage.write(key: 'authenticationToken', value: jsonEncode(event.token));

    yield AuthenticationSuccessfulState(token: event.token);
  }
}
