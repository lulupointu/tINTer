import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/student.dart';

part 'match.g.dart';

enum MatchStatus {
  heIgnoredYou,
  ignored,
  none,
  liked,
  matched,
  youAskedParrain,
  heAskedParrain,
  parrainAccepted,
  parrainHeRefused,
  parrainYouRefused,
}

@JsonSerializable(explicitToJson: true)
@immutable
class Match extends Student {
  final MatchStatus _status;
  final int _score;

  Match({
    @required login,
    @required name,
    @required surname,
    @required email,
    @required score,
    @required status,
    @required primoEntrant,
    @required associations,
    @required attiranceVieAsso,
    @required feteOuCours,
    @required aideOuSortir,
    @required organisationEvenements,
    @required goutsMusicaux,
    profilePicturePath,
  })  : assert(score >= 0, score <= 100),
        assert(status != null),
        _status = (status is String)
            ? MatchStatus.values
                .firstWhere((matchStatus) => matchStatus.toString() == 'MatchStatus.$status')
            : status,
        _score = score,
        super(
          login: login,
          name: name,
          surname: surname,
          email: email,
          primoEntrant: primoEntrant,
          associations: associations,
          attiranceVieAsso: attiranceVieAsso,
          feteOuCours: feteOuCours,
          aideOuSortir: aideOuSortir,
          organisationEvenements: organisationEvenements,
          goutsMusicaux: goutsMusicaux,
          profilePicturePath: profilePicturePath,
        );

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);

  // Define all getter for the match info
  MatchStatus get status => _status;

  int get score => _score;

  @override
  List<Object> get props => [
        ...super.props,
        status,
        score,
      ];
}
