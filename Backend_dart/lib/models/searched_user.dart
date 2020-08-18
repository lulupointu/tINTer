import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'searched_user.g.dart';

@JsonSerializable(explicitToJson: true)
/// This is the static part of every student
/// Meaning the part they can't change.
class SearchedUser extends Equatable {
  final String _login;
  final String _name;
  final String _surname;
  final bool _liked;

  SearchedUser({
    @required login,
    @required name,
    @required surname,
    @required liked,
  })  : assert(login != null),
        assert(name != null),
        assert(surname != null),
        assert(liked != null),
        _login = login,
        _name = name,
        _surname = surname,
        _liked = liked;

  factory SearchedUser.fromJson(Map<String, dynamic> json) => _$SearchedUserFromJson(json);

  Map<String, dynamic> toJson() => _$SearchedUserToJson(this);

  // Define all getter for the user info
  String get login => _login;

  String get name => _name;

  String get surname => _surname;

  bool get liked => _liked;


  @override
  List<Object> get props =>
      [
        name,
        surname,
        liked
      ];
}
