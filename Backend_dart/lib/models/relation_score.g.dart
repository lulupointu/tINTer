// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationScore _$RelationScoreFromJson(Map<String, dynamic> json) {
  return RelationScore(
    login: json['login'] as String,
    otherLogin: json['otherLogin'] as String,
    score: json['score'] as int,
  );
}

Map<String, dynamic> _$RelationScoreToJson(RelationScore instance) =>
    <String, dynamic>{
      'login': instance.login,
      'otherLogin': instance.otherLogin,
      'score': instance.score,
    };
