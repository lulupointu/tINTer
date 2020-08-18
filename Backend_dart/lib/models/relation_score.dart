import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/database_interface/associations_table.dart';
import 'package:tinter_backend/database_interface/gouts_musicaux_table.dart';
import 'package:tinter_backend/models/user.dart';

part 'relation_score.g.dart';

@JsonSerializable(explicitToJson: true)
class RelationScore extends Equatable {
  final String login;
  final String otherLogin;
  final int score;

  const RelationScore({
    @required this.login,
    @required this.otherLogin,
    @required this.score,
  }) : assert(score >= 0 && score <= 100);

  factory RelationScore.fromJson(Map<String, dynamic> json) => _$RelationScoreFromJson(json);

  Map<String, dynamic> toJson() => _$RelationScoreToJson(this);

  @override
  List<Object> get props => [login, otherLogin, score];

  static Map<String, RelationScore> getScoreBetweenMultiple(User user, List<User> otherUsers,
      int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
    return {
      for (User otherUser in otherUsers)
        otherUser.login: RelationScore.getScoreBetween(
            user, otherUser, numberMaxOfAssociations, numberMaxOfGoutsMusicaux)
    };
  }

  static RelationScore getScoreBetween(
      User user, User otherUser, int numberMaxOfAssociations, int numberMaxOfGoutsMusicaux) {
    return RelationScore(
        login: user.login,
        otherLogin: otherUser.login,
        score: ((1 -
                    (getNormalizedScoreBetweenLists(user.associations, otherUser.associations,
                                numberMaxOfAssociations) +
                            (user.attiranceVieAsso - otherUser.attiranceVieAsso).abs() +
                            (user.feteOuCours - otherUser.feteOuCours).abs() +
                            (user.aideOuSortir - otherUser.aideOuSortir).abs() +
                            (user.organisationEvenements - otherUser.organisationEvenements)
                                .abs() +
                            getNormalizedScoreBetweenLists(user.goutsMusicaux,
                                otherUser.goutsMusicaux, numberMaxOfGoutsMusicaux)) /
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
