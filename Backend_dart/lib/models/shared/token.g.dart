// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Token> _$tokenSerializer = new _$TokenSerializer();

class _$TokenSerializer implements StructuredSerializer<Token> {
  @override
  final Iterable<Type> types = const [Token, _$Token];
  @override
  final String wireName = 'Token';

  @override
  Iterable<Object> serialize(Serializers serializers, Token object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'token',
      serializers.serialize(object.token,
          specifiedType: const FullType(String)),
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'creationDate',
      serializers.serialize(object.creationDate,
          specifiedType: const FullType(DateTime)),
      'isValid',
      serializers.serialize(object.isValid,
          specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  Token deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TokenBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'creationDate':
          result.creationDate = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime;
          break;
        case 'isValid':
          result.isValid = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$Token extends Token {
  @override
  final String token;
  @override
  final String login;
  @override
  final DateTime creationDate;
  @override
  final bool isValid;

  factory _$Token([void Function(TokenBuilder) updates]) =>
      (new TokenBuilder()..update(updates)).build();

  _$Token._({this.token, this.login, this.creationDate, this.isValid})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(token, 'Token', 'token');
    BuiltValueNullFieldError.checkNotNull(login, 'Token', 'login');
    BuiltValueNullFieldError.checkNotNull(
        creationDate, 'Token', 'creationDate');
    BuiltValueNullFieldError.checkNotNull(isValid, 'Token', 'isValid');
  }

  @override
  Token rebuild(void Function(TokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TokenBuilder toBuilder() => new TokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Token &&
        token == other.token &&
        login == other.login &&
        creationDate == other.creationDate &&
        isValid == other.isValid;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, token.hashCode), login.hashCode), creationDate.hashCode),
        isValid.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Token')
          ..add('token', token)
          ..add('login', login)
          ..add('creationDate', creationDate)
          ..add('isValid', isValid))
        .toString();
  }
}

class TokenBuilder implements Builder<Token, TokenBuilder> {
  _$Token _$v;

  String _token;
  String get token => _$this._token;
  set token(String token) => _$this._token = token;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  DateTime _creationDate;
  DateTime get creationDate => _$this._creationDate;
  set creationDate(DateTime creationDate) =>
      _$this._creationDate = creationDate;

  bool _isValid;
  bool get isValid => _$this._isValid;
  set isValid(bool isValid) => _$this._isValid = isValid;

  TokenBuilder();

  TokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _login = $v.login;
      _creationDate = $v.creationDate;
      _isValid = $v.isValid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Token other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Token;
  }

  @override
  void update(void Function(TokenBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Token build() {
    final _$result = _$v ??
        new _$Token._(
            token:
                BuiltValueNullFieldError.checkNotNull(token, 'Token', 'token'),
            login:
                BuiltValueNullFieldError.checkNotNull(login, 'Token', 'login'),
            creationDate: BuiltValueNullFieldError.checkNotNull(
                creationDate, 'Token', 'creationDate'),
            isValid: BuiltValueNullFieldError.checkNotNull(
                isValid, 'Token', 'isValid'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
