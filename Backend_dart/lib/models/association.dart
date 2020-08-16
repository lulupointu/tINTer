import 'package:json_annotation/json_annotation.dart';

part 'association.g.dart';

@JsonSerializable(explicitToJson: true)
class Association {
  final String name;
  final String description;

  Association({this.name, this.description});

  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);

  Map<String, dynamic> toJson() => _$AssociationToJson(this);

  String toString() =>
      '(Association) name: $name, description: $description';
}

List<Association> allAssociations = [
  Association(
      name:"AbsINThe",
      description:"C'est l'association AbsINThe venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"AfricanIT",
      description:"C'est l'association AfricanIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Agora",
      description:"C'est l'association Agora venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"AIESEC",
      description:"C'est l'association AIESEC venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"AnimINT",
      description:"C'est l'association AnimINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Aparte",
      description:"C'est l'association Aparte venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"ASINT",
      description:"C'est l'association ASINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Asphalte",
      description:"C'est l'association Asphalte venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Band'a michel",
      description:"C'est l'association michel venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"BDA",
      description:"C'est l'association BDA venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Belly Dance",
      description:"C'est l'association Dance venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"BollyINT",
      description:"C'est l'association BollyINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"BPM",
      description:"C'est l'association BPM venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"BricolINT",
      description:"C'est l'association BricolINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Bstyle",
      description:"C'est l'association Bstyle venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"CELL",
      description:"C'est l'association CELL venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Cine",
      description:"C'est l'association Cine venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Club Zik",
      description:"C'est l'association Zik venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"CookIT",
      description:"C'est l'association CookIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Déclic",
      description:"C'est l'association Déclic venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"DolphINT",
      description:"C'est l'association DolphINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Emotys",
      description:"C'est l'association Emotys venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Epicurieux",
      description:"C'est l'association Epicurieux venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"EquIT",
      description:"C'est l'association EquIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Evryone",
      description:"C'est l'association Evryone venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"FIMTech",
      description:"C'est l'association FIMTech venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Forum",
      description:"C'est l'association Forum venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"GameINT",
      description:"C'est l'association GameINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Golf",
      description:"C'est l'association Golf venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"HackademINT",
      description:"C'est l'association HackademINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Heforshe",
      description:"C'est l'association Heforshe venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"INacT",
      description:"C'est l'association INacT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"INTech",
      description:"C'est l'association INTech venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Interlude",
      description:"C'est l'association Interlude venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Intervenir",
      description:"C'est l'association Intervenir venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"INTimes",
      description:"C'est l'association INTimes venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"INTv",
      description:"C'est l'association INTv venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"KpopIT",
      description:"C'est l'association KpopIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"KryptoSphère",
      description:"C'est l'association KryptoSphère venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"LPE",
      description:"C'est l'association LPE venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"MINeT",
      description:"C'est l'association MINeT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Moov'INT",
      description:"C'est l'association Moov'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"MuslimINT",
      description:"C'est l'association MuslimINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Nihao",
      description:"C'est l'association Nihao venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"PaintIT",
      description:"C'est l'association PaintIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Pomp'int",
      description:"C'est l'association Pomp'int venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Promo2Tel",
      description:"C'est l'association Promo2Tel venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Rock'INT",
      description:"C'est l'association Rock'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Saint Espr'IT",
      description:"C'est l'association Espr'IT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"SalsaINT",
      description:"C'est l'association SalsaINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Shalom",
      description:"C'est l'association Shalom venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Sing'INT",
      description:"C'est l'association Sing'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Spades",
      description:"C'est l'association Spades venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Sprint",
      description:"C'est l'association Sprint venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"TrendINT",
      description:"C'est l'association TrendINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Univert",
      description:"C'est l'association Univert venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Welcom",
      description:"C'est l'association Welcom venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
  Association(
      name:"Xtreme",
      description:"C'est l'association Xtreme venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"
  ),
];
