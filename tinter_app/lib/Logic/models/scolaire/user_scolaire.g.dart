// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_scolaire.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UserScolaireMutableAttribute _$year =
    const UserScolaireMutableAttribute._('year');
const UserScolaireMutableAttribute _$groupeOuSeul =
    const UserScolaireMutableAttribute._('groupeOuSeul');
const UserScolaireMutableAttribute _$lieuDeVie =
    const UserScolaireMutableAttribute._('lieuDeVie');
const UserScolaireMutableAttribute _$horairesDeTravail =
    const UserScolaireMutableAttribute._('horairesDeTravail');
const UserScolaireMutableAttribute _$enligneOuNon =
    const UserScolaireMutableAttribute._('enligneOuNon');
const UserScolaireMutableAttribute _$matieresPreferees =
    const UserScolaireMutableAttribute._('matieresPreferees');

UserScolaireMutableAttribute _$userScolaireMutableAttributeValueOf(
    String name) {
  switch (name) {
    case 'year':
      return _$year;
    case 'groupeOuSeul':
      return _$groupeOuSeul;
    case 'lieuDeVie':
      return _$lieuDeVie;
    case 'horairesDeTravail':
      return _$horairesDeTravail;
    case 'enligneOuNon':
      return _$enligneOuNon;
    case 'matieresPreferees':
      return _$matieresPreferees;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<UserScolaireMutableAttribute>
    _$userScolaireMutableAttributeValues = new BuiltSet<
        UserScolaireMutableAttribute>(const <UserScolaireMutableAttribute>[
  _$year,
  _$groupeOuSeul,
  _$lieuDeVie,
  _$horairesDeTravail,
  _$enligneOuNon,
  _$matieresPreferees,
]);

const TSPYear _$TSP1A = const TSPYear._('TSP1A');
const TSPYear _$TSP2A = const TSPYear._('TSP2A');
const TSPYear _$TSP3A = const TSPYear._('TSP3A');

TSPYear _$tSPYearValueOf(String name) {
  switch (name) {
    case 'TSP1A':
      return _$TSP1A;
    case 'TSP2A':
      return _$TSP2A;
    case 'TSP3A':
      return _$TSP3A;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<TSPYear> _$tSPYearValues = new BuiltSet<TSPYear>(const <TSPYear>[
  _$TSP1A,
  _$TSP2A,
  _$TSP3A,
]);

const GroupeOuSeul _$groupe = const GroupeOuSeul._('groupe');
const GroupeOuSeul _$seul = const GroupeOuSeul._('seul');

GroupeOuSeul _$groupeOuSeulValueOf(String name) {
  switch (name) {
    case 'groupe':
      return _$groupe;
    case 'seul':
      return _$seul;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<GroupeOuSeul> _$groupeOuSeulValues =
    new BuiltSet<GroupeOuSeul>(const <GroupeOuSeul>[
  _$groupe,
  _$seul,
]);

const LieuDeVie _$maisel = const LieuDeVie._('maisel');
const LieuDeVie _$other = const LieuDeVie._('other');

LieuDeVie _$lieuDeVieValueOf(String name) {
  switch (name) {
    case 'maisel':
      return _$maisel;
    case 'other':
      return _$other;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<LieuDeVie> _$lieuDeVieValues =
    new BuiltSet<LieuDeVie>(const <LieuDeVie>[
  _$maisel,
  _$other,
]);

const HoraireDeTravail _$morning = const HoraireDeTravail._('morning');
const HoraireDeTravail _$afternoon = const HoraireDeTravail._('afternoon');
const HoraireDeTravail _$evening = const HoraireDeTravail._('evening');
const HoraireDeTravail _$night = const HoraireDeTravail._('night');

HoraireDeTravail _$horaireDeTravailValueOf(String name) {
  switch (name) {
    case 'morning':
      return _$morning;
    case 'afternoon':
      return _$afternoon;
    case 'evening':
      return _$evening;
    case 'night':
      return _$night;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<HoraireDeTravail> _$horaireDeTravailValues =
    new BuiltSet<HoraireDeTravail>(const <HoraireDeTravail>[
  _$morning,
  _$afternoon,
  _$evening,
  _$night,
]);

const OutilDeTravail _$online = const OutilDeTravail._('online');
const OutilDeTravail _$faceToFace = const OutilDeTravail._('faceToFace');

OutilDeTravail _$outilDeTravailValueOf(String name) {
  switch (name) {
    case 'online':
      return _$online;
    case 'faceToFace':
      return _$faceToFace;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<OutilDeTravail> _$outilDeTravailValues =
    new BuiltSet<OutilDeTravail>(const <OutilDeTravail>[
  _$online,
  _$faceToFace,
]);

Serializer<BuildUserScolaire> _$buildUserScolaireSerializer =
    new _$BuildUserScolaireSerializer();
Serializer<UserScolaireMutableAttribute>
    _$userScolaireMutableAttributeSerializer =
    new _$UserScolaireMutableAttributeSerializer();
Serializer<TSPYear> _$tSPYearSerializer = new _$TSPYearSerializer();
Serializer<GroupeOuSeul> _$groupeOuSeulSerializer =
    new _$GroupeOuSeulSerializer();
Serializer<LieuDeVie> _$lieuDeVieSerializer = new _$LieuDeVieSerializer();
Serializer<HoraireDeTravail> _$horaireDeTravailSerializer =
    new _$HoraireDeTravailSerializer();
Serializer<OutilDeTravail> _$outilDeTravailSerializer =
    new _$OutilDeTravailSerializer();

class _$BuildUserScolaireSerializer
    implements StructuredSerializer<BuildUserScolaire> {
  @override
  final Iterable<Type> types = const [BuildUserScolaire, _$BuildUserScolaire];
  @override
  final String wireName = 'BuildUserScolaire';

  @override
  Iterable<Object> serialize(Serializers serializers, BuildUserScolaire object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'year',
      serializers.serialize(object.year,
          specifiedType: const FullType(TSPYear)),
      'groupeOuSeul',
      serializers.serialize(object.groupeOuSeul,
          specifiedType: const FullType(GroupeOuSeul)),
      'lieuDeVie',
      serializers.serialize(object.lieuDeVie,
          specifiedType: const FullType(LieuDeVie)),
      'horairesDeTravail',
      serializers.serialize(object.horairesDeTravail,
          specifiedType: const FullType(
              BuiltList, const [const FullType(HoraireDeTravail)])),
      'enligneOuNon',
      serializers.serialize(object.enligneOuNon,
          specifiedType: const FullType(OutilDeTravail)),
      'matieresPreferees',
      serializers.serialize(object.matieresPreferees,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'login',
      serializers.serialize(object.login,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'surname',
      serializers.serialize(object.surname,
          specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
      'school',
      serializers.serialize(object.school,
          specifiedType: const FullType(School)),
      'associations',
      serializers.serialize(object.associations,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Association)])),
    ];
    if (object.profilePictureLocalPath != null) {
      result
        ..add('profilePictureLocalPath')
        ..add(serializers.serialize(object.profilePictureLocalPath,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuildUserScolaire deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildUserScolaireBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'year':
          result.year = serializers.deserialize(value,
              specifiedType: const FullType(TSPYear)) as TSPYear;
          break;
        case 'groupeOuSeul':
          result.groupeOuSeul = serializers.deserialize(value,
              specifiedType: const FullType(GroupeOuSeul)) as GroupeOuSeul;
          break;
        case 'lieuDeVie':
          result.lieuDeVie = serializers.deserialize(value,
              specifiedType: const FullType(LieuDeVie)) as LieuDeVie;
          break;
        case 'horairesDeTravail':
          result.horairesDeTravail.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(HoraireDeTravail)]))
              as BuiltList<Object>);
          break;
        case 'enligneOuNon':
          result.enligneOuNon = serializers.deserialize(value,
              specifiedType: const FullType(OutilDeTravail)) as OutilDeTravail;
          break;
        case 'matieresPreferees':
          result.matieresPreferees.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'login':
          result.login = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'surname':
          result.surname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'school':
          result.school = serializers.deserialize(value,
              specifiedType: const FullType(School)) as School;
          break;
        case 'profilePictureLocalPath':
          result.profilePictureLocalPath = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'associations':
          result.associations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Association)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$UserScolaireMutableAttributeSerializer
    implements PrimitiveSerializer<UserScolaireMutableAttribute> {
  @override
  final Iterable<Type> types = const <Type>[UserScolaireMutableAttribute];
  @override
  final String wireName = 'UserScolaireMutableAttribute';

  @override
  Object serialize(Serializers serializers, UserScolaireMutableAttribute object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  UserScolaireMutableAttribute deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UserScolaireMutableAttribute.valueOf(serialized as String);
}

class _$TSPYearSerializer implements PrimitiveSerializer<TSPYear> {
  @override
  final Iterable<Type> types = const <Type>[TSPYear];
  @override
  final String wireName = 'TSPYear';

  @override
  Object serialize(Serializers serializers, TSPYear object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  TSPYear deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      TSPYear.valueOf(serialized as String);
}

class _$GroupeOuSeulSerializer implements PrimitiveSerializer<GroupeOuSeul> {
  @override
  final Iterable<Type> types = const <Type>[GroupeOuSeul];
  @override
  final String wireName = 'GroupeOuSeul';

  @override
  Object serialize(Serializers serializers, GroupeOuSeul object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  GroupeOuSeul deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GroupeOuSeul.valueOf(serialized as String);
}

class _$LieuDeVieSerializer implements PrimitiveSerializer<LieuDeVie> {
  @override
  final Iterable<Type> types = const <Type>[LieuDeVie];
  @override
  final String wireName = 'LieuDeVie';

  @override
  Object serialize(Serializers serializers, LieuDeVie object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  LieuDeVie deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LieuDeVie.valueOf(serialized as String);
}

class _$HoraireDeTravailSerializer
    implements PrimitiveSerializer<HoraireDeTravail> {
  @override
  final Iterable<Type> types = const <Type>[HoraireDeTravail];
  @override
  final String wireName = 'HoraireDeTravail';

  @override
  Object serialize(Serializers serializers, HoraireDeTravail object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  HoraireDeTravail deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HoraireDeTravail.valueOf(serialized as String);
}

class _$OutilDeTravailSerializer
    implements PrimitiveSerializer<OutilDeTravail> {
  @override
  final Iterable<Type> types = const <Type>[OutilDeTravail];
  @override
  final String wireName = 'OutilDeTravail';

  @override
  Object serialize(Serializers serializers, OutilDeTravail object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  OutilDeTravail deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OutilDeTravail.valueOf(serialized as String);
}

class _$BuildUserScolaire extends BuildUserScolaire {
  @override
  final TSPYear year;
  @override
  final GroupeOuSeul groupeOuSeul;
  @override
  final LieuDeVie lieuDeVie;
  @override
  final BuiltList<HoraireDeTravail> horairesDeTravail;
  @override
  final OutilDeTravail enligneOuNon;
  @override
  final BuiltList<String> matieresPreferees;
  @override
  final String login;
  @override
  final String name;
  @override
  final String surname;
  @override
  final String email;
  @override
  final School school;
  @override
  final String profilePictureLocalPath;
  @override
  final BuiltList<Association> associations;

  factory _$BuildUserScolaire(
          [void Function(BuildUserScolaireBuilder) updates]) =>
      (new BuildUserScolaireBuilder()..update(updates)).build();

  _$BuildUserScolaire._(
      {this.year,
      this.groupeOuSeul,
      this.lieuDeVie,
      this.horairesDeTravail,
      this.enligneOuNon,
      this.matieresPreferees,
      this.login,
      this.name,
      this.surname,
      this.email,
      this.school,
      this.profilePictureLocalPath,
      this.associations})
      : super._() {
    if (year == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'year');
    }
    if (groupeOuSeul == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'groupeOuSeul');
    }
    if (lieuDeVie == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'lieuDeVie');
    }
    if (horairesDeTravail == null) {
      throw new BuiltValueNullFieldError(
          'BuildUserScolaire', 'horairesDeTravail');
    }
    if (enligneOuNon == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'enligneOuNon');
    }
    if (matieresPreferees == null) {
      throw new BuiltValueNullFieldError(
          'BuildUserScolaire', 'matieresPreferees');
    }
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'email');
    }
    if (school == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'school');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildUserScolaire', 'associations');
    }
  }

  @override
  BuildUserScolaire rebuild(void Function(BuildUserScolaireBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildUserScolaireBuilder toBuilder() =>
      new BuildUserScolaireBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildUserScolaire &&
        year == other.year &&
        groupeOuSeul == other.groupeOuSeul &&
        lieuDeVie == other.lieuDeVie &&
        horairesDeTravail == other.horairesDeTravail &&
        enligneOuNon == other.enligneOuNon &&
        matieresPreferees == other.matieresPreferees &&
        login == other.login &&
        name == other.name &&
        surname == other.surname &&
        email == other.email &&
        school == other.school &&
        profilePictureLocalPath == other.profilePictureLocalPath &&
        associations == other.associations;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc($jc(0, year.hashCode),
                                                    groupeOuSeul.hashCode),
                                                lieuDeVie.hashCode),
                                            horairesDeTravail.hashCode),
                                        enligneOuNon.hashCode),
                                    matieresPreferees.hashCode),
                                login.hashCode),
                            name.hashCode),
                        surname.hashCode),
                    email.hashCode),
                school.hashCode),
            profilePictureLocalPath.hashCode),
        associations.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuildUserScolaire')
          ..add('year', year)
          ..add('groupeOuSeul', groupeOuSeul)
          ..add('lieuDeVie', lieuDeVie)
          ..add('horairesDeTravail', horairesDeTravail)
          ..add('enligneOuNon', enligneOuNon)
          ..add('matieresPreferees', matieresPreferees)
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('email', email)
          ..add('school', school)
          ..add('profilePictureLocalPath', profilePictureLocalPath)
          ..add('associations', associations))
        .toString();
  }
}

class BuildUserScolaireBuilder
    implements Builder<BuildUserScolaire, BuildUserScolaireBuilder> {
  _$BuildUserScolaire _$v;

  TSPYear _year;
  TSPYear get year => _$this._year;
  set year(TSPYear year) => _$this._year = year;

  GroupeOuSeul _groupeOuSeul;
  GroupeOuSeul get groupeOuSeul => _$this._groupeOuSeul;
  set groupeOuSeul(GroupeOuSeul groupeOuSeul) =>
      _$this._groupeOuSeul = groupeOuSeul;

  LieuDeVie _lieuDeVie;
  LieuDeVie get lieuDeVie => _$this._lieuDeVie;
  set lieuDeVie(LieuDeVie lieuDeVie) => _$this._lieuDeVie = lieuDeVie;

  ListBuilder<HoraireDeTravail> _horairesDeTravail;
  ListBuilder<HoraireDeTravail> get horairesDeTravail =>
      _$this._horairesDeTravail ??= new ListBuilder<HoraireDeTravail>();
  set horairesDeTravail(ListBuilder<HoraireDeTravail> horairesDeTravail) =>
      _$this._horairesDeTravail = horairesDeTravail;

  OutilDeTravail _enligneOuNon;
  OutilDeTravail get enligneOuNon => _$this._enligneOuNon;
  set enligneOuNon(OutilDeTravail enligneOuNon) =>
      _$this._enligneOuNon = enligneOuNon;

  ListBuilder<String> _matieresPreferees;
  ListBuilder<String> get matieresPreferees =>
      _$this._matieresPreferees ??= new ListBuilder<String>();
  set matieresPreferees(ListBuilder<String> matieresPreferees) =>
      _$this._matieresPreferees = matieresPreferees;

  String _login;
  String get login => _$this._login;
  set login(String login) => _$this._login = login;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _surname;
  String get surname => _$this._surname;
  set surname(String surname) => _$this._surname = surname;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  School _school;
  School get school => _$this._school;
  set school(School school) => _$this._school = school;

  String _profilePictureLocalPath;
  String get profilePictureLocalPath => _$this._profilePictureLocalPath;
  set profilePictureLocalPath(String profilePictureLocalPath) =>
      _$this._profilePictureLocalPath = profilePictureLocalPath;

  ListBuilder<Association> _associations;
  ListBuilder<Association> get associations =>
      _$this._associations ??= new ListBuilder<Association>();
  set associations(ListBuilder<Association> associations) =>
      _$this._associations = associations;

  BuildUserScolaireBuilder();

  BuildUserScolaireBuilder get _$this {
    if (_$v != null) {
      _year = _$v.year;
      _groupeOuSeul = _$v.groupeOuSeul;
      _lieuDeVie = _$v.lieuDeVie;
      _horairesDeTravail = _$v.horairesDeTravail?.toBuilder();
      _enligneOuNon = _$v.enligneOuNon;
      _matieresPreferees = _$v.matieresPreferees?.toBuilder();
      _login = _$v.login;
      _name = _$v.name;
      _surname = _$v.surname;
      _email = _$v.email;
      _school = _$v.school;
      _profilePictureLocalPath = _$v.profilePictureLocalPath;
      _associations = _$v.associations?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuildUserScolaire other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuildUserScolaire;
  }

  @override
  void update(void Function(BuildUserScolaireBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildUserScolaire build() {
    _$BuildUserScolaire _$result;
    try {
      _$result = _$v ??
          new _$BuildUserScolaire._(
              year: year,
              groupeOuSeul: groupeOuSeul,
              lieuDeVie: lieuDeVie,
              horairesDeTravail: horairesDeTravail.build(),
              enligneOuNon: enligneOuNon,
              matieresPreferees: matieresPreferees.build(),
              login: login,
              name: name,
              surname: surname,
              email: email,
              school: school,
              profilePictureLocalPath: profilePictureLocalPath,
              associations: associations.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'horairesDeTravail';
        horairesDeTravail.build();

        _$failedField = 'matieresPreferees';
        matieresPreferees.build();

        _$failedField = 'associations';
        associations.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuildUserScolaire', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
