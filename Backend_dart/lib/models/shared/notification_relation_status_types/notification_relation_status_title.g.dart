// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_relation_status_title.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const NotificationRelationStatusTitle _$relationStatusAssociatifUpdate =
    const NotificationRelationStatusTitle._('relationStatusAssociatifUpdate');
const NotificationRelationStatusTitle _$relationStatusScolaireUpdate =
    const NotificationRelationStatusTitle._('relationStatusScolaireUpdate');
const NotificationRelationStatusTitle _$relationStatusBinomeUpdate =
    const NotificationRelationStatusTitle._('relationStatusBinomeUpdate');

NotificationRelationStatusTitle _$notificationRelationStatusTitleValueOf(
    String name) {
  switch (name) {
    case 'relationStatusAssociatifUpdate':
      return _$relationStatusAssociatifUpdate;
    case 'relationStatusScolaireUpdate':
      return _$relationStatusScolaireUpdate;
    case 'relationStatusBinomeUpdate':
      return _$relationStatusBinomeUpdate;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<NotificationRelationStatusTitle>
    _$notificationRelationStatusTitleValues =
    new BuiltSet<NotificationRelationStatusTitle>(const <
        NotificationRelationStatusTitle>[
  _$relationStatusAssociatifUpdate,
  _$relationStatusScolaireUpdate,
  _$relationStatusBinomeUpdate,
]);

Serializer<NotificationRelationStatusTitle>
    _$notificationRelationStatusTitleSerializer =
    new _$NotificationRelationStatusTitleSerializer();

class _$NotificationRelationStatusTitleSerializer
    implements PrimitiveSerializer<NotificationRelationStatusTitle> {
  @override
  final Iterable<Type> types = const <Type>[NotificationRelationStatusTitle];
  @override
  final String wireName = 'NotificationRelationStatusTitle';

  @override
  Object serialize(
          Serializers serializers, NotificationRelationStatusTitle object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  NotificationRelationStatusTitle deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      NotificationRelationStatusTitle.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
