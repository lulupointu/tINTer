import 'dart:async';
import 'dart:io';

import 'package:dartdap/dartdap.dart';
import 'package:tinter_backend/models/shared/http_errors.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/shared/user.dart';

Future<Map<String, String>> getUserInfoFromLDAP({@required login, @required password}) async {
  Map<String, String> userJson;

  // Create an LDAP connection object
  var host = "157.159.10.70";
  var ssl = false; // true = use LDAPS (i.e. LDAP over SSL/TLS)
  var port = 389; // null = use standard LDAP/LDAPS port
  var bindDN = "uid=$login,ou=People,dc=int-evry,dc=fr"; // null=unauthenticated

  var connection = new LdapConnection(host: host);
  connection.setProtocol(ssl, port);
  connection.setAuthentication(bindDN, password);

  try {
    // Perform search operation

    var base = "uid=delsol_l,ou=People,dc=int-evry,dc=fr";
    var filter = Filter.present("objectClass");
    var attrs = ["uid", "givenName", "sn", "mail"];

    var searchResult = await connection.search(base, filter, attrs);
    await for (SearchEntry entry in searchResult.stream) {
      userJson = {
        'login': entry.attributes['uid'].values.first,
        'name': entry.attributes['givenName'].values.first.toString().capitalized,
        'surname': entry.attributes['sn'].values.first.toString().capitalized,
        'email': entry.attributes['mail'].values.first,
        'school': (entry.attributes['mail'].values.first.substring(entry.attributes['mail'].values.first.length - 19) == 'telecom-sudparis.eu'
        ? School.TSP : School.IMTBS).serialize()
      };
    }
  } on LdapResultInvalidCredentialsException {
    await connection.close();
    throw InvalidCredentialsException('Login or password incorrect.', true);
  } on SocketException catch (error) {
    if (error.osError.message == 'Connection refused') {
      throw ConnectionToLDAPRefused(error.osError.message, false);
    }
  } catch (e) {
    print(e);
  } finally {
    // Close the connection when finished with it
    await connection.close();
  }

  return userJson;
}

extension CapExtension on String {
  String get capitalized => '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
}
