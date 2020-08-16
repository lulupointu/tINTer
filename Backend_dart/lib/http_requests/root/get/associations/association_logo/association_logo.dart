import 'dart:typed_data';

import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/database_interface.dart';
import 'package:tinter_backend/http_requests/authentication_check.dart';
import 'package:tinter_backend/models/http_errors.dart';

import 'dart:io';

Future<void> associationLogoGet(HttpRequest req, List<String> segments, String login) async {
  String associationLogoBasePath = '/home/lulupointu/Desktop/AssociationsLogoById';

  printReceivedSegments('AssociationLogoGet', segments);

  if (segments.length != 0) {
    return UnknownRequestedPathError(req.uri.path);
  }

  if (!(req.uri.queryParameters.containsKey('associationName'))) {
    return MissingQueryParameterError('logoUrl is missing as a query parameter.', true);
  }

  String associationName = req.uri.queryParameters['associationName'];

  TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  AssociationsTable associationsTable = AssociationsTable(database: tinterDatabase.connection);

  int associationId = await associationsTable.getIdFromName(associationName: associationName);


  var file = File('$associationLogoBasePath/$associationId.jpg');
  Future<Uint8List> picture = file.readAsBytes();
  req.response.statusCode = HttpStatus.ok;
  req.response.headers.contentType = ContentType.parse("image/png");
  await req.response.addStream(picture.asStream());
  await req.response.close();


  await tinterDatabase.close();
}