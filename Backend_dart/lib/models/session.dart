import 'dart:convert';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session.g.dart';

@JsonSerializable(explicitToJson: true)
class Session extends Equatable {
  static final MaximumLifeTime = Duration(days: 30);
  static final MaximumTimeBeforeRefresh = Duration(days: 1);
  final String token;
  final String login;
  final DateTime creationDate;
  final bool isValid;

  const Session({
    @required this.token,
    @required this.login,
    @required this.creationDate,
    @required this.isValid,
  });

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  @override
  List<Object> get props => [token, login, creationDate, isValid];
}

String generateNewToken() {
  final int tokenSize = 32;

  Random randomSecure = Random.secure();
  var values = List<int>.generate(tokenSize, (i) => randomSecure.nextInt(256));

  return base64UrlEncode(values);
}

