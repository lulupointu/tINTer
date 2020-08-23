import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/shared/static_student.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

part 'user_scolaire.g.dart';

enum UserScolaireAttribute {
  name,
  surname,
  email,
  primoEntrant,
  associations,
  groupeOuSeul,
  lieuDeVie,
  horairesDeTravail,
  enligneOuNon,
  matieresPreferees,
  profilePicturePath
}

enum LieuDeVie { maisel, other }

enum HoraireDeTravail { morning, afternoon, evening, night }

enum OutilDeTravail {
  online,
  faceToFace,
}

@JsonSerializable(explicitToJson: true)
class UserScolaire extends StaticStudent {
  final List<Association> _associations;
  final double _groupeOuSeul;
  final LieuDeVie _lieuDeVie;
  final List<HoraireDeTravail> _horairesDeTravail;
  final OutilDeTravail _enligneOuNon;
  final List<String> _matieresPreferees;
  final String _profilePicturePath;

  UserScolaire({
    @required String login,
    @required String name,
    @required String surname,
    @required String email,
    @required TSPYear year,
    @required List<dynamic> associations,
    @required double groupeOuSeul,
    @required LieuDeVie lieuDeVie,
    @required List<HoraireDeTravail> horairesDeTravail,
    @required OutilDeTravail enligneOuNon,
    @required List<String> matieresPreferees,
    String profilePicturePath,
  })  : assert(groupeOuSeul != 0),
        assert(lieuDeVie != null),
        assert(enligneOuNon != null),
        _associations = associations
                ?.map((var association) => (association is Association)
                    ? association
                    : Association.fromJson(association))
                ?.toList() ??
            List<Association>(),
        _groupeOuSeul = groupeOuSeul,
        _lieuDeVie = lieuDeVie,
        _horairesDeTravail = horairesDeTravail
                ?.map((dynamic horaireDeTravail) => horaireDeTravail.toString())
                ?.toList() ??
            List<HoraireDeTravail>(),
        _enligneOuNon = enligneOuNon,
        _matieresPreferees = matieresPreferees
                ?.map((dynamic matieresPreferee) => matieresPreferee.toString())
                ?.toList() ??
            List<String>(),
        _profilePicturePath = profilePicturePath,
        super(
          login: login,
          name: name,
          surname: surname,
          email: email,
          year: year,
        );

  factory UserScolaire.fromJson(Map<String, dynamic> json) => _$UserScolaireFromJson(json);

  Map<String, dynamic> toJson() => _$UserScolaireToJson(this);

  // Define all getter for the user info
  List<Association> get associations => _associations;

  double get groupeOuSeul => _groupeOuSeul;

  LieuDeVie get lieuDeVie => _lieuDeVie;

  List<HoraireDeTravail> get horairesDeTravail => _horairesDeTravail;

  OutilDeTravail get enligneOuNon => _enligneOuNon;

  List<String> get matieresPreferees => _matieresPreferees;

  String get profilePictureLocalPath => _profilePicturePath;

  Widget getProfilePicture({@required double height, @required double width}) {
    if (_profilePicturePath != null) {
      return ClipOval(
        child: Image.file(
          File(_profilePicturePath),
          height: height,
          width: width,
        ),
      );
    }

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

  bool isAnyAttributeNull() {
    return props.map((Object prop) => prop == null).contains(true);
  }

  @override
  List<Object> get props => [
        name,
        surname,
        email,
        primoEntrant,
        _associations,
        _groupeOuSeul,
        _lieuDeVie,
        _horairesDeTravail,
        _enligneOuNon,
        _matieresPreferees,
        _profilePicturePath
      ];
}

LieuDeVie getLieuDeVieFromString(String status) =>
    _$enumDecodeNullable(_$LieuDeVieEnumMap, status);

HoraireDeTravail getHoraireDeTravailFromString(String status) =>
    _$enumDecodeNullable(_$HoraireDeTravailEnumMap, status);

OutilDeTravail getOutilDeTravailFromString(String status) =>
    _$enumDecodeNullable(_$OutilDeTravailEnumMap, status);
