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
        "Gère le bar de l'école"),
Association((a) => a
    ..name = "AfricanIT"
    ..description =
        "Découverte de la culture Africaine."),
  Association((a) => a
    ..name = "Agora"
    ..description =
        "Venez apprendre à être le meilleur des orateurs."),
  Association((a) => a
    ..name = "AIESEC"
    ..description =
        "Developper vous humainement et professionnalement grace à cette ONG internationnale."),
  Association((a) => a
    ..name = "AnimINT"
    ..description =
        "Club de diffusion d'animé."),
  Association((a) => a
    ..name = "Aparte"
    ..description =
        "Club de théatre. Impro ou non, tout style."),
  Association((a) => a
    ..name = "ASINT"
    ..description =
        "Association \"sportive\" (BDS) de l’INT."),
  Association((a) => a
    ..name = "Asphalte"
    ..description =
        "Découvre la mécanique et participe à des Monte."),
  Association((a) => a
    ..name = "Band'a michel"
    ..description =
        "Fanfare de l'INT. Pas besoin de savoir jouer pour participer!"),
  Association((a) => a
    ..name = "BDA"
    ..description =
        "Le BDA est en charge d'organiser les événements artistiques de l'école."),
  Association((a) => a
    ..name = "Belly Dance"
    ..description =
        "Club de Danse orientale."),
  Association((a) => a
    ..name = "BollyINT"
    ..description =
        "Association de bolly dance."),
  Association((a) => a
    ..name = "BPM"
    ..description =
        "Apprend à gérer les lumières, le son, les structures et le mix."),
  Association((a) => a
    ..name = "BricolINT"
    ..description =
        "Bricol’INT est le club du bricolage, Réalisation de menuiserie, impression 3D et découpe laser grace au FabLab."),
  Association((a) => a
    ..name = "Bstyle"
    ..description =
        "Club de danse HipHop du campus."),
  Association((a) => a
    ..name = "CELL"
    ..description =
        "Club de création de jeux sous toutes ses formes : jeux de plateaux, jeux vidéo et même escape games."),
  Association((a) => a
    ..name = "Cine"
    ..description =
        "Venez faire du montage, de la réalisation ou travailler votre jeux d'acteur."),
  Association((a) => a
    ..name = "Club Zik"
    ..description =
        "Club de musique. Crée ton groupe ou entraine toi en solo."),
  Association((a) => a
    ..name = "CookIT"
    ..description =
        "Club de cuisine."),
  Association((a) => a
    ..name = "Déclic"
    ..description =
        "Association de photographie. Formation et sorties photos sont organisées."),
  Association((a) => a
    ..name = "DolphINT"
    ..description =
        "Club de voile du campus."),
  Association((a) => a
    ..name = "Emotys"
    ..description =
        "CLub de comédie musicale. Chant, danse, théatre, et même composition sont pratiquées."),
  Association((a) => a
    ..name = "Epicurieux"
    ..description =
        "Club d'oenologie du campus"),
  Association((a) => a
    ..name = "EquIT"
    ..description =
        "Club qui t'emmène tous les jeudi après-midi faire une heure d'équitation dans un centre équestre à proximité des écoles."),
  Association((a) => a
    ..name = "Evryone"
    ..description =
        "Radio de l'INT."),
  Association((a) => a
    ..name = "FIMTech"
    ..description =
        "Club de finance de l'école"),
  Association((a) => a
    ..name = "Forum"
    ..description =
        "Association qui prépare le forum des Télécommunications."),
  Association((a) => a
    ..name = "GameINT"
    ..description =
        "Club de jeux vidéo du campus. Organisation de LAN et tournois."),
  Association((a) => a
    ..name = "Golf"
    ..description =
        "CLub de golf."),
  Association((a) => a
    ..name = "HackademINT"
    ..description =
        "Club de sécurité informatique."),
  Association((a) => a
    ..name = "Heforshe"
    ..description =
        "Engagez vous pour l'égalité homme femme."),
  Association((a) => a
    ..name = "INacT"
    ..description =
        "Association de prévention et de lutte contre les discriminations du campus."),
  Association((a) => a
    ..name = "INTech"
    ..description =
        "Club de robotique. Participe à la coupe de France de robotique."),
  Association((a) => a
    ..name = "Interlude"
    ..description =
        "Orchestre du campus."),
  Association((a) => a
    ..name = "Intervenir"
    ..description =
        "Association humanitaire du campus."),
  Association((a) => a
    ..name = "INTimes"
    ..description =
        "Un journal relatant de la vie sur le campus"),
  Association((a) => a
    ..name = "INTv"
    ..description =
        "Club vidéo. Apprend à filmer et monter."),
  Association((a) => a
    ..name = "KpopIT"
    ..description =
        "Club de KPop."),
  Association((a) => a
    ..name = "KryptoSphère"
    ..description =
        "KRYPTOSPHERE® est la première association étudiante de France spécialisée dans la Blockchain, l'Intelligence Artificielle et les Objets Connectés."),
  Association((a) => a
    ..name = "LPE"
    ..description =
        "Association Les Partenariats d'Excellence"),
  Association((a) => a
    ..name = "MINeT"
    ..description =
        "MiNET est l'assocation réseau de l'école."),
  Association((a) => a
    ..name = "Moov'INT"
    ..description =
        "Club de danse: modern jazz, street jazz, classique, contemporain, cabaret et bien plus encore!"),
  Association((a) => a
    ..name = "MuslimINT"
    ..description =
        "Club qui vous permettra d’en apprendre plus sur la culture musulmane."),
  Association((a) => a
    ..name = "Nihao"
    ..description =
        "Découvrez et célébrez la culture chinoise."),
  Association((a) => a
    ..name = "PaintIT"
    ..description =
        "Club de dessin, de peinture, ou n'importe qu'elle oeuvre physique ou informatique."),
  Association((a) => a
    ..name = "Pomp'int"
    ..description =
        "Club de cheerleading du campus."),
  Association((a) => a
    ..name = "Promo2Tel"
    ..description =
        "Organise la présention des écoles dans les prepa et donne des conseil pour le parcour professionel."),
  Association((a) => a
    ..name = "Rock'INT"
    ..description =
        "Club de Rock de l'INT."),
  Association((a) => a
    ..name = "Saint Espr'IT"
    ..description =
        "Club qui vous permettra d’en apprendre plus sur la culture chrétienne."),
  Association((a) => a
    ..name = "SalsaINT"
    ..description =
        "Club de Salsa de l'INT"),
  Association((a) => a
    ..name = "Shalom"
    ..description =
        "Club qui vous permettra d’en apprendre plus sur la culture juive."),
  Association((a) => a
    ..name = "Sing'INT"
    ..description =
        "Chorale du campus pour les passionnés de chant."),
  Association((a) => a
    ..name = "Spades"
    ..description =
        "Club de carte."),
  Association((a) => a
    ..name = "Sprint"
    ..description =
        "Micro-entreprise proposant une expérience professionnalisante."),
  Association((a) => a
    ..name = "TrendINT"
    ..description =
        "Viens partager ta passion pour la mode."),
  Association((a) => a
    ..name = "Univert"
    ..description =
        "Association menant des actions pour l'écologie sur le campus."),
  Association((a) => a
    ..name = "Welcom"
    ..description =
        "Club qui participe à l'integration des internationaux au sein de l'INT."),
  Association((a) => a
    ..name = "Xtreme"
    ..description =
        "Xtreme est le club de sports nature du campus. Initialement le club de course à pied, le bureau actuel aimerait élargir le panel d'activités proposées."),
  Association((a) => a
    ..name = "BDE"
    ..description =
        "En charge de la vie associative et festive"),
];
