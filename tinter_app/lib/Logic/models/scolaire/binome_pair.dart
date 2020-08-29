import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic//models/associatif/association.dart';
import 'package:tinterapp/Logic//models/serializers.dart';
import 'package:tinterapp/Logic//models/shared/user.dart';

part 'binome_pair.g.dart';

abstract class BinomePair extends Object {
  int get binomePairId;

  // We store basic info from both user of the binome
  // The 'other' is attributed so that login < otherLogin.
  String get login;

  String get name;

  String get surname;

  String get email;

  String get otherLogin;

  String get otherName;

  String get otherSurname;

  String get otherEmail;

  // All other attribute are an union or intersection of the
  // two users composing the binome
  BuiltList<Association> get associations;

  LieuDeVie get lieuDeVie;

  double get groupeOuSeul;

  BuiltList<HoraireDeTravail> get horairesDeTravail;

  double get enligneOuNon;

  BuiltList<String> get matieresPreferees;
}

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
