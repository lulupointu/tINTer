// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relation_score_associatif.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RelationScoreAssociatif> _$relationScoreAssociatifSerializer =
    new _$RelationScoreAssociatifSerializer();

class _$RelationScoreAssociatifSerializer
    implements StructuredSerializer<RelationScoreAssociatif> {
  @override
  final Iterable<Type> types = const [
    RelationScoreAssociatif,
    _$RelationScoreAssociatif
  ];
  @override
  final String wireName = 'RelationScoreAssociatif';

  @override
  Iterable<Object> serialize(
      Serializers serializers, RelationScoreAssociatif object,
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
  RelationScoreAssociatif deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new RelationScoreAssociatifBuilder();

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

class _$RelationScoreAssociatif extends RelationScoreAssociatif {
  @override
  final String login;
  @override
  final String otherLogin;
  @override
  final int score;

  factory _$RelationScoreAssociatif(
          [void Function(RelationScoreAssociatifBuilder) updates]) =>
      (new RelationScoreAssociatifBuilder()..update(updates)).build();

  _$RelationScoreAssociatif._({this.login, this.otherLogin, this.score})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('RelationScoreAssociatif', 'login');
    }
    if (otherLogin == null) {
      throw new BuiltValueNullFieldError(
          'RelationScoreAssociatif', 'otherLogin');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('RelationScoreAssociatif', 'score');
    }
  }

  @override
  RelationScoreAssociatif rebuild(
          void Function(RelationScoreAssociatifBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelationScoreAssociatifBuilder toBuilder() =>
      new RelationScoreAssociatifBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelationScoreAssociatif &&
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
    return (newBuiltValueToStringHelper('RelationScoreAssociatif')
          ..add('login', login)
          ..add('otherLogin', otherLogin)
          ..add('score', score))
        .toString();
  }
}

class RelationScoreAssociatifBuilder
    implements
        Builder<RelationScoreAssociatif, RelationScoreAssociatifBuilder> {
  _$RelationScoreAssociatif _$v;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  RelationScoreAssociatifBuilder();

  RelationScoreAssociatifBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login;
      _otherLogin = _$v.otherLogin;
      _score = _$v.score;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelationScoreAssociatif other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RelationScoreAssociatif;
  }

  @override
  void update(void Function(RelationScoreAssociatifBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RelationScoreAssociatif build() {
    final _$result = _$v ??
        new _$RelationScoreAssociatif._(
            login: login, otherLogin: otherLogin, score: score);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
