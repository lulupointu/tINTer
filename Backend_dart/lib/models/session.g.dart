// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  return Session(
    token: json['token'] as String,
    login: json['login'] as String,
    creationDate: json['creationDate'] == null
        ? null
        : DateTime.parse(json['creationDate'] as String),
    isValid: json['isValid'] as bool,
  );
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'token': instance.token,
      'login': instance.login,
      'creationDate': instance.creationDate?.toIso8601String(),
      'isValid': instance.isValid,
    };
