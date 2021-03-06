// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_status_scolaire.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const EnumRelationStatusScolaire _$none =
    const EnumRelationStatusScolaire._('none');
const EnumRelationStatusScolaire _$ignored =
    const EnumRelationStatusScolaire._('ignored');
const EnumRelationStatusScolaire _$liked =
    const EnumRelationStatusScolaire._('liked');
const EnumRelationStatusScolaire _$askedBinome =
    const EnumRelationStatusScolaire._('askedBinome');
const EnumRelationStatusScolaire _$acceptedBinome =
    const EnumRelationStatusScolaire._('acceptedBinome');
const EnumRelationStatusScolaire _$refusedBinome =
    const EnumRelationStatusScolaire._('refusedBinome');

EnumRelationStatusScolaire _$enumRelationStatusScolaireValueOf(String name) {
  switch (name) {
    case 'none':
      return _$none;
    case 'ignored':
      return _$ignored;
    case 'liked':
      return _$liked;
    case 'askedBinome':
      return _$askedBinome;
    case 'acceptedBinome':
      return _$acceptedBinome;
    case 'refusedBinome':
      return _$refusedBinome;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<EnumRelationStatusScolaire> _$enumRelationStatusScolaireValues =
    new BuiltSet<EnumRelationStatusScolaire>(const <EnumRelationStatusScolaire>[
  _$none,
  _$ignored,
  _$liked,
  _$askedBinome,
  _$acceptedBinome,
  _$refusedBinome,
]);

Serializer<RelationStatusScolaire> _$relationStatusScolaireSerializer =
    new _$RelationStatusScolaireSerializer();
Serializer<EnumRelationStatusScolaire> _$enumRelationStatusScolaireSerializer =
    new _$EnumRelationStatusScolaireSerializer();

class _$RelationStatusScolaireSerializer
    implements StructuredSerializer<RelationStatusScolaire> {
  @override
  final Iterable<Type> types = const [
    RelationStatusScolaire,
    _$RelationStatusScolaire
  ];
  @override
  final String wireName = 'RelationStatusScolaire';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationStatusScolaire object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'otherLogin',
      serializers.serialize(object.otherLogin,
          specifiedType: const FullType(String)),
      'statusScolaire',
      serializers.serialize(object.statusScolaire,
          specifiedType: const FullType(EnumRelationStatusScolaire)),
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
  RelationStatusScolaire deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationStatusScolaireBuilder();

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
        case 'statusScolaire':
          result.statusScolaire = serializers.deserialize(value,
                  specifiedType: const FullType(EnumRelationStatusScolaire))
              as EnumRelationStatusScolaire;
          break;
      }
    }

    return result.build();
  }
}

class _$EnumRelationStatusScolaireSerializer
    implements PrimitiveSerializer<EnumRelationStatusScolaire> {
  @override
  final Iterable<Type> types = const <Type>[EnumRelationStatusScolaire];
  @override
  final String wireName = 'EnumRelationStatusScolaire';

  @override
  Object serialize(Serializers serializers, EnumRelationStatusScolaire object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  EnumRelationStatusScolaire deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      EnumRelationStatusScolaire.valueOf(serialized as String);
}

class _$RelationStatusScolaire extends RelationStatusScolaire {
  @override
  final String login;
  @override
  final String otherLogin;
  @override
  final EnumRelationStatusScolaire statusScolaire;

  factory _$RelationStatusScolaire(
          [void Function(RelationStatusScolaireBuilder) updates]) =>
      (new RelationStatusScolaireBuilder()..update(updates)).build();

  _$RelationStatusScolaire._({this.login, this.otherLogin, this.statusScolaire})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        otherLogin, 'RelationStatusScolaire', 'otherLogin');
    BuiltValueNullFieldError.checkNotNull(
        statusScolaire, 'RelationStatusScolaire', 'statusScolaire');
  }

  @override
  RelationStatusScolaire rebuild(
          void Function(RelationStatusScolaireBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationStatusScolaireBuilder toBuilder() =>
      new RelationStatusScolaireBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationStatusScolaire &&
        login == other.login &&
        otherLogin == other.otherLogin &&
        statusScolaire == other.statusScolaire;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, login.hashCode), otherLogin.hashCode),
        statusScolaire.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationStatusScolaire')
          ..add('login', login)
          ..add('otherLogin', otherLogin)
          ..add('statusScolaire', statusScolaire))
        .toString();
  }
}

class RelationStatusScolaireBuilder
    implements Builder<RelationStatusScolaire, RelationStatusScolaireBuilder> {
  _$RelationStatusScolaire _$v;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  EnumRelationStatusScolaire _statusScolaire;
  EnumRelationStatusScolaire get statusScolaire => _$this._statusScolaire;
  set statusScolaire(EnumRelationStatusScolaire statusScolaire) =>
      _$this._statusScolaire = statusScolaire;

  RelationStatusScolaireBuilder();

  RelationStatusScolaireBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _otherLogin = $v.otherLogin;
      _statusScolaire = $v.statusScolaire;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationStatusScolaire other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RelationStatusScolaire;
  }

  @override
  void update(void Function(RelationStatusScolaireBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationStatusScolaire build() {
    final _$result = _$v ??
        new _$RelationStatusScolaire._(
            login: login,
            otherLogin: BuiltValueNullFieldError.checkNotNull(
                otherLogin, 'RelationStatusScolaire', 'otherLogin'),
            statusScolaire: BuiltValueNullFieldError.checkNotNull(
                statusScolaire, 'RelationStatusScolaire', 'statusScolaire'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
