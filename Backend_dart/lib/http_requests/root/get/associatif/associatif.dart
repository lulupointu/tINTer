import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/associatif/discover_matches/discover_matches.dart';
import 'package:tinter_backend/http_requests/root/get/associatif/matched_matches/matched_matches.dart';
import 'package:tinter_backend/http_requests/root/get/associatif/search_users/searchUsers.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

final _logger = Logger('associatifGetToNextSegment');

Future<void> associatifGetToNextSegment(
    HttpRequest req, List<String> segments, String login) async {
  _logger.info(
      printReceivedSegments(login, 'associatifGetToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'searchUsers':
      return searchUsersAssociatifsGet(req, segments, login);
    case 'discoverMatches':
      return discoverMatchesGet(req, segments, login);
    case 'matchedMatches':
      return matchedMatchesGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}
