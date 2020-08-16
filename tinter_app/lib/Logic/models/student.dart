import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/static_student.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

part 'student.g.dart';

@JsonSerializable(explicitToJson: true)
@JsonSerializable(explicitToJson: true)
class Student extends StaticStudent {
  final List<Association> _associations;
  final double _attiranceVieAsso;
  final double _feteOuCours;
  final double _aideOuSortir;
  final double _organisationEvenements;
  final List<String> _goutsMusicaux;
  final String _profilePictureUrl;

  Student({
    @required String login,
    @required String name,
    @required String surname,
    @required String email,
    @required bool primoEntrant,
    @required List<dynamic> associations,
    @required double attiranceVieAsso,
    @required double feteOuCours,
    @required double aideOuSortir,
    @required double organisationEvenements,
    @required List<dynamic> goutsMusicaux,
    String profilePictureUrl,
  })  : _associations = associations
            ?.map((var association) =>
                (association is Association) ? association : Association.fromJson(association))
            ?.toList(),
        _attiranceVieAsso = attiranceVieAsso,
        _feteOuCours = feteOuCours,
        _aideOuSortir = aideOuSortir,
        _organisationEvenements = organisationEvenements,
        _goutsMusicaux =
            goutsMusicaux?.map((dynamic goutMusical) => goutMusical.toString())?.toList(),
        _profilePictureUrl = profilePictureUrl,
        super(
          login: login,
          name: name,
          surname: surname,
          email: email,
          primoEntrant: primoEntrant,
        );

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  // Define all getter for the user info
  List<Association> get associations => _associations;

  double get attiranceVieAsso => _attiranceVieAsso;

  double get feteOuCours => _feteOuCours;

  double get aideOuSortir => _aideOuSortir;

  double get organisationEvenements => _organisationEvenements;

  List<String> get goutsMusicaux => _goutsMusicaux;

  Widget get profilePicture {
    return FutureBuilder(
      future: AuthenticationRepository.getAuthenticationToken(),
      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
        return (!snapshot.hasData)
            ? CircularProgressIndicator()
            : Image.network(
                _profilePictureUrl ??
                    Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture').toString(),
                headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
              );
      },
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
        associations,
        attiranceVieAsso,
        feteOuCours,
        aideOuSortir,
        organisationEvenements,
        goutsMusicaux,
        _profilePictureUrl,
      ];
}
