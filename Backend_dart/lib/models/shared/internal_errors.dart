class InternalError implements Exception {
  final Exception error;

  InternalError(this.error);

  @override
  String toString() => '(${this.runtimeType}) error';
}

class InternalDatabaseError implements InternalError {
  final Exception error;

  InternalDatabaseError(this.error);
}

