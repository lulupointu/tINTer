import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:xml/xml.dart' as xml;

Logger _logger = Logger('loginWithCAS');

Future<void> loginWithCAS(HttpRequest req, String ticket) async {
  // Get information from the CAS
  final response = await http.get(
    Uri.parse(
      'https://cas.imtbs-tsp.eu/cas/serviceValidate?service=http%3A%2F%2Fdfvps.telecom-sudparis.eu%3A443%2Fcas&ticket=${ticket}',
    ),
  );

  // This response contains information about the user
  final xmlResponse = xml.XmlDocument.parse(response.body);
  final username = xmlResponse.findAllElements('cas:uid').first.text;
  final email = xmlResponse.findAllElements('cas:mail').first.text;
  final firstName = xmlResponse.findAllElements('cas:givenName').first.text;
  final lastName = xmlResponse.findAllElements('cas:sn').first.text;

  _logger.info('Authenticated user $username with CAS');
  req.response
    ..write("<cookie hidden=\" \">COUCOU</cookie>")
    ..close();
}

class SecureCookie implements Cookie {
  @override
  String domain;

  @override
  DateTime expires;

  @override
  bool httpOnly;

  @override
  int maxAge;

  @override
  String name;

  @override
  String path;

  @override
  bool secure = true;

  @override
  String value;

  SecureCookie(
    this.name,
    this.value,
  );
}
