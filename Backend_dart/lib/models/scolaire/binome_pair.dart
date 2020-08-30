import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/serializers.dart';
import 'package:tinter_backend/models/shared/user.dart';

part 'binome_pair.g.dart';

abstract class BinomePair extends Object {
  @nullable
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

  @nullable
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

  static BuildBinomePair getFromUsers(BuildUser userA, BuildUser userB) {
    BuildUser user, otherUser;
    if (userA.login.compareTo(userB.login) < 0) {
      user = userA;
      otherUser = userB;
    } else {
      user = userB;
      otherUser = userA;
    }

    return BuildBinomePair((b) => b
      ..login = user.login
      ..name = user.name
      ..surname = user.surname
      ..email = user.email
      ..otherLogin = otherUser.login
      ..otherName = otherUser.name
      ..otherSurname = otherUser.surname
      ..otherEmail = otherUser.email
      ..associations = [...user.associations, ...otherUser.associations].toSet().toBuiltList().toBuilder()
      ..lieuDeVie = user.lieuDeVie == otherUser.lieuDeVie ? user.lieuDeVie : null
      ..groupeOuSeul = (user.groupeOuSeul + otherUser.groupeOuSeul)/2
      ..horairesDeTravail = user.horairesDeTravail.toSet().intersection(otherUser.horairesDeTravail.toSet()).toBuiltList().toBuilder()
      ..enligneOuNon = (user.enligneOuNon + otherUser.enligneOuNon)/2
      ..matieresPreferees = [...user.matieresPreferees, ...otherUser.matieresPreferees].toSet().toBuiltList().toBuilder()
    );
  }

}
