import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'searched_binome_pair.g.dart';

abstract class SearchedBinomePair implements Built<SearchedBinomePair, SearchedBinomePairBuilder> {

  int get binomePairId;

  String get login;

  String get name;

  String get surname;

  String get otherLogin;

  String get otherName;

  String get otherSurname;

  bool get liked;

  int get score;

  SearchedBinomePair._();
  factory SearchedBinomePair([void Function(SearchedBinomePairBuilder) updates]) = _$SearchedBinomePair;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(SearchedBinomePair.serializer, this);
  }

  static SearchedBinomePair fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(SearchedBinomePair.serializer, json);
  }

  static Serializer<SearchedBinomePair> get serializer => _$searchedBinomePairSerializer;
}
