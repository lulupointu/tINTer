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
    @required List<String> goutsMusicaux,
  })  : assert(associations != null),
        assert(attiranceVieAsso != null),
        assert(feteOuCours != null),
        assert(aideOuSortir != null),
        assert(organisationEvenements != null),
        assert(goutsMusicaux != null),
        _associations = associations
            .map((var association) =>
                (association is Association) ? association : Association.fromJson(association))
            .toList(),
        _attiranceVieAsso = attiranceVieAsso,
        _feteOuCours = feteOuCours,
        _aideOuSortir = aideOuSortir,
        _organisationEvenements = organisationEvenements,
        _goutsMusicaux = goutsMusicaux,
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

  // Define all setter for the user info (expect name and surname
  // which can't be changed)
  // All information should be changed and saved to the server
  // via the interface.
//  set associations(Associations newAssociations) {
//    Interface.setAssociations(newAssociations);
//    _associations = newAssociations;
//  }
//  set attiranceVieAsso(double newAttiranceVieAsso) {
//    Interface.setAttiranceVieAsso(newAttiranceVieAsso);
//    _attiranceVieAsso = newAttiranceVieAsso;
//  }
//  set feteOuCours(double newFeteOuCours) {
//    Interface.setFeteOuCours(newFeteOuCours);
//    _feteOuCours = newFeteOuCours;
//  }
//  set aideOuSortir(double newAideOuSortir) {
//    Interface.setAideOuSortir(newAideOuSortir);
//    _aideOuSortir = newAideOuSortir;
//  }
//  set organisationEvenements(double newOrganisationEvenements) {
//    Interface.setOrganisationEvenements(newOrganisationEvenements);
//    _organisationEvenements = newOrganisationEvenements;
//  }
//  set goutsMusicaux(GoutsMusicaux newGoutsMusicaux) {
//    Interface.setGoutsMusicaux(newGoutsMusicaux.get);
//    _goutsMusicaux = newGoutsMusicaux;
//  }

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
