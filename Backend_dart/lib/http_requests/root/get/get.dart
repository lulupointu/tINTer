import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/discover_matches/discover_matches.dart';
import 'package:tinter_backend/http_requests/root/get/matched_matches/matched_matches.dart';
import 'package:tinter_backend/http_requests/root/get/user/user.dart';
import 'package:tinter_backend/models/http_errors.dart';

import 'dart:io';

import 'package:tinter_backend/test.dart';

Future<void> getToNextSegment(HttpRequest req, List<String> segments, String login) async {
  printReceivedSegments('getToNextSegment', segments);

  switch (segments.removeAt(0)) {
    case 'user':
      return userGet(req, segments, login);
    case 'discoverMatches':
      return discoverMatchesGet(req, segments, login);
    case 'matchedMatches':
      return matchedMatchesGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}