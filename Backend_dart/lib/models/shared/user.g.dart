// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const School _$TSP = const School._('TSP');
const School _$IMTBS = const School._('IMTBS');

School _$schoolValueOf(String name) {
  switch (name) {
    case 'TSP':
      return _$TSP;
    case 'IMTBS':
      return _$IMTBS;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<School> _$schoolValues = new BuiltSet<School>(const <School>[
  _$TSP,
  _$IMTBS,
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

Serializer<BuildUser> _$buildUserSerializer = new _$BuildUserSerializer();
Serializer<School> _$schoolSerializer = new _$SchoolSerializer();
Serializer<TSPYear> _$tSPYearSerializer = new _$TSPYearSerializer();
Serializer<LieuDeVie> _$lieuDeVieSerializer = new _$LieuDeVieSerializer();
Serializer<HoraireDeTravail> _$horaireDeTravailSerializer =
    new _$HoraireDeTravailSerializer();

class _$BuildUserSerializer implements StructuredSerializer<BuildUser> {
  @override
  final Iterable<Type> types = const [BuildUser, _$BuildUser];
  @override
  final String wireName = 'BuildUser';

  @override
  Iterable<Object> serialize(Serializers serializers, BuildUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
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
      'primoEntrant',
      serializers.serialize(object.primoEntrant,
          specifiedType: const FullType(bool)),
      'attiranceVieAsso',
      serializers.serialize(object.attiranceVieAsso,
          specifiedType: const FullType(double)),
      'feteOuCours',
      serializers.serialize(object.feteOuCours,
          specifiedType: const FullType(double)),
      'aideOuSortir',
      serializers.serialize(object.aideOuSortir,
          specifiedType: const FullType(double)),
      'organisationEvenements',
      serializers.serialize(object.organisationEvenements,
          specifiedType: const FullType(double)),
      'goutsMusicaux',
      serializers.serialize(object.goutsMusicaux,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'year',
      serializers.serialize(object.year,
          specifiedType: const FullType(TSPYear)),
      'lieuDeVie',
      serializers.serialize(object.lieuDeVie,
          specifiedType: const FullType(LieuDeVie)),
      'groupeOuSeul',
      serializers.serialize(object.groupeOuSeul,
          specifiedType: const FullType(double)),
      'horairesDeTravail',
      serializers.serialize(object.horairesDeTravail,
          specifiedType: const FullType(
              BuiltList, const [const FullType(HoraireDeTravail)])),
      'enligneOuNon',
      serializers.serialize(object.enligneOuNon,
          specifiedType: const FullType(double)),
      'matieresPreferees',
      serializers.serialize(object.matieresPreferees,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
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
  BuildUser deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
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
        case 'primoEntrant':
          result.primoEntrant = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'attiranceVieAsso':
          result.attiranceVieAsso = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'feteOuCours':
          result.feteOuCours = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'aideOuSortir':
          result.aideOuSortir = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'organisationEvenements':
          result.organisationEvenements = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'goutsMusicaux':
          result.goutsMusicaux.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'year':
          result.year = serializers.deserialize(value,
              specifiedType: const FullType(TSPYear)) as TSPYear;
          break;
        case 'lieuDeVie':
          result.lieuDeVie = serializers.deserialize(value,
              specifiedType: const FullType(LieuDeVie)) as LieuDeVie;
          break;
        case 'groupeOuSeul':
          result.groupeOuSeul = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'horairesDeTravail':
          result.horairesDeTravail.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(HoraireDeTravail)]))
              as BuiltList<Object>);
          break;
        case 'enligneOuNon':
          result.enligneOuNon = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'matieresPreferees':
          result.matieresPreferees.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$SchoolSerializer implements PrimitiveSerializer<School> {
  @override
  final Iterable<Type> types = const <Type>[School];
  @override
  final String wireName = 'School';

  @override
  Object serialize(Serializers serializers, School object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  School deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      School.valueOf(serialized as String);
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

class _$BuildUser extends BuildUser {
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
  @override
  final bool primoEntrant;
  @override
  final double attiranceVieAsso;
  @override
  final double feteOuCours;
  @override
  final double aideOuSortir;
  @override
  final double organisationEvenements;
  @override
  final BuiltList<String> goutsMusicaux;
  @override
  final TSPYear year;
  @override
  final LieuDeVie lieuDeVie;
  @override
  final double groupeOuSeul;
  @override
  final BuiltList<HoraireDeTravail> horairesDeTravail;
  @override
  final double enligneOuNon;
  @override
  final BuiltList<String> matieresPreferees;

  factory _$BuildUser([void Function(BuildUserBuilder) updates]) =>
      (new BuildUserBuilder()..update(updates)).build();

  _$BuildUser._(
      {this.login,
      this.name,
      this.surname,
      this.email,
      this.school,
      this.profilePictureLocalPath,
      this.associations,
      this.primoEntrant,
      this.attiranceVieAsso,
      this.feteOuCours,
      this.aideOuSortir,
      this.organisationEvenements,
      this.goutsMusicaux,
      this.year,
      this.lieuDeVie,
      this.groupeOuSeul,
      this.horairesDeTravail,
      this.enligneOuNon,
      this.matieresPreferees})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'email');
    }
    if (school == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'school');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'associations');
    }
    if (primoEntrant == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'primoEntrant');
    }
    if (attiranceVieAsso == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'attiranceVieAsso');
    }
    if (feteOuCours == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'feteOuCours');
    }
    if (aideOuSortir == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'aideOuSortir');
    }
    if (organisationEvenements == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'organisationEvenements');
    }
    if (goutsMusicaux == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'goutsMusicaux');
    }
    if (year == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'year');
    }
    if (lieuDeVie == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'lieuDeVie');
    }
    if (groupeOuSeul == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'groupeOuSeul');
    }
    if (horairesDeTravail == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'horairesDeTravail');
    }
    if (enligneOuNon == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'enligneOuNon');
    }
    if (matieresPreferees == null) {
      throw new BuiltValueNullFieldError('BuildUser', 'matieresPreferees');
    }
  }

  @override
  BuildUser rebuild(void Function(BuildUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildUserBuilder toBuilder() => new BuildUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildUser &&
        login == other.login &&
        name == other.name &&
        surname == other.surname &&
        email == other.email &&
        school == other.school &&
        profilePictureLocalPath == other.profilePictureLocalPath &&
        associations == other.associations &&
        primoEntrant == other.primoEntrant &&
        attiranceVieAsso == other.attiranceVieAsso &&
        feteOuCours == other.feteOuCours &&
        aideOuSortir == other.aideOuSortir &&
        organisationEvenements == other.organisationEvenements &&
        goutsMusicaux == other.goutsMusicaux &&
        year == other.year &&
        lieuDeVie == other.lieuDeVie &&
        groupeOuSeul == other.groupeOuSeul &&
        horairesDeTravail == other.horairesDeTravail &&
        enligneOuNon == other.enligneOuNon &&
        matieresPreferees == other.matieresPreferees;
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
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc(
                                                                                0,
                                                                                login
                                                                                    .hashCode),
                                                                            name
                                                                                .hashCode),
                                                                        surname
                                                                            .hashCode),
                                                                    email
                                                                        .hashCode),
                                                                school
                                                                    .hashCode),
                                                            profilePictureLocalPath
                                                                .hashCode),
                                                        associations.hashCode),
                                                    primoEntrant.hashCode),
                                                attiranceVieAsso.hashCode),
                                            feteOuCours.hashCode),
                                        aideOuSortir.hashCode),
                                    organisationEvenements.hashCode),
                                goutsMusicaux.hashCode),
                            year.hashCode),
                        lieuDeVie.hashCode),
                    groupeOuSeul.hashCode),
                horairesDeTravail.hashCode),
            enligneOuNon.hashCode),
        matieresPreferees.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuildUser')
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('email', email)
          ..add('school', school)
          ..add('profilePictureLocalPath', profilePictureLocalPath)
          ..add('associations', associations)
          ..add('primoEntrant', primoEntrant)
          ..add('attiranceVieAsso', attiranceVieAsso)
          ..add('feteOuCours', feteOuCours)
          ..add('aideOuSortir', aideOuSortir)
          ..add('organisationEvenements', organisationEvenements)
          ..add('goutsMusicaux', goutsMusicaux)
          ..add('year', year)
          ..add('lieuDeVie', lieuDeVie)
          ..add('groupeOuSeul', groupeOuSeul)
          ..add('horairesDeTravail', horairesDeTravail)
          ..add('enligneOuNon', enligneOuNon)
          ..add('matieresPreferees', matieresPreferees))
        .toString();
  }
}

class BuildUserBuilder implements Builder<BuildUser, BuildUserBuilder> {
  _$BuildUser _$v;

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

  bool _primoEntrant;
  bool get primoEntrant => _$this._primoEntrant;
  set primoEntrant(bool primoEntrant) => _$this._primoEntrant = primoEntrant;

  double _attiranceVieAsso;
  double get attiranceVieAsso => _$this._attiranceVieAsso;
  set attiranceVieAsso(double attiranceVieAsso) =>
      _$this._attiranceVieAsso = attiranceVieAsso;

  double _feteOuCours;
  double get feteOuCours => _$this._feteOuCours;
  set feteOuCours(double feteOuCours) => _$this._feteOuCours = feteOuCours;

  double _aideOuSortir;
  double get aideOuSortir => _$this._aideOuSortir;
  set aideOuSortir(double aideOuSortir) => _$this._aideOuSortir = aideOuSortir;

  double _organisationEvenements;
  double get organisationEvenements => _$this._organisationEvenements;
  set organisationEvenements(double organisationEvenements) =>
      _$this._organisationEvenements = organisationEvenements;

  ListBuilder<String> _goutsMusicaux;
  ListBuilder<String> get goutsMusicaux =>
      _$this._goutsMusicaux ??= new ListBuilder<String>();
  set goutsMusicaux(ListBuilder<String> goutsMusicaux) =>
      _$this._goutsMusicaux = goutsMusicaux;

  TSPYear _year;
  TSPYear get year => _$this._year;
  set year(TSPYear year) => _$this._year = year;

  LieuDeVie _lieuDeVie;
  LieuDeVie get lieuDeVie => _$this._lieuDeVie;
  set lieuDeVie(LieuDeVie lieuDeVie) => _$this._lieuDeVie = lieuDeVie;

  double _groupeOuSeul;
  double get groupeOuSeul => _$this._groupeOuSeul;
  set groupeOuSeul(double groupeOuSeul) => _$this._groupeOuSeul = groupeOuSeul;

  ListBuilder<HoraireDeTravail> _horairesDeTravail;
  ListBuilder<HoraireDeTravail> get horairesDeTravail =>
      _$this._horairesDeTravail ??= new ListBuilder<HoraireDeTravail>();
  set horairesDeTravail(ListBuilder<HoraireDeTravail> horairesDeTravail) =>
      _$this._horairesDeTravail = horairesDeTravail;

  double _enligneOuNon;
  double get enligneOuNon => _$this._enligneOuNon;
  set enligneOuNon(double enligneOuNon) => _$this._enligneOuNon = enligneOuNon;

  ListBuilder<String> _matieresPreferees;
  ListBuilder<String> get matieresPreferees =>
      _$this._matieresPreferees ??= new ListBuilder<String>();
  set matieresPreferees(ListBuilder<String> matieresPreferees) =>
      _$this._matieresPreferees = matieresPreferees;

  BuildUserBuilder();

  BuildUserBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login;
      _name = _$v.name;
      _surname = _$v.surname;
      _email = _$v.email;
      _school = _$v.school;
      _profilePictureLocalPath = _$v.profilePictureLocalPath;
      _associations = _$v.associations?.toBuilder();
      _primoEntrant = _$v.primoEntrant;
      _attiranceVieAsso = _$v.attiranceVieAsso;
      _feteOuCours = _$v.feteOuCours;
      _aideOuSortir = _$v.aideOuSortir;
      _organisationEvenements = _$v.organisationEvenements;
      _goutsMusicaux = _$v.goutsMusicaux?.toBuilder();
      _year = _$v.year;
      _lieuDeVie = _$v.lieuDeVie;
      _groupeOuSeul = _$v.groupeOuSeul;
      _horairesDeTravail = _$v.horairesDeTravail?.toBuilder();
      _enligneOuNon = _$v.enligneOuNon;
      _matieresPreferees = _$v.matieresPreferees?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuildUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuildUser;
  }

  @override
  void update(void Function(BuildUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildUser build() {
    _$BuildUser _$result;
    try {
      _$result = _$v ??
          new _$BuildUser._(
              login: login,
              name: name,
              surname: surname,
              email: email,
              school: school,
              profilePictureLocalPath: profilePictureLocalPath,
              associations: associations.build(),
              primoEntrant: primoEntrant,
              attiranceVieAsso: attiranceVieAsso,
              feteOuCours: feteOuCours,
              aideOuSortir: aideOuSortir,
              organisationEvenements: organisationEvenements,
              goutsMusicaux: goutsMusicaux.build(),
              year: year,
              lieuDeVie: lieuDeVie,
              groupeOuSeul: groupeOuSeul,
              horairesDeTravail: horairesDeTravail.build(),
              enligneOuNon: enligneOuNon,
              matieresPreferees: matieresPreferees.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'associations';
        associations.build();

        _$failedField = 'goutsMusicaux';
        goutsMusicaux.build();

        _$failedField = 'horairesDeTravail';
        horairesDeTravail.build();

        _$failedField = 'matieresPreferees';
        matieresPreferees.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuildUser', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
