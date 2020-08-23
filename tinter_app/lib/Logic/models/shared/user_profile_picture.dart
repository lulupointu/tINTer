import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

Widget getProfilePictureFromUserSharedPart({
  @required UserSharedPart userSharedPart,
  @required double height,
  @required double width,
}) {
  if (userSharedPart.profilePictureLocalPath != null) {
    return ClipOval(
      child: Image.file(
        File(userSharedPart.profilePictureLocalPath),
        height: height,
        width: width,
      ),
    );
  }

  return getProfilePictureFromLogin(
    login: userSharedPart.login,
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
                Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login})
                    .toString(),
                headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
                height: height,
                width: width,
              );
      },
    ),
  );
}
