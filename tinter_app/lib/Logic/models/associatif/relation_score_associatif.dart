import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';

part 'relation_score_associatif.g.dart';

abstract class RelationScoreAssociatif
    implements Built<RelationScoreAssociatif, RelationScoreAssociatifBuilder> {
  String get login;

  String get otherLogin;

  int get score;

  RelationScoreAssociatif._();

  factory RelationScoreAssociatif([void Function(RelationScoreAssociatifBuilder) updates]) =
      _$RelationScoreAssociatif;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationScoreAssociatif.serializer, this);
  }

  static RelationScoreAssociatif fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationScoreAssociatif.serializer, json);
  }

  static Serializer<RelationScoreAssociatif> get serializer =>
      _$relationScoreAssociatifSerializer;

  static Map<String, RelationScoreAssociatif> getScoreBetweenMultiple(
      BuildUser user,
      List<BuildUser> otherUsers,
      int numberMaxOfAssociations,
      int numberMaxOfGoutsMusicaux) {
    return {
      for (BuildUser otherUser in otherUsers)
        otherUser.login: RelationScoreAssociatif.getScoreBetween(
            user, otherUser, numberMaxOfAssociations, numberMaxOfGoutsMusicaux)
    };
  }

  static RelationScoreAssociatif getScoreBetween(
      BuildUser user,
      BuildUser otherUser,
      int numberMaxOfAssociations,
      int numberMaxOfGoutsMusicaux) {
    return RelationScoreAssociatif((r) => r
      ..login = user.login
      ..otherLogin = otherUser.login
      ..score = ((1 -
                  (getNormalizedScoreBetweenLists(user.associations.toList(),
                              otherUser.associations.toList(), numberMaxOfAssociations) +
                          (user.attiranceVieAsso - otherUser.attiranceVieAsso).abs() +
                          (user.feteOuCours - otherUser.feteOuCours).abs() +
                          (user.aideOuSortir - otherUser.aideOuSortir).abs() +
                          (user.organisationEvenements - otherUser.organisationEvenements)
                              .abs() +
                          getNormalizedScoreBetweenLists(user.goutsMusicaux.toList(),
                              otherUser.goutsMusicaux.toList(), numberMaxOfGoutsMusicaux)) /
                      6) *
              100)
          .floor());
  }

  static double getNormalizedScoreBetweenLists(List list, List otherList, int maxLengthList) {
    final int numberOfCommonAssociations =
        list.fold(0, (value, element) => otherList.contains(element) ? 1 : 0);
    final int numberOfDifferentAssociations = (list.length - numberOfCommonAssociations) +
        (otherList.length - numberOfCommonAssociations);
    final int numberOfAbsentAssociations =
        maxLengthList - (numberOfCommonAssociations + numberOfDifferentAssociations);

    return (numberOfDifferentAssociations + 0.5 * numberOfAbsentAssociations) / maxLengthList;
  }
}

//@JsonSerializable(explicitToJson: true)
//class RelationScoreAssociatif extends Equatable {
//  final String login;
//  final String otherLogin;
//  final int score;
//
//  const RelationScoreAssociatif({
//    @required this.login,
//    @required this.otherLogin,
//    @required this.score,
//  }) : assert(score >= 0 && score <= 100);
//
//  factory RelationScoreAssociatif.fromJson(Map<String, dynamic> json) => _$RelationScoreAssociatifFromJson(json);
//
//  Map<String, dynamic> toJson() => _$RelationScoreAssociatifToJson(this);
//
//  @override
//  List<Object> get props => [login, otherLogin, score];
//
//  static Map<String, RelationScoreAssociatif> getScoreBetweenMultiple(BuildUser user, List<BuildUser> otherUsers,
//      int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
//    return {
//      for (BuildUser otherUser in otherUsers)
//        otherUser.login: RelationScoreAssociatif.getScoreBetween(
//            user, otherUser, numberMaxOfAssociations, numberMaxOfGoutsMusicaux)
//    };
//  }
//
//  static RelationScoreAssociatif getScoreBetween(
//      BuildUser user, BuildUser otherUser, int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
//    return RelationScoreAssociatif(
//        login: user.login,
//        otherLogin: otherUser.login,
//        score: ((1 -
//                    (getNormalizedScoreBetweenLists(user.associations.toList(), otherUser.associations.toList(),
//                                numberMaxOfAssociations) +
//                            (user.attiranceVieAsso - otherUser.attiranceVieAsso).abs() +
//                            (user.feteOuCours - otherUser.feteOuCours).abs() +
//                            (user.aideOuSortir - otherUser.aideOuSortir).abs() +
//                            (user.organisationEvenements - otherUser.organisationEvenements)
//                                .abs() +
//                            getNormalizedScoreBetweenLists(user.goutsMusicaux,
//                                otherUser.goutsMusicaux, numberMaxOfGoutsMusicaux)) /
//                        6) *
//                100)
//            .floor());
//  }
//
//  static double getNormalizedScoreBetweenLists(List list, List otherList, int maxLengthList) {
//    final int numberOfCommonAssociations =
//        list.fold(0, (value, element) => otherList.contains(element) ? 1 : 0);
//    final int numberOfDifferentAssociations = (list.length - numberOfCommonAssociations) +
//        (otherList.length - numberOfCommonAssociations);
//    final int numberOfAbsentAssociations =
//        maxLengthList - (numberOfCommonAssociations + numberOfDifferentAssociations);
//
//    return (numberOfDifferentAssociations + 0.5 * numberOfAbsentAssociations) / maxLengthList;
//  }
//}
