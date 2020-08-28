
import 'dart:io';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' as flutterMaterial;
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/scolaire/user_scolaire.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

abstract class BuildUser with User implements Built<BuildUser, BuildUserBuilder> {

  BuildUser._();
  factory BuildUser([void Function(BuildUserBuilder) updates]) = _$BuildUser;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildUser.serializer, this);
  }

  static BuildUser fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildUser.serializer, json);
  }

  static Serializer<BuildUser> get serializer => _$buildUserSerializer;
}

abstract class User extends Object {
  String get login;

  String get name;

  String get surname;

  String get email;

  School get school;

  @nullable
  String get profilePictureLocalPath;

  BuiltList<Association> get associations;

  // Attributes relative to the association part of the app
  bool get primoEntrant;

  double get attiranceVieAsso;

  double get feteOuCours;

  double get aideOuSortir;

  double get organisationEvenements;

  List<String> get goutsMusicaux;

  // Attributes relative to the scolaire part of the app
  TSPYear get year;

  GroupeOuSeul get groupeOuSeul;

  LieuDeVie get lieuDeVie;

  BuiltList<HoraireDeTravail> get horairesDeTravail;

  OutilDeTravail get enligneOuNon;

  BuiltList<String> get matieresPreferees;
}

class School extends EnumClass {
  static const School TSP = _$TSP;
  static const School IMTBS = _$IMTBS;


  const School._(String name) : super(name);

  static BuiltSet<School> get values => _$schoolValues;
  static School valueOf(String name) => _$schoolValueOf(name);

  String serialize() {
    return serializers.serializeWith(School.serializer, this);
  }

  static School deserialize(String string) {
    return serializers.deserializeWith(School.serializer, string);
  }

  static Serializer<School> get serializer => _$schoolSerializer;

}




//enum School { TSP, IMTBS }
//abstract class User implements Built<User, UserBuilder> {
//  String get login;
//  String get name;
//  String get surname;
//  String get email;
//  School get school;
//  String get profilePictureLocalPath;
//  List<Association> get associations;
//
//  User._();
//
//  factory User([updates(UserBuilder u)]) = $_User;

//  User({
//    @required login,
//    @required name,
//    @required surname,
//    @required email,
//    @required school,
//    profilePictureLocalPath,
//    List<dynamic> associations = const [],
//  })  : assert(login != null),
//        assert(name != null),
//        assert(surname != null),
//        _login = login,
//        _name = name,
//        _surname = surname,
//        _email = email,
//        _school = school,
//        _profilePictureLocalPath = profilePictureLocalPath,
//        _associations = associations
//            ?.map((var association) => (association is Association)
//            ? association
//            : Association.fromJson(association))
//            ?.toList() ??
//            List<Association>();
//
//  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//
//  Map<String, dynamic> toJson() => _$UserToJson(this);
//
//  // Define all getter for the user info
//  String get login => _login;
//
//  String get name => _name;
//
//  String get surname => _surname;
//
//  String get email => _email;
//
//  School get school => _school;
//
//  String get profilePictureLocalPath => _profilePictureLocalPath;
//
//  List<Association> get associations => _associations;
//
//  Widget getProfilePicture({@required double height, @required double width}) {
//    if (_profilePictureLocalPath != null) {
//      return ClipOval(
//        child: Image.file(
//          File(_profilePictureLocalPath),
//          height: height,
//          width: width,
//        ),
//      );
//    }
//
//    return ClipOval(
//      child: FutureBuilder(
//        future: AuthenticationRepository.getAuthenticationToken(),
//        builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//          return (!snapshot.hasData)
//              ? Center(child: CircularProgressIndicator())
//              : Image.network(
//            Uri.http(TinterAPIClient.baseUrl, '/user/profilePicture', {'login': login})
//                .toString(),
//            headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//            height: height,
//            width: width,
//          );
//        },
//      ),
//    );
//  }
//
//  @override
//  List<Object> get props => [
//    login,
//    name,
//    surname,
//    email,
//    school,
//    profilePictureLocalPath,
//    associations,
//  ];
//}
