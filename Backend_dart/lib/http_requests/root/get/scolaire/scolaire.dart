import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/discover_binome_pair_matches/discover_binome_pair_matches.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/discover_binomes/discover_binomes.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/has_binome_pair/has_binome_pair.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matched_binome_pair_matches/matched_binome_paired_matches.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matched_binomes/matched_binomes.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/matieres/matieres.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/search_binome_pair/search_binome_pair.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/search_users/searchUsers.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

Future<void> scolaireGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('scolaireGetToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'searchUsers':
      return searchUsersScolairesGet(req, segments, login);
    case 'discoverBinomes':
      return discoverBinomesGet(req, segments, login);
    case 'matchedBinomes':
      return matchedBinomesGet(req, segments, login);
    case 'hasBinomePair':
      return hasBinomePairGet(req, segments, login);
    case 'searchBinomePair':
      return searchBinomePairGet(req, segments, login);
    case 'discoverBinomesPairMatches':
      return discoverBinomePairsMatchesGet(req, segments, login);
    case 'matchedBinomesPairMatches':
      return matchedBinomePairMatchesGet(req, segments, login);
    case 'matieres':
      return matieresGetToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}