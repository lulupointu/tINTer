part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState  extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitialState extends AuthenticationState {}

class AuthenticationNotAuthenticatedState extends AuthenticationState {}

class AuthenticationLoadingState extends AuthenticationState {}

class AuthenticationSuccessfulState extends AuthenticationState {
  final Token token;

  AuthenticationSuccessfulState({@required this.token});

  @override
  List<Object> get props => [token];
}

class AuthenticationFailureState extends AuthenticationState {
  final AuthenticationError error;

  const AuthenticationFailureState({@required this.error});

  @override
  List<Object> get props => [error];
}