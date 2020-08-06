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

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final storage = new FlutterSecureStorage();

  AuthenticationBloc({@required this.authenticationRepository})
      : super(AuthenticationInitialState());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    switch (event.runtimeType) {
      case AuthenticationNeverLoggedInEvent:
        yield AuthenticationNotAuthenticatedState();
        return;
      case AuthenticationLoggedRequestSentEvent:
        yield* _mapAuthenticationLoggedRequestSentEventToState(event);
        return;
      case AuthenticationLogWithTokenRequestSentEvent:
        yield* _mapAuthenticationLoggedRequestWithTokenSentEventToState(event);
        return;
      case AuthenticationLoggedSuccessfulEvent:
        yield AuthenticationSuccessfulState(
            token: (event as AuthenticationLoggedSuccessfulEvent).token);
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
    await Future.delayed(const Duration(seconds: 2), () {}); // TODO: remove this
    print('FakeWait');


    // Try to authenticate
    Token token;
    try {
      token = authenticationRepository.logIn(event.login, event.password);
    } on AuthenticationError catch (error) {
      print('CatchError');
      add(AuthenticationLoggedFailedEvent(error: error));
      return;
    }

    yield AuthenticationSuccessfulState(token: token);
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedRequestWithTokenSentEventToState(
      AuthenticationLoggedRequestSentEvent event) async* {
    yield AuthenticationLoadingState();
    await Future.delayed(const Duration(seconds: 2), () {}); // TODO: remove this

    Token token;
    if (state is AuthenticationSuccessfulState) {
      token = (state as AuthenticationSuccessfulState).token;
    } else {
      token = Token.fromJson(jsonDecode(await storage.read(key: 'authenticationToken')));
    }

    // If the token is null, it's because we never authenticated in this app.
    if (token == null) {
      yield AuthenticationNotAuthenticatedState();
      return;
    }

    // Try to authenticate
    Token newToken;
    try {
      newToken = authenticationRepository.logInWithToken(token);
    } on AuthenticationError catch (error) {
      add(AuthenticationLoggedFailedEvent(error: error));
      return;
    }

    yield AuthenticationSuccessfulState(token: newToken);
  }

  String get token {
    if (state is AuthenticationSuccessfulState) {
      return (state as AuthenticationSuccessfulState).token.token;
    }
    return null;
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutEventToState(
      AuthenticationEvent event) async* {
    yield AuthenticationNotAuthenticatedState();
    storage.delete(key: 'authenticationToken');
  }
}
