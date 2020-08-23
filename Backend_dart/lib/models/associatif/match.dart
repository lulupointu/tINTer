import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/associatif/association.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';
import 'package:tinter_backend/models/shared/user_shared_part.dart';

part 'match.g.dart';

abstract class Match extends Object implements UserAssociatif {
  MatchStatus get status;
  int get score;
}

abstract class BuildMatch
//    with UserAssociatif
    implements Match, Built<BuildMatch, BuildMatchBuilder> {


  BuildMatch._();
  factory BuildMatch([void Function(BuildMatchBuilder) updates]) = _$BuildMatch;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildMatch.serializer, this);
  }

  static BuildMatch fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildMatch.serializer, json);
  }

  static Serializer<BuildMatch> get serializer => _$buildMatchSerializer;
}

class MatchStatus extends EnumClass {
  static const MatchStatus heIgnoredYou = _$heIgnoredYou;
  static const MatchStatus ignored = _$ignored;
  static const MatchStatus none = _$none;
  static const MatchStatus liked = _$liked;
  static const MatchStatus matched = _$matched;
  static const MatchStatus youAskedParrain = _$youAskedParrain;
  static const MatchStatus heAskedParrain = _$heAskedParrain;
  static const MatchStatus parrainAccepted = _$parrainAccepted;
  static const MatchStatus parrainHeRefused = _$parrainHeRefused;
  static const MatchStatus parrainYouRefused = _$parrainYouRefused;

  const MatchStatus._(String name) : super(name);

  static BuiltSet<MatchStatus> get values => _$matchStatusValues;
  static MatchStatus valueOf(String name) => _$matchStatusValueOf(name);

  String serialize() {
    return serializers.serializeWith(MatchStatus.serializer, this);
  }

  static MatchStatus deserialize(String string) {
    return serializers.deserializeWith(MatchStatus.serializer, string);
  }

  static Serializer<MatchStatus> get serializer => _$matchStatusSerializer;
}



//enum MatchStatus {
//  heIgnoredYou,
//  ignored,
//  none,
//  liked,
//  matched,
//  youAskedParrain,
//  heAskedParrain,
//  parrainAccepted,
//  parrainHeRefused,
//  parrainYouRefused,
//}
//
//@JsonSerializable(explicitToJson: true)
//@immutable
//class Match extends UserAssociatif {
//  final MatchStatus _status;
//  final int _score;
//
//  Match({
//    @required login,
//    @required score,
//    @required status,
//    @required primoEntrant,
//    @required associations,
//    @required attiranceVieAsso,
//    @required feteOuCours,
//    @required aideOuSortir,
//    @required organisationEvenements,
//    @required goutsMusicaux,
//    profilePicturePath,
//  })  : assert(score >= 0, score <= 100),
//        assert(status != null),
//        _status = (status is String)
//            ? MatchStatus.values
//                .firstWhere((matchStatus) => matchStatus.toString() == 'MatchStatus.$status')
//            : status,
//        _score = score,
//        super(
//          login: login,
//          primoEntrant: primoEntrant,
//          associations: associations,
//          attiranceVieAsso: attiranceVieAsso,
//          feteOuCours: feteOuCours,
//          aideOuSortir: aideOuSortir,
//          organisationEvenements: organisationEvenements,
//          goutsMusicaux: goutsMusicaux,
//          profilePicturePath: profilePicturePath,
//        );
//
//  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
//
//  Map<String, dynamic> toJson() => _$MatchToJson(this);
//
//  // Define all getter for the match info
//  MatchStatus get status => _status;
//
//  int get score => _score;
//
//  @override
//  List<Object> get props => [
//        ...super.props,
//        status,
//        score,
//      ];
//
//  @override
//  String toString() => this.login;
//}
