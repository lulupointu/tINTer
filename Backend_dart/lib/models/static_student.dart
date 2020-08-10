import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'static_student.g.dart';

@JsonSerializable(explicitToJson: true)

/// This is the static part of every student
/// Meaning the part they can't change.
class StaticStudent extends Equatable {
  final String _login;
  final String _name;
  final String _surname;
  final String _email;
  final bool _primoEntrant;


  StaticStudent({
    @required login,
    @required name,
    @required surname,
    @required email,
    @required primoEntrant,
  })
      : assert(login != null),
        assert(name != null),
        assert(surname != null),
        assert(primoEntrant != null),
        _login = login,
        _name = name,
        _surname = surname,
        _email = email,
        _primoEntrant = primoEntrant;

  factory StaticStudent.fromJson(Map<String, dynamic> json) => _$StaticStudentFromJson(json);

  Map<String, dynamic> toJson() => _$StaticStudentToJson(this);

  // Define all getter for the user info
  String get login => _login;

  String get name => _name;

  String get surname => _surname;

  String get email => _email;

  bool get primoEntrant => _primoEntrant;


  @override
  List<Object> get props =>
      [
        name,
        surname,
        email,
        primoEntrant,
      ];
}
