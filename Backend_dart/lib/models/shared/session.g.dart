// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Session> _$sessionSerializer = new _$SessionSerializer();

class _$SessionSerializer implements StructuredSerializer<Session> {
  @override
  final Iterable<Type> types = const [Session, _$Session];
  @override
  final String wireName = 'Session';

  @override
  Iterable<Object> serialize(Serializers serializers, Session object,
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
  Session deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SessionBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
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

class _$Session extends Session {
  @override
  final String token;
  @override
  final String login;
  @override
  final DateTime creationDate;
  @override
  final bool isValid;

  factory _$Session([void Function(SessionBuilder) updates]) =>
      (new SessionBuilder()..update(updates)).build();

  _$Session._({this.token, this.login, this.creationDate, this.isValid})
      : super._() {
    if (token == null) {
      throw new BuiltValueNullFieldError('Session', 'token');
    }
    if (login == null) {
      throw new BuiltValueNullFieldError('Session', 'login');
    }
    if (creationDate == null) {
      throw new BuiltValueNullFieldError('Session', 'creationDate');
    }
    if (isValid == null) {
      throw new BuiltValueNullFieldError('Session', 'isValid');
    }
  }

  @override
  Session rebuild(void Function(SessionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SessionBuilder toBuilder() => new SessionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Session &&
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
    return (newBuiltValueToStringHelper('Session')
          ..add('token', token)
          ..add('login', login)
          ..add('creationDate', creationDate)
          ..add('isValid', isValid))
        .toString();
  }
}

class SessionBuilder implements Builder<Session, SessionBuilder> {
  _$Session _$v;

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

  SessionBuilder();

  SessionBuilder get _$this {
    if (_$v != null) {
      _token = _$v.token;
      _login = _$v.login;
      _creationDate = _$v.creationDate;
      _isValid = _$v.isValid;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Session other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Session;
  }

  @override
  void update(void Function(SessionBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Session build() {
    final _$result = _$v ??
        new _$Session._(
            token: token,
            login: login,
            creationDate: creationDate,
            isValid: isValid);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new