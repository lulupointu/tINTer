import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

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
}
