// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationStatus _$RelationStatusFromJson(Map<String, dynamic> json) {
  return RelationStatus(
    login: json['login'] as String,
    otherLogin: json['otherLogin'] as String,
    status: _$enumDecodeNullable(_$EnumRelationStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$RelationStatusToJson(RelationStatus instance) =>
    <String, dynamic>{
      'login': instance.login,
      'otherLogin': instance.otherLogin,
      'status': _$EnumRelationStatusEnumMap[instance.status],
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

const _$EnumRelationStatusEnumMap = {
  EnumRelationStatus.none: 'none',
  EnumRelationStatus.ignored: 'ignored',
  EnumRelationStatus.liked: 'liked',
  EnumRelationStatus.askedParrain: 'askedParrain',
  EnumRelationStatus.acceptedParrain: 'acceptedParrain',
  EnumRelationStatus.refusedParrain: 'refusedParrain',
};
