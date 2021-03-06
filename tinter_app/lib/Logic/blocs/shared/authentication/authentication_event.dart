part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationLoggedRequestSentEvent extends AuthenticationEvent {
  final String login;
  final String password;

  const AuthenticationLoggedRequestSentEvent({@required this.login, @required this.password});

  @override
  List<Object> get props => [login, password];
}

class AuthenticationLogWithTokenRequestSentEvent extends AuthenticationEvent {}

class AuthenticationSuccessfulEvent extends AuthenticationEvent {
  final Token token;

  const AuthenticationSuccessfulEvent({@required this.token});

  @override
  List<Object> get props => [token];
}

class AuthenticationLoggedFailedEvent extends AuthenticationEvent {
  final AuthenticationError error;

  const AuthenticationLoggedFailedEvent({@required this.error});

  @override
  List<Object> get props => [error];
}

class AuthenticationLoggedOutEvent extends AuthenticationEvent {}