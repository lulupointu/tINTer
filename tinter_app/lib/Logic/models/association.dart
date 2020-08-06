import 'package:json_annotation/json_annotation.dart';

part 'association.g.dart';

@JsonSerializable(explicitToJson: true)
class Association {
  final String name;
  final String description;
  // TODO: Add logo

  Association({this.name, this.description});

  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationToJson(this);
}
