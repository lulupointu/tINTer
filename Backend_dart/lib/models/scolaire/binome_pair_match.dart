import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/serializers.dart';
import 'package:tinter_backend/models/shared/user.dart';

part 'binome_pair_match.g.dart';

abstract class BinomePairMatch extends Object implements BinomePair {
  BinomePairMatchStatus get status;
  int get score;
}

abstract class BuildBinomePairMatch implements BinomePairMatch, Built<BuildBinomePairMatch, BuildBinomePairMatchBuilder> {

  BuildBinomePairMatch._();
  factory BuildBinomePairMatch([void Function(BuildBinomePairMatchBuilder) updates]) = _$BuildBinomePairMatch;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildBinomePairMatch.serializer, this);
  }

  static BuildBinomePairMatch fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildBinomePairMatch.serializer, json);
  }

  static Serializer<BuildBinomePairMatch> get serializer => _$buildBinomePairMatchSerializer;
}


class BinomePairMatchStatus extends EnumClass {
  static const BinomePairMatchStatus heIgnoredYou = _$heIgnoredYou;
  static const BinomePairMatchStatus ignored = _$ignored;
  static const BinomePairMatchStatus none = _$none;
  static const BinomePairMatchStatus liked = _$liked;
  static const BinomePairMatchStatus matched = _$matched;
  static const BinomePairMatchStatus youAskedBinomePairMatch = _$youAskedBinomePairMatch;
  static const BinomePairMatchStatus heAskedBinomePairMatch = _$heAskedBinomePairMatch;
  static const BinomePairMatchStatus binomePairMatchAccepted = _$binomePairMatchAccepted;
  static const BinomePairMatchStatus binomePairMatchHeRefused = _$binomePairMatchHeRefused;
  static const BinomePairMatchStatus binomePairMatchYouRefused = _$binomePairMatchYouRefused;


  const BinomePairMatchStatus._(String name) : super(name);

  static BuiltSet<BinomePairMatchStatus> get values => _$binomePairMatchStatusValues;
  static BinomePairMatchStatus valueOf(String name) => _$binomePairMatchStatusValueOf(name);

  String serialize() {
    return serializers.serializeWith(BinomePairMatchStatus.serializer, this);
  }

  static BinomePairMatchStatus deserialize(String string) {
    return serializers.deserializeWith(BinomePairMatchStatus.serializer, string);
  }

  static Serializer<BinomePairMatchStatus> get serializer => _$binomePairMatchStatusSerializer;
}




