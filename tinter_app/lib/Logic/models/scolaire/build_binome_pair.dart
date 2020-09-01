
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';

part 'build_binome_pair.g.dart';


abstract class BuildBinomePair
    implements BinomePair, Built<BuildBinomePair, BuildBinomePairBuilder> {
  BuildBinomePair._();

  factory BuildBinomePair([void Function(BuildBinomePairBuilder) updates]) = _$BuildBinomePair;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildBinomePair.serializer, this);
  }

  static BuildBinomePair fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildBinomePair.serializer, json);
  }

  static Serializer<BuildBinomePair> get serializer => _$buildBinomePairSerializer;
}
