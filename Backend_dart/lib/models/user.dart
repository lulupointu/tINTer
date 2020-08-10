import 'package:json_annotation/json_annotation.dart';
import 'package:tinter_backend/models/student.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Student {
  User({
    @required login,
    @required name,
    @required surname,
    @required email,
    @required primoEntrant,
    @required associations,
    @required attiranceVieAsso,
    @required feteOuCours,
    @required aideOuSortir,
    @required organisationEvenements,
    @required goutsMusicaux,
  }) : super(
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
        );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
