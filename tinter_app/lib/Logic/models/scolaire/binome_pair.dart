import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

abstract class BinomePair extends Object {
  int get binomePairId;

  // We store basic info from both user of the binome
  // The 'other' is attributed so that login < otherLogin.
  String get login;

  String get name;

  String get surname;

  String get email;

  String get otherLogin;

  String get otherName;

  String get otherSurname;

  String get otherEmail;

  // All other attribute are an union or intersection of the
  // two users composing the binome
  BuiltList<Association> get associations;

  @nullable
  LieuDeVie get lieuDeVie;

  double get groupeOuSeul;

  BuiltList<HoraireDeTravail> get horairesDeTravail;

  double get enligneOuNon;

  BuiltList<String> get matieresPreferees;

  static Widget getProfilePictureFromBinomePairLogins({
    @required String loginA,
    @required String loginB,
    double height,
    @required double width,
  }) {
    return FutureBuilder(
      future: AuthenticationRepository.getAuthenticationToken(),
      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
        return SizedBox(
          height: height,
          width: width,
          child: (!snapshot.hasData)
              ? Center(child: Container())
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ClipOval(
                        child: Image.network(
                          Uri.http(TinterAPIClient.baseUrl, '/shared/user/profilePicture',
                              {'login': loginB}).toString(),
                          headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipOval(
                        child: Image.network(
                          Uri.http(TinterAPIClient.baseUrl, '/shared/user/profilePicture',
                              {'login': loginA}).toString(),
                          headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
