import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/associatif/user_associatif.dart';
import 'package:tinter_backend/models/scolaire/user_scolaire.dart';

part 'relation_score_scolaire.g.dart';

@JsonSerializable(explicitToJson: true)
class RelationScoreScolaire extends Equatable {
  final String login;
  final String otherLogin;
  final int score;

  const RelationScoreScolaire({
    @required this.login,
    @required this.otherLogin,
    @required this.score,
  }) : assert(score >= 0 && score <= 100);

  factory RelationScoreScolaire.fromJson(Map<String, dynamic> json) => _$RelationScoreScolaireFromJson(json);

  Map<String, dynamic> toJson() => _$RelationScoreScolaireToJson(this);

  @override
  List<Object> get props => [login, otherLogin, score];

  static Map<String, RelationScoreScolaire> getScoreBetweenMultiple(BuildUserScolaire user, List<UserAssociatif> otherUsers,
      int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
    return {
      for (UserAssociatif otherUser in otherUsers)
        otherUser.login: RelationScoreScolaire.getScoreBetween(
            user, otherUser, numberMaxOfAssociations, numberMaxOfGoutsMusicaux)
    };
  }

  static RelationScoreScolaire getScoreBetween(
      BuildUserScolaire user, UserAssociatif otherUser, int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
    return RelationScoreScolaire(
        login: user.login,
        otherLogin: otherUser.login,
//        score: ((1 -
//                    (getNormalizedScoreBetweenLists(user.associations.toList(), otherUser.associations.toList(),
//                                numberMaxOfAssociations) +
//                            (user.attiranceVieAsso - otherUser.attiranceVieAsso).abs() +
//                            (user.feteOuCours - otherUser.feteOuCours).abs() +
//                            (user.aideOuSortir - otherUser.aideOuSortir).abs() +
//                            (user.organisationEvenements - otherUser.organisationEvenements)
//                                .abs() +
//                            getNormalizedScoreBetweenLists(user.goutsMusicaux.toList(),
//                                otherUser.goutsMusicaux.toList(), numberMaxOfGoutsMusicaux)) /
//                        6) *
//                100)
//            .floor()
            );
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
