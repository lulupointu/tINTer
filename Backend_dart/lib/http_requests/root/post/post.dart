import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/post/associatif/associatif.dart';
import 'package:tinter_backend/http_requests/root/post/scolaire/scolaire.dart';
import 'package:tinter_backend/http_requests/root/post/shared/shared.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

final _logger = Logger('postToNextSegment');

Future<void> postToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'postToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'associatif':
      return associatifPostToNextSegment(req, segments, login);
    case 'scolaire':
      return scolairePostToNextSegment(req, segments, login);
    case 'shared':
      return sharedPostToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}