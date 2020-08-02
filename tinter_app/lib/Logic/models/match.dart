import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tinterapp/Logic/models/association.dart';

enum MatchStatus { ignored, none, like, matched, youAskedParrain, heAskedParrain, ParrainAccepted, ParrainRefused}

@immutable
class Match extends Equatable {
  final String _name;
  final String _surname;
  final MatchStatus _status;
  final List<Association> _associations;
  final double _attiranceVieAsso;
  final double _feteOuCours;
  final double _aideOuSortir;
  final double _organisationEvenements;
  final List<String> _goutsMusicaux;

  Match(name, surname, status, associations, attiranceVieAsso, feteOuCours, aideOuSortir,
      organisationEvenements, goutsMusicaux)
      : _name = name,
        _surname = surname,
        _status = status,
        _associations = associations,
        _attiranceVieAsso = attiranceVieAsso,
        _feteOuCours = feteOuCours,
        _aideOuSortir = aideOuSortir,
        _organisationEvenements = organisationEvenements,
        _goutsMusicaux = goutsMusicaux;

  Match.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _surname = json['surname'],
        _status = json['status'],
        _associations = json['associations'],
        _attiranceVieAsso = json['attiranceVieAsso'],
        _feteOuCours = json['feteOuCours'],
        _aideOuSortir = json['aideOuSortir'],
        _organisationEvenements = json['organisationEvenements'],
        _goutsMusicaux = json['goutsMusicaux'];

  // Define all getter for the match info
  String get name => _name;

  String get surname => _surname;

  MatchStatus get status => _status;

  List<Association> get associations => _associations;

  double get attiranceVieAsso => _attiranceVieAsso;

  double get feteOuCours => _feteOuCours;

  double get aideOuSortir => _aideOuSortir;

  double get organisationEvenements => _organisationEvenements;

  List<String> get goutsMusicaux => _goutsMusicaux;

  @override
  List<Object> get props => [
        name,
        surname,
        associations,
        attiranceVieAsso,
        feteOuCours,
        aideOuSortir,
        organisationEvenements,
        goutsMusicaux
      ];
}
