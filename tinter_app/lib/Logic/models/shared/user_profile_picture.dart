import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

Widget getProfilePictureFromLocalPathOrLogin({
  @required String login,
  @required String localPath,
  @required double height,
  @required double width,
}) {
  if (localPath != null) {
    return ClipOval(
      child: Image.file(
        File(localPath),
        height: height,
        width: width,
      ),
    );
  }

  return getProfilePictureFromLogin(
    login: login,
    height: height,
    width: width,
  );
}

Widget getProfilePictureFromLogin({
  @required String login,
  @required double height,
  @required double width,
}) {
  return ClipOval(
    child: FutureBuilder(
      future: AuthenticationRepository.getAuthenticationToken(),
      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
        return (!snapshot.hasData)
            ? Center(child: CircularProgressIndicator())
            : Image.network(
                Uri.http(TinterAPIClient.baseUrl, '/shared/user/profilePicture', {'login': login})
                    .toString(),
                headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
                height: height,
                width: width,
          fit: BoxFit.fitWidth,
              );
      },
    ),
  );
}
