// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_status_binome_pair.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnumRelationStatusBinomePair _$none =
    const EnumRelationStatusBinomePair._('none');
const EnumRelationStatusBinomePair _$ignored =
    const EnumRelationStatusBinomePair._('ignored');
const EnumRelationStatusBinomePair _$liked =
    const EnumRelationStatusBinomePair._('liked');
const EnumRelationStatusBinomePair _$askedBinomePairMatch =
    const EnumRelationStatusBinomePair._('askedBinomePairMatch');
const EnumRelationStatusBinomePair _$acceptedBinomePairMatch =
    const EnumRelationStatusBinomePair._('acceptedBinomePairMatch');
const EnumRelationStatusBinomePair _$refusedBinomePairMatch =
    const EnumRelationStatusBinomePair._('refusedBinomePairMatch');

EnumRelationStatusBinomePair _$enumRelationStatusBinomePairValueOf(
    String name) {
  switch (name) {
    case 'none':
      return _$none;
    case 'ignored':
      return _$ignored;
    case 'liked':
      return _$liked;
    case 'askedBinomePairMatch':
      return _$askedBinomePairMatch;
    case 'acceptedBinomePairMatch':
      return _$acceptedBinomePairMatch;
    case 'refusedBinomePairMatch':
      return _$refusedBinomePairMatch;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<EnumRelationStatusBinomePair>
    _$enumRelationStatusBinomePairValues = new BuiltSet<
        EnumRelationStatusBinomePair>(const <EnumRelationStatusBinomePair>[
  _$none,
  _$ignored,
  _$liked,
  _$askedBinomePairMatch,
  _$acceptedBinomePairMatch,
  _$refusedBinomePairMatch,
]);

Serializer<RelationStatusBinomePair> _$relationStatusBinomePairSerializer =
    new _$RelationStatusBinomePairSerializer();
Serializer<EnumRelationStatusBinomePair>
    _$enumRelationStatusBinomePairSerializer =
    new _$EnumRelationStatusBinomePairSerializer();

class _$RelationStatusBinomePairSerializer
    implements StructuredSerializer<RelationStatusBinomePair> {
  @override
  final Iterable<Type> types = const [
    RelationStatusBinomePair,
    _$RelationStatusBinomePair
  ];
  @override
  final String wireName = 'RelationStatusBinomePair';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationStatusBinomePair object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'otherBinomePairId',
      serializers.serialize(object.otherBinomePairId,
          specifiedType: const FullType(int)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(EnumRelationStatusBinomePair)),
    ];
    if (object.binomePairId != null) {
      result
        ..add('binomePairId')
        ..add(serializers.serialize(object.binomePairId,
            specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  RelationStatusBinomePair deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationStatusBinomePairBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'binomePairId':
          result.binomePairId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'otherBinomePairId':
          result.otherBinomePairId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
                  specifiedType: const FullType(EnumRelationStatusBinomePair))
              as EnumRelationStatusBinomePair;
          break;
      }
    }

    return result.build();
  }
}

class _$EnumRelationStatusBinomePairSerializer
    implements PrimitiveSerializer<EnumRelationStatusBinomePair> {
  @override
  final Iterable<Type> types = const <Type>[EnumRelationStatusBinomePair];
  @override
  final String wireName = 'EnumRelationStatusBinomePair';

  @override
  Object serialize(Serializers serializers, EnumRelationStatusBinomePair object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  EnumRelationStatusBinomePair deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnumRelationStatusBinomePair.valueOf(serialized as String);
}

class _$RelationStatusBinomePair extends RelationStatusBinomePair {
  @override
  final int binomePairId;
  @override
  final int otherBinomePairId;
  @override
  final EnumRelationStatusBinomePair status;

  factory _$RelationStatusBinomePair(
          [void Function(RelationStatusBinomePairBuilder) updates]) =>
      (new RelationStatusBinomePairBuilder()..update(updates)).build();

  _$RelationStatusBinomePair._(
      {this.binomePairId, this.otherBinomePairId, this.status})
      : super._() {
    if (otherBinomePairId == null) {
      throw new BuiltValueNullFieldError(
          'RelationStatusBinomePair', 'otherBinomePairId');
    }
    if (status == null) {
      throw new BuiltValueNullFieldError('RelationStatusBinomePair', 'status');
    }
  }

  @override
  RelationStatusBinomePair rebuild(
          void Function(RelationStatusBinomePairBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationStatusBinomePairBuilder toBuilder() =>
      new RelationStatusBinomePairBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationStatusBinomePair &&
        binomePairId == other.binomePairId &&
        otherBinomePairId == other.otherBinomePairId &&
        status == other.status;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, binomePairId.hashCode), otherBinomePairId.hashCode),
        status.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationStatusBinomePair')
          ..add('binomePairId', binomePairId)
          ..add('otherBinomePairId', otherBinomePairId)
          ..add('status', status))
        .toString();
  }
}

class RelationStatusBinomePairBuilder
    implements
        Builder<RelationStatusBinomePair, RelationStatusBinomePairBuilder> {
  _$RelationStatusBinomePair _$v;

  int _binomePairId;
  int get binomePairId => _$this._binomePairId;
  set binomePairId(int binomePairId) => _$this._binomePairId = binomePairId;

  int _otherBinomePairId;
  int get otherBinomePairId => _$this._otherBinomePairId;
  set otherBinomePairId(int otherBinomePairId) =>
      _$this._otherBinomePairId = otherBinomePairId;

  EnumRelationStatusBinomePair _status;
  EnumRelationStatusBinomePair get status => _$this._status;
  set status(EnumRelationStatusBinomePair status) => _$this._status = status;

  RelationStatusBinomePairBuilder();

  RelationStatusBinomePairBuilder get _$this {
    if (_$v != null) {
      _binomePairId = _$v.binomePairId;
      _otherBinomePairId = _$v.otherBinomePairId;
      _status = _$v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationStatusBinomePair other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelationStatusBinomePair;
  }

  @override
  void update(void Function(RelationStatusBinomePairBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationStatusBinomePair build() {
    final _$result = _$v ??
        new _$RelationStatusBinomePair._(
            binomePairId: binomePairId,
            otherBinomePairId: otherBinomePairId,
            status: status);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
