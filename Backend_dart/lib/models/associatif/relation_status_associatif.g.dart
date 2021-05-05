// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_status_associatif.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnumRelationStatusAssociatif _$none =
    const EnumRelationStatusAssociatif._('none');
const EnumRelationStatusAssociatif _$ignored =
    const EnumRelationStatusAssociatif._('ignored');
const EnumRelationStatusAssociatif _$liked =
    const EnumRelationStatusAssociatif._('liked');
const EnumRelationStatusAssociatif _$askedParrain =
    const EnumRelationStatusAssociatif._('askedParrain');
const EnumRelationStatusAssociatif _$acceptedParrain =
    const EnumRelationStatusAssociatif._('acceptedParrain');
const EnumRelationStatusAssociatif _$refusedParrain =
    const EnumRelationStatusAssociatif._('refusedParrain');

EnumRelationStatusAssociatif _$enumRelationStatusAssociatifValueOf(
    String name) {
  switch (name) {
    case 'none':
      return _$none;
    case 'ignored':
      return _$ignored;
    case 'liked':
      return _$liked;
    case 'askedParrain':
      return _$askedParrain;
    case 'acceptedParrain':
      return _$acceptedParrain;
    case 'refusedParrain':
      return _$refusedParrain;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<EnumRelationStatusAssociatif>
    _$enumRelationStatusAssociatifValues = new BuiltSet<
        EnumRelationStatusAssociatif>(const <EnumRelationStatusAssociatif>[
  _$none,
  _$ignored,
  _$liked,
  _$askedParrain,
  _$acceptedParrain,
  _$refusedParrain,
]);

Serializer<EnumRelationStatusAssociatif>
    _$enumRelationStatusAssociatifSerializer =
    new _$EnumRelationStatusAssociatifSerializer();
Serializer<RelationStatusAssociatif> _$relationStatusAssociatifSerializer =
    new _$RelationStatusAssociatifSerializer();

class _$EnumRelationStatusAssociatifSerializer
    implements PrimitiveSerializer<EnumRelationStatusAssociatif> {
  @override
  final Iterable<Type> types = const <Type>[EnumRelationStatusAssociatif];
  @override
  final String wireName = 'EnumRelationStatusAssociatif';

  @override
  Object serialize(Serializers serializers, EnumRelationStatusAssociatif object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  EnumRelationStatusAssociatif deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnumRelationStatusAssociatif.valueOf(serialized as String);
}

class _$RelationStatusAssociatifSerializer
    implements StructuredSerializer<RelationStatusAssociatif> {
  @override
  final Iterable<Type> types = const [
    RelationStatusAssociatif,
    _$RelationStatusAssociatif
  ];
  @override
  final String wireName = 'RelationStatusAssociatif';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationStatusAssociatif object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'otherLogin',
      serializers.serialize(object.otherLogin,
          specifiedType: const FullType(String)),
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(EnumRelationStatusAssociatif)),
    ];
    Object value;
    value = object.login;
    if (value != null) {
      result
        ..add('login')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  RelationStatusAssociatif deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationStatusAssociatifBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherLogin':
          result.otherLogin = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
                  specifiedType: const FullType(EnumRelationStatusAssociatif))
              as EnumRelationStatusAssociatif;
          break;
      }
    }

    return result.build();
  }
}

class _$RelationStatusAssociatif extends RelationStatusAssociatif {
  @override
  final String login;
  @override
  final String otherLogin;
  @override
  final EnumRelationStatusAssociatif status;

  factory _$RelationStatusAssociatif(
          [void Function(RelationStatusAssociatifBuilder) updates]) =>
      (new RelationStatusAssociatifBuilder()..update(updates)).build();

  _$RelationStatusAssociatif._({this.login, this.otherLogin, this.status})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        otherLogin, 'RelationStatusAssociatif', 'otherLogin');
    BuiltValueNullFieldError.checkNotNull(
        status, 'RelationStatusAssociatif', 'status');
  }

  @override
  RelationStatusAssociatif rebuild(
          void Function(RelationStatusAssociatifBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationStatusAssociatifBuilder toBuilder() =>
      new RelationStatusAssociatifBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationStatusAssociatif &&
        login == other.login &&
        otherLogin == other.otherLogin &&
        status == other.status;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, login.hashCode), otherLogin.hashCode), status.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationStatusAssociatif')
          ..add('login', login)
          ..add('otherLogin', otherLogin)
          ..add('status', status))
        .toString();
  }
}

class RelationStatusAssociatifBuilder
    implements
        Builder<RelationStatusAssociatif, RelationStatusAssociatifBuilder> {
  _$RelationStatusAssociatif _$v;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  EnumRelationStatusAssociatif _status;
  EnumRelationStatusAssociatif get status => _$this._status;
  set status(EnumRelationStatusAssociatif status) => _$this._status = status;

  RelationStatusAssociatifBuilder();

  RelationStatusAssociatifBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _otherLogin = $v.otherLogin;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationStatusAssociatif other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RelationStatusAssociatif;
  }

  @override
  void update(void Function(RelationStatusAssociatifBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationStatusAssociatif build() {
    final _$result = _$v ??
        new _$RelationStatusAssociatif._(
            login: login,
            otherLogin: BuiltValueNullFieldError.checkNotNull(
                otherLogin, 'RelationStatusAssociatif', 'otherLogin'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, 'RelationStatusAssociatif', 'status'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
