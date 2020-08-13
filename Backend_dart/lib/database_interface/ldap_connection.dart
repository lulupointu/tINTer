import 'dart:async';

import 'package:dartdap/dartdap.dart';
import 'package:tinter_backend/models/static_student.dart';
import 'package:meta/meta.dart';

Future<StaticStudent> getStaticStudent({@required login, @required password}) async {
  // Create a static student where it will be stored
  StaticStudent staticStudent;

  // Create an LDAP connection object
  var host = "localhost";
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

    var count = 0;

    var searchResult = await connection.search(base, filter, attrs);
    await for (SearchEntry entry in searchResult.stream) {
      print(entry.attributes['uid']);
      print(entry.attributes['uid']);
      print(entry.attributes['uid']);
      print(entry.attributes['uid']);

      staticStudent = StaticStudent(
        login: entry.attributes['uid'],
        name: entry.attributes['givenName'],
        surname: entry.attributes['sn'],
        email: entry.attributes['mail'],
        primoEntrant: null,
      );
    }

    print("# Number of entries: ${count}");
  } on LdapResultInvalidCredentialsException {
    await connection.close();
    throw InvalidCredentialsException;
  } catch (e) {
    print(e.runtimeType);
  } finally {
    // Close the connection when finished with it
    await connection.close();
  }

  return staticStudent;
}

class InvalidCredentialsException implements Exception {}