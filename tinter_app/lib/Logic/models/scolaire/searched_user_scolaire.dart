import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

part 'searched_user_scolaire.g.dart';

@JsonSerializable(explicitToJson: true)
/// This is the static part of every student
/// Meaning the part they can't change.
class SearchedUserScolaire extends Equatable {
  final String _login;
  final String _name;
  final String _surname;
  final bool _liked;

  SearchedUserScolaire({
    @required login,
    @required name,
    @required surname,
    @required liked,
  })  : assert(login != null),
        assert(name != null),
        assert(surname != null),
        assert(liked != null),
        _login = login,
        _name = name,
        _surname = surname,
        _liked = liked;

  factory SearchedUserScolaire.fromJson(Map<String, dynamic> json) => _$SearchedUserScolaireFromJson(json);

  Map<String, dynamic> toJson() => _$SearchedUserScolaireToJson(this);

  // Define all getter for the user info
  String get login => _login;

  String get name => _name;

  String get surname => _surname;

  bool get liked => _liked;


  @override
  List<Object> get props =>
      [
        name,
        surname,
        liked
      ];

  Widget getProfilePicture({@required double height, @required double width}) {

    return ClipOval(
      child: FutureBuilder(
        future: AuthenticationRepository.getAuthenticationToken(),
        builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
          return (!snapshot.hasData)
              ? Center(child: CircularProgressIndicator())
              : Image.network(
            Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login}).toString(),
            headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
            height: height,
            width: width,
          );
        },
      ),
    );
  }
}
