import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'association.g.dart';

abstract class Association implements Built<Association, AssociationBuilder> {
  String get name;

  String get description;

  Association._();

  factory Association([void Function(AssociationBuilder) updates]) = _$Association;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(Association.serializer, this);
  }

  static Association fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(Association.serializer, json);
  }

  static Serializer<Association> get serializer => _$associationSerializer;
}

//@JsonSerializable(explicitToJson: true)
//class Association extends Equatable {
//  final String name;
//  final String description;
//
//  Association({this.name, this.description});
//
//  factory Association.fromJson(Map<String, dynamic> json) => _$AssociationFromJson(json);
//
//  Map<String, dynamic> toJson() => _$AssociationToJson(this);
//
//  String toString() =>
//      '(Association) name: $name, description: $description';
//
//  Widget getLogo() {
//    return FutureBuilder(
//      future: AuthenticationRepository.getAuthenticationToken(),
//      builder: (BuildContext context, AsyncSnapshot<Token> snapshot) {
//        return (!snapshot.hasData) ? CircularProgressIndicator() : Image.network(
//          Uri.http(TinterAPIClient.baseUrl, '/associations/associationLogo', {'associationName': name}).toString(),
//          headers: {HttpHeaders.wwwAuthenticateHeader: snapshot.data.token},
//          fit: BoxFit.contain,
//        );
//      },
//    );
//  }
//
//  @override
//  List<Object> get props => [name, description];
//
//}

// TODO: Change to real asso descriptions
List<Association> allAssociations = [
  Association((a) => a
    ..name = "AbsINThe"
    ..description =
        "C'est l'association AbsINThe venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "AfricanIT"
    ..description =
        "C'est l'association AfricanIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Agora"
    ..description =
        "C'est l'association Agora venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "AIESEC"
    ..description =
        "C'est l'association AIESEC venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "AnimINT"
    ..description =
        "C'est l'association AnimINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Aparte"
    ..description =
        "C'est l'association Aparte venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "ASINT"
    ..description =
        "C'est l'association ASINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Asphalte"
    ..description =
        "C'est l'association Asphalte venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Band'a michel"
    ..description =
        "C'est l'association michel venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "BDA"
    ..description =
        "C'est l'association BDA venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Belly Dance"
    ..description =
        "C'est l'association Dance venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "BollyINT"
    ..description =
        "C'est l'association BollyINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "BPM"
    ..description =
        "C'est l'association BPM venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "BricolINT"
    ..description =
        "C'est l'association BricolINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Bstyle"
    ..description =
        "C'est l'association Bstyle venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "CELL"
    ..description =
        "C'est l'association CELL venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Cine"
    ..description =
        "C'est l'association Cine venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Club Zik"
    ..description =
        "C'est l'association Zik venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "CookIT"
    ..description =
        "C'est l'association CookIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Déclic"
    ..description =
        "C'est l'association Déclic venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "DolphINT"
    ..description =
        "C'est l'association DolphINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Emotys"
    ..description =
        "C'est l'association Emotys venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Epicurieux"
    ..description =
        "C'est l'association Epicurieux venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "EquIT"
    ..description =
        "C'est l'association EquIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Evryone"
    ..description =
        "C'est l'association Evryone venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "FIMTech"
    ..description =
        "C'est l'association FIMTech venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Forum"
    ..description =
        "C'est l'association Forum venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "GameINT"
    ..description =
        "C'est l'association GameINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Golf"
    ..description =
        "C'est l'association Golf venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "HackademINT"
    ..description =
        "C'est l'association HackademINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Heforshe"
    ..description =
        "C'est l'association Heforshe venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "INacT"
    ..description =
        "C'est l'association INacT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "INTech"
    ..description =
        "C'est l'association INTech venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Interlude"
    ..description =
        "C'est l'association Interlude venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Intervenir"
    ..description =
        "C'est l'association Intervenir venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "INTimes"
    ..description =
        "C'est l'association INTimes venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "INTv"
    ..description =
        "C'est l'association INTv venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "KpopIT"
    ..description =
        "C'est l'association KpopIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "KryptoSphère"
    ..description =
        "C'est l'association KryptoSphère venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "LPE"
    ..description =
        "C'est l'association LPE venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "MINeT"
    ..description =
        "C'est l'association MINeT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Moov'INT"
    ..description =
        "C'est l'association Moov'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "MuslimINT"
    ..description =
        "C'est l'association MuslimINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Nihao"
    ..description =
        "C'est l'association Nihao venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "PaintIT"
    ..description =
        "C'est l'association PaintIT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Pomp'int"
    ..description =
        "C'est l'association Pomp'int venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Promo2Tel"
    ..description =
        "C'est l'association Promo2Tel venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Rock'INT"
    ..description =
        "C'est l'association Rock'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Saint Espr'IT"
    ..description =
        "C'est l'association Espr'IT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "SalsaINT"
    ..description =
        "C'est l'association SalsaINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Shalom"
    ..description =
        "C'est l'association Shalom venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Sing'INT"
    ..description =
        "C'est l'association Sing'INT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Spades"
    ..description =
        "C'est l'association Spades venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Sprint"
    ..description =
        "C'est l'association Sprint venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "TrendINT"
    ..description =
        "C'est l'association TrendINT venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Univert"
    ..description =
        "C'est l'association Univert venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Welcom"
    ..description =
        "C'est l'association Welcom venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
  Association((a) => a
    ..name = "Xtreme"
    ..description =
        "C'est l'association Xtreme venez tous on s'y amuse trop. Merci de votre lecture blah blah blah"),
];
