import 'dart:html';

import 'package:meta/meta.dart';

abstract class HttpError implements Exception {
  final String error;
  final bool shouldSend;

  HttpError(this.error, this.shouldSend);

  @override
  String toString() => '(${this.runtimeType}) error';
}

class UnknownRequestError implements HttpError {
  final String error;
  final bool shouldSend;

  UnknownRequestError(this.error, this.shouldSend);
}

class UnknownRequestedPathError implements HttpError {
  final String error;
  final bool shouldSend;

  UnknownRequestedPathError(String path) : error = 'The path $path is not valid.', shouldSend=true;
}

class MissingQueryParameterError implements HttpError {
  final String error;
  final bool shouldSend;

  MissingQueryParameterError(this.error, this.shouldSend);
}

class WrongQueryParameterTypeError implements HttpError {
  final String error;
  final bool shouldSend;

  WrongQueryParameterTypeError(this.error, this.shouldSend);
}

class InvalidQueryParameterError implements HttpError {
  final String error;
  final bool shouldSend;

  InvalidQueryParameterError(this.error, this.shouldSend);
}

class InvalidCredentialsFormatException implements HttpError {
  final String error;
  final bool shouldSend;

  InvalidCredentialsFormatException(this.error, this.shouldSend);
}

class UserNotFound implements HttpError {
  final String error;
  final bool shouldSend;

  UserNotFound(this.error, this.shouldSend);
}

class WrongFormatError implements HttpError {
  final String error;
  final bool shouldSend;

  WrongFormatError({@required this.error, @required this.shouldSend});
}
