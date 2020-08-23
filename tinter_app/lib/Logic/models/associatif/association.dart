import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tinterapp/Logic/models/token.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';

part 'association.g.dart';

@JsonSerializable(explicitToJson: true)
class Association extends Equatable {
  final String name;
  final String description;

  Association({this.name, this.description});

  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationToJson(this);

  String toString() =>
      '(Association) name: $name, description: $description';

  Widget getLogo() {
    return FutureBuilder(
      future: AuthenticationRepository.getAuthenticationToken(),
      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
        return (!snapshot.hasData) ? CircularProgressIndicator() : Image.network(
          Uri.http(TinterAPIClient.baseUrl, '/associations/associationLogo', {'associationName': name}).toString(),
          headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
          fit: BoxFit.contain,
        );
      },
    );
  }

  @override
  List<Object> get props => [name, description];

}

