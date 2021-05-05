// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Association> _$associationSerializer = new _$AssociationSerializer();

class _$AssociationSerializer implements StructuredSerializer<Association> {
  @override
  final Iterable<Type> types = const [Association, _$Association];
  @override
  final String wireName = 'Association';

  @override
  Iterable<Object> serialize(Serializers serializers, Association object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Association deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AssociationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Association extends Association {
  @override
  final String name;
  @override
  final String description;

  factory _$Association([void Function(AssociationBuilder) updates]) =>
      (new AssociationBuilder()..update(updates)).build();

  _$Association._({this.name, this.description}) : super._() {
    BuiltValueNullFieldError.checkNotNull(name, 'Association', 'name');
    BuiltValueNullFieldError.checkNotNull(
        description, 'Association', 'description');
  }

  @override
  Association rebuild(void Function(AssociationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssociationBuilder toBuilder() => new AssociationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Association &&
        name == other.name &&
        description == other.description;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), description.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Association')
          ..add('name', name)
          ..add('description', description))
        .toString();
  }
}

class AssociationBuilder implements Builder<Association, AssociationBuilder> {
  _$Association _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  AssociationBuilder();

  AssociationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Association other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Association;
  }

  @override
  void update(void Function(AssociationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Association build() {
    final _$result = _$v ??
        new _$Association._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'Association', 'name'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, 'Association', 'description'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
