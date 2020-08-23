import 'dart:convert';
import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'session.g.dart';

abstract class Session implements Built<Session, SessionBuilder> {

  static final MaximumLifeTime = Duration(days: 30);
  static final MaximumTimeBeforeRefresh = Duration(days: 1);

  String get token;

  String get login;

  DateTime get creationDate;

  bool get isValid;

  Session._();

  factory Session([void Function(SessionBuilder) updates]) = _$Session;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Session.serializer, this);
  }

  static Session fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Session.serializer, json);
  }

  static Serializer<Session> get serializer => _$sessionSerializer;
}

String generateNewToken() {
  final int tokenSize = 32;

  Random randomSecure = Random.secure();
  var values = List<int>.generate(tokenSize, (i) => randomSecure.nextInt(256));

  return base64UrlEncode(values);
}

//@JsonSerializable(explicitToJson: true)
//class Session extends Equatable {
//  static final MaximumLifeTime = Duration(days: 30);
//  static final MaximumTimeBeforeRefresh = Duration(days: 1);
//  final String token;
//  final String login;
//  final DateTime creationDate;
//  final bool isValid;
//
//  const Session({
//    @required this.token,
//    @required this.login,
//    @required this.creationDate,
//    @required this.isValid,
//  });
//
//  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
//
//  Map<String, dynamic> toJson() => _$SessionToJson(this);
//
//  @override
//  List<Object> get props => [token, login, creationDate, isValid];
//}

