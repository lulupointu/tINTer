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
      'nameA',
      serializers.serialize(object.nameA,
          specifiedType: const FullType(String)),
      'surnameA',
      serializers.serialize(object.surnameA,
          specifiedType: const FullType(String)),
      'nameB',
      serializers.serialize(object.nameB,
          specifiedType: const FullType(String)),
      'surnameB',
      serializers.serialize(object.surnameB,
          specifiedType: const FullType(String)),
      'liked',
      serializers.serialize(object.liked, specifiedType: const FullType(bool)),
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
      final dynamic value = iterator.current;
      switch (key) {
        case 'binomePairId':
          result.binomePairId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'nameA':
          result.nameA = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'surnameA':
          result.surnameA = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'nameB':
          result.nameB = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'surnameB':
          result.surnameB = serializers.deserialize(value,
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

class _$SearchedBinomePair extends SearchedBinomePair {
  @override
  final int binomePairId;
  @override
  final String nameA;
  @override
  final String surnameA;
  @override
  final String nameB;
  @override
  final String surnameB;
  @override
  final bool liked;

  factory _$SearchedBinomePair(
          [void Function(SearchedBinomePairBuilder) updates]) =>
      (new SearchedBinomePairBuilder()..update(updates)).build();

  _$SearchedBinomePair._(
      {this.binomePairId,
      this.nameA,
      this.surnameA,
      this.nameB,
      this.surnameB,
      this.liked})
      : super._() {
    if (binomePairId == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'binomePairId');
    }
    if (nameA == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'nameA');
    }
    if (surnameA == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'surnameA');
    }
    if (nameB == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'nameB');
    }
    if (surnameB == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'surnameB');
    }
    if (liked == null) {
      throw new BuiltValueNullFieldError('SearchedBinomePair', 'liked');
    }
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
        nameA == other.nameA &&
        surnameA == other.surnameA &&
        nameB == other.nameB &&
        surnameB == other.surnameB &&
        liked == other.liked;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc($jc($jc(0, binomePairId.hashCode), nameA.hashCode),
                    surnameA.hashCode),
                nameB.hashCode),
            surnameB.hashCode),
        liked.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SearchedBinomePair')
          ..add('binomePairId', binomePairId)
          ..add('nameA', nameA)
          ..add('surnameA', surnameA)
          ..add('nameB', nameB)
          ..add('surnameB', surnameB)
          ..add('liked', liked))
        .toString();
  }
}

class SearchedBinomePairBuilder
    implements Builder<SearchedBinomePair, SearchedBinomePairBuilder> {
  _$SearchedBinomePair _$v;

  int _binomePairId;
  int get binomePairId => _$this._binomePairId;
  set binomePairId(int binomePairId) => _$this._binomePairId = binomePairId;

  String _nameA;
  String get nameA => _$this._nameA;
  set nameA(String nameA) => _$this._nameA = nameA;

  String _surnameA;
  String get surnameA => _$this._surnameA;
  set surnameA(String surnameA) => _$this._surnameA = surnameA;

  String _nameB;
  String get nameB => _$this._nameB;
  set nameB(String nameB) => _$this._nameB = nameB;

  String _surnameB;
  String get surnameB => _$this._surnameB;
  set surnameB(String surnameB) => _$this._surnameB = surnameB;

  bool _liked;
  bool get liked => _$this._liked;
  set liked(bool liked) => _$this._liked = liked;

  SearchedBinomePairBuilder();

  SearchedBinomePairBuilder get _$this {
    if (_$v != null) {
      _binomePairId = _$v.binomePairId;
      _nameA = _$v.nameA;
      _surnameA = _$v.surnameA;
      _nameB = _$v.nameB;
      _surnameB = _$v.surnameB;
      _liked = _$v.liked;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchedBinomePair other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
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
            binomePairId: binomePairId,
            nameA: nameA,
            surnameA: surnameA,
            nameB: nameB,
            surnameB: surnameB,
            liked: liked);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new