import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';

part 'searched_user_associatif.g.dart';

abstract class SearchedUserAssociatif implements Built<SearchedUserAssociatif, SearchedUserAssociatifBuilder> {
  String get login;
  String get name;
  String get surname;
  bool get liked;

  SearchedUserAssociatif._();
  factory SearchedUserAssociatif([void Function(SearchedUserAssociatifBuilder) updates]) = _$SearchedUserAssociatif;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchedUserAssociatif.serializer, this);
  }

  static SearchedUserAssociatif fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchedUserAssociatif.serializer, json);
  }

  static Serializer<SearchedUserAssociatif> get serializer => _$searchedUserAssociatifSerializer;
}

//import 'dart:io';
//
//import 'package:equatable/equatable.dart';
//import 'package:flutter/material.dart';
//import 'package:json_annotation/json_annotation.dart';
//import 'package:meta/meta.dart';
//import 'package:tinterapp/Logic/models/shared/token.dart';
//import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
//import 'package:tinterapp/Network/tinter_api_client.dart';
//
//part 'searched_user_associatif.g.dart';
//
//@JsonSerializable(explicitToJson: true)
///// This is the static part of every student
///// Meaning the part they can't change.
//class SearchedUserAssociatif extends Equatable {
//  final String _login;
//  final String _name;
//  final String _surname;
//  final bool _liked;
//
//  SearchedUserAssociatif({
//    @required login,
//    @required name,
//    @required surname,
//    @required liked,
//  })  : assert(login != null),
//        assert(name != null),
//        assert(surname != null),
//        assert(liked != null),
//        _login = login,
//        _name = name,
//        _surname = surname,
//        _liked = liked;
//
//  factory SearchedUserAssociatif.fromJson(Map<String, dynamic> json) => _$SearchedUserAssociatifFromJson(json);
//
//  Map<String, dynamic> toJson() => _$SearchedUserAssociatifToJson(this);
//
//  // Define all getter for the user info
//  String get login => _login;
//
//  String get name => _name;
//
//  String get surname => _surname;
//
//  bool get liked => _liked;
//
//
//  @override
//  List<Object> get props =>
//      [
//        name,
//        surname,
//        liked
//      ];
//
//  Widget getProfilePicture({@required double height, @required double width}) {
//
//    return ClipOval(
//      child: FutureBuilder(
//        future: AuthenticationRepository.getAuthenticationToken(),
//        builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//          return (!snapshot.hasData)
//              ? Center(child: CircularProgressIndicator())
//              : Image.network(
//            Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login}).toString(),
//            headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//            height: height,
//            width: width,
//          );
//        },
//      ),
//    );
//  }
//}
