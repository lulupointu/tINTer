import 'dart:convert';
import 'dart:io';

import 'package:tinter_backend/database_interface/database_interface.dart';

main() async {
  var file = File('/home/df/tINTerPictures/SmallerLogoImages\ jpg/AbsINThe.jpg');
  String picture = base64UrlEncode(await file.readAsBytes());


  final TinterDatabase tinterDatabase = TinterDatabase();
  await tinterDatabase.open();

  await tinterDatabase.connection.query("INSERT INTO associations_pictures VAlUES (1, @picture);", substitutionValues: {'picture': picture});

  // await tinterDatabase.close();
}