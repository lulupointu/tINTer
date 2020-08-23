// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_user_scolaire.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SearchedUserScolaire> _$searchedUserScolaireSerializer =
    new _$SearchedUserScolaireSerializer();

class _$SearchedUserScolaireSerializer
    implements StructuredSerializer<SearchedUserScolaire> {
  @override
  final Iterable<Type> types = const [
    SearchedUserScolaire,
    _$SearchedUserScolaire
  ];
  @override
  final String wireName = 'SearchedUserScolaire';

  @override
  Iterable<Object> serialize(
      Serializers serializers, SearchedUserScolaire object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'surname',
      serializers.serialize(object.surname,
          specifiedType: const FullType(String)),
      'liked',
      serializers.serialize(object.liked, specifiedType: const FullType(bool)),
    ];

    return result;
  }

  @override
  SearchedUserScolaire deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchedUserScolaireBuilder();

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
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'surname':
          result.surname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'liked':
          result.liked = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
      }
    }

    return result.build();
  }
}

class _$SearchedUserScolaire extends SearchedUserScolaire {
  @override
  final String login;
  @override
  final String name;
  @override
  final String surname;
  @override
  final bool liked;

  factory _$SearchedUserScolaire(
          [void Function(SearchedUserScolaireBuilder) updates]) =>
      (new SearchedUserScolaireBuilder()..update(updates)).build();

  _$SearchedUserScolaire._({this.login, this.name, this.surname, this.liked})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('SearchedUserScolaire', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('SearchedUserScolaire', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('SearchedUserScolaire', 'surname');
    }
    if (liked == null) {
      throw new BuiltValueNullFieldError('SearchedUserScolaire', 'liked');
    }
  }

  @override
  SearchedUserScolaire rebuild(
          void Function(SearchedUserScolaireBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchedUserScolaireBuilder toBuilder() =>
      new SearchedUserScolaireBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchedUserScolaire &&
        login == other.login &&
        name == other.name &&
        surname == other.surname &&
        liked == other.liked;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, login.hashCode), name.hashCode), surname.hashCode),
        liked.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SearchedUserScolaire')
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('liked', liked))
        .toString();
  }
}

class SearchedUserScolaireBuilder
    implements Builder<SearchedUserScolaire, SearchedUserScolaireBuilder> {
  _$SearchedUserScolaire _$v;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _surname;
  String get surname => _$this._surname;
  set surname(String surname) => _$this._surname = surname;

  bool _liked;
  bool get liked => _$this._liked;
  set liked(bool liked) => _$this._liked = liked;

  SearchedUserScolaireBuilder();

  SearchedUserScolaireBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login;
      _name = _$v.name;
      _surname = _$v.surname;
      _liked = _$v.liked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchedUserScolaire other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SearchedUserScolaire;
  }

  @override
  void update(void Function(SearchedUserScolaireBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SearchedUserScolaire build() {
    final _$result = _$v ??
        new _$SearchedUserScolaire._(
            login: login, name: name, surname: surname, liked: liked);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
