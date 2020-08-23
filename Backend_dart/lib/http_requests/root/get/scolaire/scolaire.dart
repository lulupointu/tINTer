import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/discover_binomes/discover_binomes.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matched_binomes/matched_binomes.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matieres/matieres.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/search_users/searchUsers.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/user/user.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> scolaireGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('scolaireGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userGet(req, segments, login);
    case 'searchUsers':
      return searchUsersGet(req, segments, login);
    case 'discoverBinomes':
      return discoverBinomesGet(req, segments, login);
    case 'matchedBinomes':
      return matchedBinomesGet(req, segments, login);
    case 'matieres':
      return matieresGetToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}