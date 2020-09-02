import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/associatif/associatif.dart';
import 'package:tinter_backend/http_requests/root/get/is_known.dart';
import 'package:tinter_backend/http_requests/root/get/scolaire/scolaire.dart';
import 'package:tinter_backend/http_requests/root/get/shared/shared.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';

final _logger = Logger('getToNextSegment');
Future<void> getToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments('getToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'associatif':
      return associatifGetToNextSegment(req, segments, login);
    case 'scolaire':
      return scolaireGetToNextSegment(req, segments, login);
    case 'shared':
      return sharedGetToNextSegment(req, segments, login);
    case 'isKnown':
      return isUserKnownGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}