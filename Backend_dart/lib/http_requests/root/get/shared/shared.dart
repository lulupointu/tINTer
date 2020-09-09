import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/shared/associations/associations.dart';
import 'package:tinter_backend/http_requests/root/get/shared/user/user.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';


final _logger = Logger('sharedGetToNextSegment');
Future<void> sharedGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments('SharedGetToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'user':
      return userSharedGetToNextSegment(req, segments, login);
    case 'associations':
      return associationsGetToNextSegment(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}



