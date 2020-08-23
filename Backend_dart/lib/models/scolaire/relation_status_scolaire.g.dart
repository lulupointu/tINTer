// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_status_scolaire.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationStatusScolaire _$RelationStatusScolaireFromJson(
    Map<String, dynamic> json) {
  return RelationStatusScolaire(
    login: json['login'] as String,
    otherLogin: json['otherLogin'] as String,
    status: _$enumDecodeNullable(
        _$EnumRelationStatusScolaireEnumMap, json['status']),
  );
}

Map<String, dynamic> _$RelationStatusScolaireToJson(
        RelationStatusScolaire instance) =>
    <String, dynamic>{
      'login': instance.login,
      'otherLogin': instance.otherLogin,
      'status': _$EnumRelationStatusScolaireEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$EnumRelationStatusScolaireEnumMap = {
  EnumRelationStatusScolaire.none: 'none',
  EnumRelationStatusScolaire.ignored: 'ignored',
  EnumRelationStatusScolaire.liked: 'liked',
  EnumRelationStatusScolaire.askedBinome: 'askedBinome',
  EnumRelationStatusScolaire.acceptedBinome: 'acceptedBinome',
  EnumRelationStatusScolaire.refusedBinome: 'refusedBinome',
};