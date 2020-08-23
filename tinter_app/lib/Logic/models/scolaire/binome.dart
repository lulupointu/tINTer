import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/models/associatif/user_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/user_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/static_student.dart';

part 'binome.g.dart';

enum BinomeStatus {
  heIgnoredYou,
  ignored,
  none,
  liked,
  matched,
  youAskedBinome,
  heAskedBinome,
  binomeAccepted,
  binomeHeRefused,
  binomeYouRefused,
}

@JsonSerializable(explicitToJson: true)
@immutable
class Binome extends UserScolaire {
  final BinomeStatus _status;
  final int _score;

  Binome({
    @required String login,
    @required String name,
    @required String surname,
    @required String email,
    @required TSPYear year,
    @required int score,
    @required BinomeStatus status,
    @required List<dynamic> associations,
    @required double groupeOuSeul,
    @required LieuDeVie lieuDeVie,
    @required List<HoraireDeTravail> horairesDeTravail,
    @required OutilDeTravail enligneOuNon,
    @required List<String> matieresPreferees,
    String profilePicturePath,
  })  : assert(score >= 0, score <= 100),
        assert(status != null),
        _status = (status is String)
            ? BinomeStatus.values
                .firstWhere((binomeStatus) => binomeStatus.toString() == 'BinomeStatus.$status')
            : status,
        _score = score,
        super(
      login: login,
       name: name,
       surname: surname,
      email: email,
       year: year,
       associations: associations,
       groupeOuSeul: groupeOuSeul,
       lieuDeVie: lieuDeVie,
       horairesDeTravail: horairesDeTravail,
       enligneOuNon: enligneOuNon,
       matieresPreferees: matieresPreferees,
        );

  factory Binome.fromJson(Map<String, dynamic> json) => _$BinomeFromJson(json);

  Map<String, dynamic> toJson() => _$BinomeToJson(this);

  // Define all getter for the binome info
  BinomeStatus get status => _status;

  int get score => _score;

  @override
  List<Object> get props => [
        ...super.props,
        status,
        score,
      ];

  @override
  String toString() => this.login;
}
