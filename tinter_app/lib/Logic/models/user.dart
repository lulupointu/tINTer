import 'package:json_annotation/json_annotation.dart';
import 'package:tinterapp/Logic/models/student.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User extends Student {
  User(name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
      aideOuSortir, organisationEvenements, goutsMusicaux)
      : super(name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
            aideOuSortir, organisationEvenements, goutsMusicaux);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}
