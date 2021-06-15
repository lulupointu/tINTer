import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

Widget getLogoFromAssociation({String associationName}) {
  return FutureBuilder(
    future: AuthenticationRepository.getAuthenticationToken(),
    builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
      return (!snapshot.hasData) ? Center(child: CircularProgressIndicator(),) : Image.network(
        Uri.https(TinterAPIClient.baseUrl, '/shared/associations/associationLogo', {'associationName': associationName}).toString(),
        headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
        fit: BoxFit.contain,
      );
    },
  );
}