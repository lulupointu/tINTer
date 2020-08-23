// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_score_scolaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationScoreScolaire _$RelationScoreScolaireFromJson(
    Map<String, dynamic> json) {
  return RelationScoreScolaire(
    login: json['login'] as String,
    otherLogin: json['otherLogin'] as String,
    score: json['score'] as int,
  );
}

Map<String, dynamic> _$RelationScoreScolaireToJson(
        RelationScoreScolaire instance) =>
    <String, dynamic>{
      'login': instance.login,
      'otherLogin': instance.otherLogin,
      'score': instance.score,
    };
