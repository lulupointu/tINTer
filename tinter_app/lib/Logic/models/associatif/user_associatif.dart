import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/serializers.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';

part 'user_associatif.g.dart';

abstract class UserAssociatif extends Object with UserSharedPart {
  bool get primoEntrant;

  double get attiranceVieAsso;

  double get feteOuCours;

  double get aideOuSortir;

  double get organisationEvenements;

  List<String> get goutsMusicaux;
}


abstract class BuildUserAssociatif
//    with UserSharedPart
    implements UserAssociatif, Built<BuildUserAssociatif, BuildUserAssociatifBuilder> {
  BuildUserAssociatif._();

  factory BuildUserAssociatif([void Function(BuildUserAssociatifBuilder) updates]) =
      _$BuildUserAssociatif;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(BuildUserAssociatif.serializer, this);
  }

  static BuildUserAssociatif fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(BuildUserAssociatif.serializer, json);
  }

  static Serializer<BuildUserAssociatif> get serializer => _$buildUserAssociatifSerializer;
}

//@JsonSerializable(explicitToJson: true)
//class UserAssociatif extends UserSharedPart {
//  final bool _primoEntrant;
//  final double _attiranceVieAsso;
//  final double _feteOuCours;
//  final double _aideOuSortir;
//  final double _organisationEvenements;
//  final List<String> _goutsMusicaux;
//
//  UserAssociatif({
//    @required login,
//    @required name,
//    @required surname,
//    @required email,
//    @required school,
//    profilePictureLocalPath,
//    List<dynamic> associations = const [],
//    @required bool primoEntrant,
//    @required double attiranceVieAsso,
//    @required double feteOuCours,
//    @required double aideOuSortir,
//    @required double organisationEvenements,
//    @required List<dynamic> goutsMusicaux,
//    String profilePicturePath,
//  })  : _primoEntrant = primoEntrant,
//        _attiranceVieAsso = attiranceVieAsso,
//        _feteOuCours = feteOuCours,
//        _aideOuSortir = aideOuSortir,
//        _organisationEvenements = organisationEvenements,
//        _goutsMusicaux =
//        goutsMusicaux?.map((dynamic goutMusical) => goutMusical.toString())?.toList(),
//        super(
//        login: login,
//        name: name,
//        surname: surname,
//        email: email,
//        school: school,
//        profilePictureLocalPath: profilePictureLocalPath,
//        associations: associations,
//      );
//
//  factory UserAssociatif.fromJson(Map<String, dynamic> json) => _$UserAssociatifFromJson(json);
//
//  Map<String, dynamic> toJson() => _$UserAssociatifToJson(this);
//
//  // Define all getter for the user info
//  bool get primoEntrant => _primoEntrant;
//
//  double get attiranceVieAsso => _attiranceVieAsso;
//
//  double get feteOuCours => _feteOuCours;
//
//  double get aideOuSortir => _aideOuSortir;
//
//  double get organisationEvenements => _organisationEvenements;
//
//  List<String> get goutsMusicaux => _goutsMusicaux;
//
//
//
//
//  bool isAnyAttributeNull() {
//    return props.map((Object prop) => prop == null).contains(true);
//  }
//
//  @override
//  List<Object> get props => [
//    ...super.props,
//    attiranceVieAsso,
//    feteOuCours,
//    aideOuSortir,
//    organisationEvenements,
//    goutsMusicaux,
//  ];
//}
