// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_binome_pair.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SearchedBinomePair> _$searchedBinomePairSerializer =
    new _$SearchedBinomePairSerializer();

class _$SearchedBinomePairSerializer
    implements StructuredSerializer<SearchedBinomePair> {
  @override
  final Iterable<Type> types = const [SearchedBinomePair, _$SearchedBinomePair];
  @override
  final String wireName = 'SearchedBinomePair';

  @override
  Iterable<Object> serialize(Serializers serializers, SearchedBinomePair object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'binomePairId',
      serializers.serialize(object.binomePairId,
          specifiedType: const FullType(int)),
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'surname',
      serializers.serialize(object.surname,
          specifiedType: const FullType(String)),
      'otherLogin',
      serializers.serialize(object.otherLogin,
          specifiedType: const FullType(String)),
      'otherName',
      serializers.serialize(object.otherName,
          specifiedType: const FullType(String)),
      'otherSurname',
      serializers.serialize(object.otherSurname,
          specifiedType: const FullType(String)),
      'liked',
      serializers.serialize(object.liked, specifiedType: const FullType(bool)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  SearchedBinomePair deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchedBinomePairBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'binomePairId':
          result.binomePairId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'surname':
          result.surname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherLogin':
          result.otherLogin = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherName':
          result.otherName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherSurname':
          result.otherSurname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'liked':
          result.liked = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
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

class _$SearchedBinomePair extends SearchedBinomePair {
  @override
  final int binomePairId;
  @override
  final String login;
  @override
  final String name;
  @override
  final String surname;
  @override
  final String otherLogin;
  @override
  final String otherName;
  @override
  final String otherSurname;
  @override
  final bool liked;
  @override
  final int score;

  factory _$SearchedBinomePair(
          [void Function(SearchedBinomePairBuilder) updates]) =>
      (new SearchedBinomePairBuilder()..update(updates)).build();

  _$SearchedBinomePair._(
      {this.binomePairId,
      this.login,
      this.name,
      this.surname,
      this.otherLogin,
      this.otherName,
      this.otherSurname,
      this.liked,
      this.score})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        binomePairId, 'SearchedBinomePair', 'binomePairId');
    BuiltValueNullFieldError.checkNotNull(login, 'SearchedBinomePair', 'login');
    BuiltValueNullFieldError.checkNotNull(name, 'SearchedBinomePair', 'name');
    BuiltValueNullFieldError.checkNotNull(
        surname, 'SearchedBinomePair', 'surname');
    BuiltValueNullFieldError.checkNotNull(
        otherLogin, 'SearchedBinomePair', 'otherLogin');
    BuiltValueNullFieldError.checkNotNull(
        otherName, 'SearchedBinomePair', 'otherName');
    BuiltValueNullFieldError.checkNotNull(
        otherSurname, 'SearchedBinomePair', 'otherSurname');
    BuiltValueNullFieldError.checkNotNull(liked, 'SearchedBinomePair', 'liked');
    BuiltValueNullFieldError.checkNotNull(score, 'SearchedBinomePair', 'score');
  }

  @override
  SearchedBinomePair rebuild(
          void Function(SearchedBinomePairBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchedBinomePairBuilder toBuilder() =>
      new SearchedBinomePairBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchedBinomePair &&
        binomePairId == other.binomePairId &&
        login == other.login &&
        name == other.name &&
        surname == other.surname &&
        otherLogin == other.otherLogin &&
        otherName == other.otherName &&
        otherSurname == other.otherSurname &&
        liked == other.liked &&
        score == other.score;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc($jc(0, binomePairId.hashCode),
                                    login.hashCode),
                                name.hashCode),
                            surname.hashCode),
                        otherLogin.hashCode),
                    otherName.hashCode),
                otherSurname.hashCode),
            liked.hashCode),
        score.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SearchedBinomePair')
          ..add('binomePairId', binomePairId)
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('otherLogin', otherLogin)
          ..add('otherName', otherName)
          ..add('otherSurname', otherSurname)
          ..add('liked', liked)
          ..add('score', score))
        .toString();
  }
}

class SearchedBinomePairBuilder
    implements Builder<SearchedBinomePair, SearchedBinomePairBuilder> {
  _$SearchedBinomePair _$v;

  int _binomePairId;
  int get binomePairId => _$this._binomePairId;
  set binomePairId(int binomePairId) => _$this._binomePairId = binomePairId;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _surname;
  String get surname => _$this._surname;
  set surname(String surname) => _$this._surname = surname;

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  String _otherName;
  String get otherName => _$this._otherName;
  set otherName(String otherName) => _$this._otherName = otherName;

  String _otherSurname;
  String get otherSurname => _$this._otherSurname;
  set otherSurname(String otherSurname) => _$this._otherSurname = otherSurname;

  bool _liked;
  bool get liked => _$this._liked;
  set liked(bool liked) => _$this._liked = liked;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  SearchedBinomePairBuilder();

  SearchedBinomePairBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _binomePairId = $v.binomePairId;
      _login = $v.login;
      _name = $v.name;
      _surname = $v.surname;
      _otherLogin = $v.otherLogin;
      _otherName = $v.otherName;
      _otherSurname = $v.otherSurname;
      _liked = $v.liked;
      _score = $v.score;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchedBinomePair other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchedBinomePair;
  }

  @override
  void update(void Function(SearchedBinomePairBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SearchedBinomePair build() {
    final _$result = _$v ??
        new _$SearchedBinomePair._(
            binomePairId: BuiltValueNullFieldError.checkNotNull(
                binomePairId, 'SearchedBinomePair', 'binomePairId'),
            login: BuiltValueNullFieldError.checkNotNull(
                login, 'SearchedBinomePair', 'login'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'SearchedBinomePair', 'name'),
            surname: BuiltValueNullFieldError.checkNotNull(
                surname, 'SearchedBinomePair', 'surname'),
            otherLogin: BuiltValueNullFieldError.checkNotNull(
                otherLogin, 'SearchedBinomePair', 'otherLogin'),
            otherName: BuiltValueNullFieldError.checkNotNull(
                otherName, 'SearchedBinomePair', 'otherName'),
            otherSurname: BuiltValueNullFieldError.checkNotNull(
                otherSurname, 'SearchedBinomePair', 'otherSurname'),
            liked: BuiltValueNullFieldError.checkNotNull(
                liked, 'SearchedBinomePair', 'liked'),
            score:
                BuiltValueNullFieldError.checkNotNull(score, 'SearchedBinomePair', 'score'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
