import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> userUpdate(HttpRequest req, List<String> segments) async {
  printReceivedSegments('UserUpdateToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'associations':
      return;
    case 'attiranceVieAsso':
      return userUpdateAttiranceVieAsso(req);
    case 'feteOuCours':
      return;
    case 'aideOuSortir':
      return;
    case 'organisationEvenements':
      return;
    case 'goutsMusicaux':
      return;
    default:
      throw UnknownRequestError();
  }
}

// TODO: update this with association model
Future<void> userUpdateAssociations(HttpRequest req) async {
}

Future<void> userUpdateAttiranceVieAsso(HttpRequest req) async {
  final String body = await utf8.decodeStream(req);

  double newValue;
  try {
    newValue = jsonDecode(body)['attiranceVieAsso'];
  } on TypeError catch (error) {
    throw WrongQueryParameterTypeError(error: error);
  }

  if (newValue == null) {
    throw MissingQueryParameterError(expectedParameter: 'attiranceVieAsso');
  }

  if (newValue < 0 || newValue > 1) {
    throw InvalidQueryParameterError(error: 'Posted value is $newValue while it should be between 0 and 1.');
  }

  print('new value: $newValue');
}