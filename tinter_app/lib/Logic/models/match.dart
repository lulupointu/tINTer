import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/student.dart';

part 'match.g.dart';

enum MatchStatus {
  ignored,
  none,
  liked,
  matched,
  youAskedParrain,
  heAskedParrain,
  ParrainAccepted,
  ParrainRefused
}

@JsonSerializable(explicitToJson: true)
@immutable
class Match extends Student {
  final MatchStatus _status;
  final int _score;

  Match(name, surname, email, score, status, primoEntrant, associations, attiranceVieAsso,
      feteOuCours, aideOuSortir, organisationEvenements, goutsMusicaux)
      : assert(score >= 0, score <= 100),
        assert(status != null),
        _status = status,
        _score = score,
        super(name, surname, email, primoEntrant, associations, attiranceVieAsso, feteOuCours,
            aideOuSortir, organisationEvenements, goutsMusicaux);

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
