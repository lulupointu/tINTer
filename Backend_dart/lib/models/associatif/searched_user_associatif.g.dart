// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searched_user_associatif.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SearchedUserAssociatif> _$searchedUserAssociatifSerializer =
    new _$SearchedUserAssociatifSerializer();

class _$SearchedUserAssociatifSerializer
    implements StructuredSerializer<SearchedUserAssociatif> {
  @override
  final Iterable<Type> types = const [
    SearchedUserAssociatif,
    _$SearchedUserAssociatif
  ];
  @override
  final String wireName = 'SearchedUserAssociatif';

  @override
  Iterable<Object> serialize(
      Serializers serializers, SearchedUserAssociatif object,
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
  SearchedUserAssociatif deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SearchedUserAssociatifBuilder();

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

class _$SearchedUserAssociatif extends SearchedUserAssociatif {
  @override
  final String login;
  @override
  final String name;
  @override
  final String surname;
  @override
  final bool liked;

  factory _$SearchedUserAssociatif(
          [void Function(SearchedUserAssociatifBuilder) updates]) =>
      (new SearchedUserAssociatifBuilder()..update(updates)).build();

  _$SearchedUserAssociatif._({this.login, this.name, this.surname, this.liked})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        login, 'SearchedUserAssociatif', 'login');
    BuiltValueNullFieldError.checkNotNull(
        name, 'SearchedUserAssociatif', 'name');
    BuiltValueNullFieldError.checkNotNull(
        surname, 'SearchedUserAssociatif', 'surname');
    BuiltValueNullFieldError.checkNotNull(
        liked, 'SearchedUserAssociatif', 'liked');
  }

  @override
  SearchedUserAssociatif rebuild(
          void Function(SearchedUserAssociatifBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchedUserAssociatifBuilder toBuilder() =>
      new SearchedUserAssociatifBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchedUserAssociatif &&
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
    return (newBuiltValueToStringHelper('SearchedUserAssociatif')
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('liked', liked))
        .toString();
  }
}

class SearchedUserAssociatifBuilder
    implements Builder<SearchedUserAssociatif, SearchedUserAssociatifBuilder> {
  _$SearchedUserAssociatif _$v;

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

  SearchedUserAssociatifBuilder();

  SearchedUserAssociatifBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _login = $v.login;
      _name = $v.name;
      _surname = $v.surname;
      _liked = $v.liked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchedUserAssociatif other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchedUserAssociatif;
  }

  @override
  void update(void Function(SearchedUserAssociatifBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SearchedUserAssociatif build() {
    final _$result = _$v ??
        new _$SearchedUserAssociatif._(
            login: BuiltValueNullFieldError.checkNotNull(
                login, 'SearchedUserAssociatif', 'login'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, 'SearchedUserAssociatif', 'name'),
            surname: BuiltValueNullFieldError.checkNotNull(
                surname, 'SearchedUserAssociatif', 'surname'),
            liked: BuiltValueNullFieldError.checkNotNull(
                liked, 'SearchedUserAssociatif', 'liked'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
