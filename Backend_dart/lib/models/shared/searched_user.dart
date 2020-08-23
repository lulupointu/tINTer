import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'searched_user.g.dart';

@JsonSerializable(explicitToJson: true)
/// This is the static part of every student
/// Meaning the part they can't change.
class SearchedUserAssociatif extends Equatable {
  final String _login;
  final String _name;
  final String _surname;
  final bool _liked;

  SearchedUserAssociatif({
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

  factory SearchedUserAssociatif.fromJson(Map<String, dynamic> json) => _$SearchedUserAssociatifFromJson(json);

  Map<String, dynamic> toJson() => _$SearchedUserAssociatifToJson(this);

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
