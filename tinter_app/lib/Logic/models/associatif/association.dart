import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' as flutterMaterial;
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/token.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

part 'association.g.dart';

abstract class Association implements Built<Association, AssociationBuilder> {
  String get name;
  String get description;

  Association._();
  factory Association([void Function(AssociationBuilder) updates]) = _$Association;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Association.serializer, this);
  }

  static Association fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Association.serializer, json);
  }

  static Serializer<Association> get serializer => _$associationSerializer;

}

//@JsonSerializable(explicitToJson: true)
//class Association extends Equatable {
//  final String name;
//  final String description;
//
//  Association({this.name, this.description});
//
//  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);
//
//  Map<String, dynamic> toJson() => _$AssociationToJson(this);
//
//  String toString() =>
//      '(Association) name: $name, description: $description';
//
//  Widget getLogo() {
//    return FutureBuilder(
//      future: AuthenticationRepository.getAuthenticationToken(),
//      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//        return (!snapshot.hasData) ? CircularProgressIndicator() : Image.network(
//          Uri.http(TinterAPIClient.baseUrl, '/associations/associationLogo', {'associationName': name}).toString(),
//          headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//          fit: BoxFit.contain,
//        );
//      },
//    );
//  }
//
//  @override
//  List<Object> get props => [name, description];
//
//}

