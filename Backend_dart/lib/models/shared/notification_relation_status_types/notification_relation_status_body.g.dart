// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_relation_status_body.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationRelationStatusBody>
    _$notificationRelationStatusBodySerializer =
    new _$NotificationRelationStatusBodySerializer();

class _$NotificationRelationStatusBodySerializer
    implements StructuredSerializer<NotificationRelationStatusBody> {
  @override
  final Iterable<Type> types = const [
    NotificationRelationStatusBody,
    _$NotificationRelationStatusBody
  ];
  @override
  final String wireName = 'NotificationRelationStatusBody';

  @override
  Iterable<Object> serialize(
      Serializers serializers, NotificationRelationStatusBody object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'relationStatus',
      serializers.serialize(object.relationStatus,
          specifiedType: const FullType(RelationStatus)),
    ];

    return result;
  }

  @override
  NotificationRelationStatusBody deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new NotificationRelationStatusBodyBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'relationStatus':
          result.relationStatus = serializers.deserialize(value,
              specifiedType: const FullType(RelationStatus)) as RelationStatus;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationRelationStatusBody extends NotificationRelationStatusBody {
  @override
  final RelationStatus relationStatus;

  factory _$NotificationRelationStatusBody(
          [void Function(NotificationRelationStatusBodyBuilder) updates]) =>
      (new NotificationRelationStatusBodyBuilder()..update(updates)).build();

  _$NotificationRelationStatusBody._({this.relationStatus}) : super._() {
    if (relationStatus == null) {
      throw new BuiltValueNullFieldError(
          'NotificationRelationStatusBody', 'relationStatus');
    }
  }

  @override
  NotificationRelationStatusBody rebuild(
          void Function(NotificationRelationStatusBodyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationRelationStatusBodyBuilder toBuilder() =>
      new NotificationRelationStatusBodyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationRelationStatusBody &&
        relationStatus == other.relationStatus;
  }

  @override
  int get hashCode {
    return $jf($jc(0, relationStatus.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NotificationRelationStatusBody')
          ..add('relationStatus', relationStatus))
        .toString();
  }
}

class NotificationRelationStatusBodyBuilder
    implements
        Builder<NotificationRelationStatusBody,
            NotificationRelationStatusBodyBuilder> {
  _$NotificationRelationStatusBody _$v;

  RelationStatus _relationStatus;
  RelationStatus get relationStatus => _$this._relationStatus;
  set relationStatus(RelationStatus relationStatus) =>
      _$this._relationStatus = relationStatus;

  NotificationRelationStatusBodyBuilder();

  NotificationRelationStatusBodyBuilder get _$this {
    if (_$v != null) {
      _relationStatus = _$v.relationStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationRelationStatusBody other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NotificationRelationStatusBody;
  }

  @override
  void update(void Function(NotificationRelationStatusBodyBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NotificationRelationStatusBody build() {
    final _$result = _$v ??
        new _$NotificationRelationStatusBody._(relationStatus: relationStatus);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
