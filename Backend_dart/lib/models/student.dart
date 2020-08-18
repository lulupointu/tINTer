import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tinter_backend/models/association.dart';
import 'package:tinter_backend/models/static_student.dart';

part 'student.g.dart';

@JsonSerializable(explicitToJson: true)
class Student extends StaticStudent {
  final List<Association> _associations;
  final double _attiranceVieAsso;
  final double _feteOuCours;
  final double _aideOuSortir;
  final double _organisationEvenements;
  final List<String> _goutsMusicaux;

  Student({
    @required String login,
    @required String name,
    @required String surname,
    @required String email,
    @required bool primoEntrant,
    @required List<dynamic> associations,
    @required double attiranceVieAsso,
    @required double feteOuCours,
    @required double aideOuSortir,
    @required double organisationEvenements,
    @required List<dynamic> goutsMusicaux,
  })  : assert(attiranceVieAsso != null),
        assert(feteOuCours != null),
        assert(aideOuSortir != null),
        assert(organisationEvenements != null),
        _associations = associations
            ?.map((var association) =>
                (association is Association) ? association : Association.fromJson(association))
            ?.toList() ?? List<Association>(),
        _attiranceVieAsso = attiranceVieAsso,
        _feteOuCours = feteOuCours,
        _aideOuSortir = aideOuSortir,
        _organisationEvenements = organisationEvenements,
        _goutsMusicaux =
            goutsMusicaux?.map((dynamic goutMusical) => goutMusical.toString())?.toList() ?? List<String>(),
        super(
          login: login,
          name: name,
          surname: surname,
          email: email,
          primoEntrant: primoEntrant,
        );

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  // Define all getter for the user info
  List<Association> get associations => _associations;

  double get attiranceVieAsso => _attiranceVieAsso;

  double get feteOuCours => _feteOuCours;

  double get aideOuSortir => _aideOuSortir;

  double get organisationEvenements => _organisationEvenements;

  List<String> get goutsMusicaux => _goutsMusicaux;


  bool isAnyAttributeNull() {
    return props.map((Object prop) => prop == null).contains(true);
  }

  @override
  List<Object> get props => [
        name,
        surname,
        email,
        primoEntrant,
        associations,
        attiranceVieAsso,
        feteOuCours,
        aideOuSortir,
        organisationEvenements,
        goutsMusicaux
      ];
}
