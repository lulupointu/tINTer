
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tinterapp/Logic/models/association.dart';

part 'student.g.dart';

@JsonSerializable(explicitToJson: true)
class Student extends Equatable {
  final String _name;
  final String _surname;
  final String _email;
  final bool _primoEntrant;
  final List<Association> _associations;
  final double _attiranceVieAsso;
  final double _feteOuCours;
  final double _aideOuSortir;
  final double _organisationEvenements;
  final List<String> _goutsMusicaux;

  Student(name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
      aideOuSortir, organisationEvenements, goutsMusicaux)
      : assert(name != null),
        assert(surname != null),
        assert(primoEntrant != null),
        assert(associations != null),
        assert(attiranceVieAsso != null),
        assert(feteOuCours != null),
        assert(aideOuSortir != null),
        assert(organisationEvenements != null),
        assert(goutsMusicaux != null),
        _name = name,
        _surname = surname,
        _email = email,
        _primoEntrant = primoEntrant,
        _associations = associations,
        _attiranceVieAsso = attiranceVieAsso,
        _feteOuCours = feteOuCours,
        _aideOuSortir = aideOuSortir,
        _organisationEvenements = organisationEvenements,
        _goutsMusicaux = goutsMusicaux;

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  // Define all getter for the user info
  String get name => _name;

  String get surname => _surname;

  String get email => _email;

  bool get primoEntrant => _primoEntrant;

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
