import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';
import 'package:tinter_backend/models/shared/relation_status.dart';

part 'relation_status_binome_pair.g.dart';

abstract class RelationStatusBinomePair implements RelationStatus, Built<RelationStatusBinomePair, RelationStatusBinomePairBuilder> {
  @nullable
  int get binomePairId;

  int get otherBinomePairId;

  EnumRelationStatusBinomePair get status;


  RelationStatusBinomePair._();
  factory RelationStatusBinomePair([void Function(RelationStatusBinomePairBuilder) updates]) = _$RelationStatusBinomePair;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationStatusBinomePair.serializer, this);
  }

  static RelationStatusBinomePair fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationStatusBinomePair.serializer, json);
  }

  static Serializer<RelationStatusBinomePair> get serializer => _$relationStatusBinomePairSerializer;
}

class EnumRelationStatusBinomePair extends EnumClass {
  static const EnumRelationStatusBinomePair none = _$none;
  static const EnumRelationStatusBinomePair ignored = _$ignored;
  static const EnumRelationStatusBinomePair liked = _$liked;
  static const EnumRelationStatusBinomePair askedBinomePairMatch = _$askedBinomePairMatch;
  static const EnumRelationStatusBinomePair acceptedBinomePairMatch = _$acceptedBinomePairMatch;
  static const EnumRelationStatusBinomePair refusedBinomePairMatch = _$refusedBinomePairMatch;


  const EnumRelationStatusBinomePair._(String name) : super(name);

  static BuiltSet<EnumRelationStatusBinomePair> get values => _$enumRelationStatusBinomePairValues;
  static EnumRelationStatusBinomePair valueOf(String name) => _$enumRelationStatusBinomePairValueOf(name);

  String serialize() {
    return serializers.serializeWith(EnumRelationStatusBinomePair.serializer, this);
  }

  static EnumRelationStatusBinomePair deserialize(String string) {
    return serializers.deserializeWith(EnumRelationStatusBinomePair.serializer, string);
  }

  static Serializer<EnumRelationStatusBinomePair> get serializer => _$enumRelationStatusBinomePairSerializer;
}
