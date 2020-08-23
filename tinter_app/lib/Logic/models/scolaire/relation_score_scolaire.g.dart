// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_score_scolaire.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RelationScoreScolaire> _$relationScoreScolaireSerializer =
    new _$RelationScoreScolaireSerializer();

class _$RelationScoreScolaireSerializer
    implements StructuredSerializer<RelationScoreScolaire> {
  @override
  final Iterable<Type> types = const [
    RelationScoreScolaire,
    _$RelationScoreScolaire
  ];
  @override
  final String wireName = 'RelationScoreScolaire';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationScoreScolaire object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'otherLogin',
      serializers.serialize(object.otherLogin,
          specifiedType: const FullType(String)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  RelationScoreScolaire deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationScoreScolaireBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherLogin':
          result.otherLogin = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$RelationScoreScolaire extends RelationScoreScolaire {
  @override
  final String login;
  @override
  final String otherLogin;
  @override
  final int score;

  factory _$RelationScoreScolaire(
          [void Function(RelationScoreScolaireBuilder) updates]) =>
      (new RelationScoreScolaireBuilder()..update(updates)).build();

  _$RelationScoreScolaire._({this.login, this.otherLogin, this.score})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('RelationScoreScolaire', 'login');
    }
    if (otherLogin == null) {
      throw new BuiltValueNullFieldError('RelationScoreScolaire', 'otherLogin');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('RelationScoreScolaire', 'score');
    }
  }

  @override
  RelationScoreScolaire rebuild(
          void Function(RelationScoreScolaireBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationScoreScolaireBuilder toBuilder() =>
      new RelationScoreScolaireBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationScoreScolaire &&
        login == other.login &&
        otherLogin == other.otherLogin &&
        score == other.score;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, login.hashCode), otherLogin.hashCode), score.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RelationScoreScolaire')
          ..add('login', login)
          ..add('otherLogin', otherLogin)
          ..add('score', score))
        .toString();
  }
}

class RelationScoreScolaireBuilder
    implements Builder<RelationScoreScolaire, RelationScoreScolaireBuilder> {
  _$RelationScoreScolaire _$v;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  RelationScoreScolaireBuilder();

  RelationScoreScolaireBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login;
      _otherLogin = _$v.otherLogin;
      _score = _$v.score;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationScoreScolaire other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelationScoreScolaire;
  }

  @override
  void update(void Function(RelationScoreScolaireBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationScoreScolaire build() {
    final _$result = _$v ??
        new _$RelationScoreScolaire._(
            login: login, otherLogin: otherLogin, score: score);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new