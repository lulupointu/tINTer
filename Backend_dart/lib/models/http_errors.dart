
import 'dart:io';

import 'package:meta/meta.dart';

abstract class HttpError implements Exception {
  final String error;
  final bool shouldSend;
  final int errorCode;

  HttpError(this.error, this.shouldSend, {this.errorCode = HttpStatus.badRequest});

  @override
  String toString() => '(${this.runtimeType}) $error';
}

class UnknownRequestError extends HttpError {
  final String error;
  final bool shouldSend;

  UnknownRequestError(this.error, this.shouldSend) : super(error, shouldSend);
}

class UnknownRequestedPathError extends HttpError {
  UnknownRequestedPathError(String path) : super('The path $path is not valid.', true);
}

class MissingQueryParameterError extends HttpError {
  MissingQueryParameterError(String error, bool shouldSend) : super(error, shouldSend);
}

class WrongQueryParameterTypeError extends HttpError {
  WrongQueryParameterTypeError(String error, bool shouldSend) : super(error, shouldSend);
}

class InvalidQueryParameterError extends HttpError {
  InvalidQueryParameterError(String error, bool shouldSend) : super(error, shouldSend);
}

class InvalidCredentialsFormatException extends HttpError {
  InvalidCredentialsFormatException(String error, bool shouldSend) : super(error, shouldSend);
}

class UserNotFound extends HttpError {
  UserNotFound(String error, bool shouldSend) : super(error, shouldSend);
}

class WrongFormatError extends HttpError {
  WrongFormatError({@required String error, @required bool shouldSend})
      : super(error, shouldSend);
}

class UnknownTokenError extends HttpError {
  UnknownTokenError({@required String error, @required bool shouldSend})
      : super(error, shouldSend);
}

class InvalidTokenError extends HttpError {
  InvalidTokenError({@required String error, @required bool shouldSend})
      : super(error, shouldSend);
}

class ExpiredTokenError extends HttpError {
  ExpiredTokenError({@required String error, @required bool shouldSend})
      : super(error, shouldSend);
}

class InvalidCredentialsException extends HttpError {
  InvalidCredentialsException(String error, bool shouldSend)
      : super(error, shouldSend);
}

class ConnectionToLDAPRefused extends HttpError {
  ConnectionToLDAPRefused(String error, bool shouldSend)
  : super(error, shouldSend);
}