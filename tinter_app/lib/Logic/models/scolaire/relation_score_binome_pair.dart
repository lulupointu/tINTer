import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'relation_score_binome_pair.g.dart';

abstract class RelationScoreBinomePair
    implements Built<RelationScoreBinomePair, RelationScoreBinomePairBuilder> {
  // otherBinomePairId is defined so that binomePairId < otherBinomePairId
  int get binomePairId;

  int get otherBinomePairId;

  int get score;

  RelationScoreBinomePair._();

  factory RelationScoreBinomePair([void Function(RelationScoreBinomePairBuilder) updates]) =
      _$RelationScoreBinomePair;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationScoreBinomePair.serializer, this);
  }

  static RelationScoreBinomePair fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationScoreBinomePair.serializer, json);
  }

  static Serializer<RelationScoreBinomePair> get serializer =>
      _$relationScoreBinomePairSerializer;
}
