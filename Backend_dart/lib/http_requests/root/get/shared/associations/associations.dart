import 'package:logging/logging.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/http_requests/root/get/shared/associations/all_associations/all_associations.dart';
import 'package:tinter_backend/http_requests/root/get/shared/associations/association_logo/association_logo.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';

import 'dart:io';


final _logger = Logger('associationsGetToNextSegment');

Future<void> associationsGetToNextSegment(HttpRequest req, List<String> segments, String login) async {
  _logger.info(printReceivedSegments(login, 'AssociationsGetToNextSegment', segments));

  switch (segments.removeAt(0)) {
    case 'allAssociations':
      return allAssociationsGet(req, segments, login);
    case 'associationLogo':
      return associationLogoGet(req, segments, login);
    default:
      throw UnknownRequestedPathError(req.uri.path);
  }
}
