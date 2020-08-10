import 'package:json_annotation/json_annotation.dart';

part 'association.g.dart';

@JsonSerializable(explicitToJson: true)
class Association {
  final String name;
  final String description;
  final String logoUrl;

  Association({this.name, this.description, this.logoUrl});

  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationToJson(this);

  String toString() => '(Association) name: $name, description: $description, logoUrl: $logoUrl';
}

final List<Association> allAssociations = [
  Association(
    name: 'test1',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/1',
  ),
  Association(
    name: 'test2',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/2',
  ),
  Association(
    name: 'test3',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/3',
  ),
  Association(
    name: 'test4',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/4',
  ),
  Association(
    name: 'test5',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/5',
  ),
  Association(
    name: 'test6',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/6',
  ),
  Association(
    name: 'test7',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/7',
  ),
  Association(
    name: 'test8',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/8',
  ),
  Association(
    name: 'test9',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/9',
  ),
  Association(
    name: 'test10',
    description: 'Ceci est la première association, elle est vraiment nice viendez tous ici, on s\'amuse comme des fous.',
    logoUrl: 'none/10',
  ),
];
