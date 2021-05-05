// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binome.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BinomeStatus _$heIgnoredYou = const BinomeStatus._('heIgnoredYou');
const BinomeStatus _$ignored = const BinomeStatus._('ignored');
const BinomeStatus _$none = const BinomeStatus._('none');
const BinomeStatus _$liked = const BinomeStatus._('liked');
const BinomeStatus _$matched = const BinomeStatus._('matched');
const BinomeStatus _$youAskedBinome = const BinomeStatus._('youAskedBinome');
const BinomeStatus _$heAskedBinome = const BinomeStatus._('heAskedBinome');
const BinomeStatus _$binomeAccepted = const BinomeStatus._('binomeAccepted');
const BinomeStatus _$binomeHeRefused = const BinomeStatus._('binomeHeRefused');
const BinomeStatus _$binomeYouRefused =
    const BinomeStatus._('binomeYouRefused');

BinomeStatus _$binomeStatusValueOf(String name) {
  switch (name) {
    case 'heIgnoredYou':
      return _$heIgnoredYou;
    case 'ignored':
      return _$ignored;
    case 'none':
      return _$none;
    case 'liked':
      return _$liked;
    case 'matched':
      return _$matched;
    case 'youAskedBinome':
      return _$youAskedBinome;
    case 'heAskedBinome':
      return _$heAskedBinome;
    case 'binomeAccepted':
      return _$binomeAccepted;
    case 'binomeHeRefused':
      return _$binomeHeRefused;
    case 'binomeYouRefused':
      return _$binomeYouRefused;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<BinomeStatus> _$binomeStatusValues =
    new BuiltSet<BinomeStatus>(const <BinomeStatus>[
  _$heIgnoredYou,
  _$ignored,
  _$none,
  _$liked,
  _$matched,
  _$youAskedBinome,
  _$heAskedBinome,
  _$binomeAccepted,
  _$binomeHeRefused,
  _$binomeYouRefused,
]);

Serializer<BuildBinome> _$buildBinomeSerializer = new _$BuildBinomeSerializer();
Serializer<BinomeStatus> _$binomeStatusSerializer =
    new _$BinomeStatusSerializer();

class _$BuildBinomeSerializer implements StructuredSerializer<BuildBinome> {
  @override
  final Iterable<Type> types = const [BuildBinome, _$BuildBinome];
  @override
  final String wireName = 'BuildBinome';

  @override
  Iterable<Object> serialize(Serializers serializers, BuildBinome object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'statusScolaire',
      serializers.serialize(object.statusScolaire,
          specifiedType: const FullType(BinomeStatus)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
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
    Object value;
    value = object.profilePictureLocalPath;
    if (value != null) {
      result
        ..add('profilePictureLocalPath')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BuildBinome deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildBinomeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'statusScolaire':
          result.statusScolaire = serializers.deserialize(value,
              specifiedType: const FullType(BinomeStatus)) as BinomeStatus;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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

class _$BinomeStatusSerializer implements PrimitiveSerializer<BinomeStatus> {
  @override
  final Iterable<Type> types = const <Type>[BinomeStatus];
  @override
  final String wireName = 'BinomeStatus';

  @override
  Object serialize(Serializers serializers, BinomeStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  BinomeStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BinomeStatus.valueOf(serialized as String);
}

class _$BuildBinome extends BuildBinome {
  @override
  final BinomeStatus statusScolaire;
  @override
  final int score;
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

  factory _$BuildBinome([void Function(BuildBinomeBuilder) updates]) =>
      (new BuildBinomeBuilder()..update(updates)).build();

  _$BuildBinome._(
      {this.statusScolaire,
      this.score,
      this.login,
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
    BuiltValueNullFieldError.checkNotNull(
        statusScolaire, 'BuildBinome', 'statusScolaire');
    BuiltValueNullFieldError.checkNotNull(score, 'BuildBinome', 'score');
    BuiltValueNullFieldError.checkNotNull(login, 'BuildBinome', 'login');
    BuiltValueNullFieldError.checkNotNull(name, 'BuildBinome', 'name');
    BuiltValueNullFieldError.checkNotNull(surname, 'BuildBinome', 'surname');
    BuiltValueNullFieldError.checkNotNull(email, 'BuildBinome', 'email');
    BuiltValueNullFieldError.checkNotNull(school, 'BuildBinome', 'school');
    BuiltValueNullFieldError.checkNotNull(
        associations, 'BuildBinome', 'associations');
    BuiltValueNullFieldError.checkNotNull(
        primoEntrant, 'BuildBinome', 'primoEntrant');
    BuiltValueNullFieldError.checkNotNull(
        attiranceVieAsso, 'BuildBinome', 'attiranceVieAsso');
    BuiltValueNullFieldError.checkNotNull(
        feteOuCours, 'BuildBinome', 'feteOuCours');
    BuiltValueNullFieldError.checkNotNull(
        aideOuSortir, 'BuildBinome', 'aideOuSortir');
    BuiltValueNullFieldError.checkNotNull(
        organisationEvenements, 'BuildBinome', 'organisationEvenements');
    BuiltValueNullFieldError.checkNotNull(
        goutsMusicaux, 'BuildBinome', 'goutsMusicaux');
    BuiltValueNullFieldError.checkNotNull(year, 'BuildBinome', 'year');
    BuiltValueNullFieldError.checkNotNull(
        lieuDeVie, 'BuildBinome', 'lieuDeVie');
    BuiltValueNullFieldError.checkNotNull(
        groupeOuSeul, 'BuildBinome', 'groupeOuSeul');
    BuiltValueNullFieldError.checkNotNull(
        horairesDeTravail, 'BuildBinome', 'horairesDeTravail');
    BuiltValueNullFieldError.checkNotNull(
        enligneOuNon, 'BuildBinome', 'enligneOuNon');
    BuiltValueNullFieldError.checkNotNull(
        matieresPreferees, 'BuildBinome', 'matieresPreferees');
  }

  @override
  BuildBinome rebuild(void Function(BuildBinomeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildBinomeBuilder toBuilder() => new BuildBinomeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildBinome &&
        statusScolaire == other.statusScolaire &&
        score == other.score &&
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
                                                                            $jc($jc($jc(0, statusScolaire.hashCode), score.hashCode),
                                                                                login.hashCode),
                                                                            name.hashCode),
                                                                        surname.hashCode),
                                                                    email.hashCode),
                                                                school.hashCode),
                                                            profilePictureLocalPath.hashCode),
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
    return (newBuiltValueToStringHelper('BuildBinome')
          ..add('statusScolaire', statusScolaire)
          ..add('score', score)
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

class BuildBinomeBuilder implements Builder<BuildBinome, BuildBinomeBuilder> {
  _$BuildBinome _$v;

  BinomeStatus _statusScolaire;
  BinomeStatus get statusScolaire => _$this._statusScolaire;
  set statusScolaire(BinomeStatus statusScolaire) =>
      _$this._statusScolaire = statusScolaire;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

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

  BuildBinomeBuilder();

  BuildBinomeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusScolaire = $v.statusScolaire;
      _score = $v.score;
      _login = $v.login;
      _name = $v.name;
      _surname = $v.surname;
      _email = $v.email;
      _school = $v.school;
      _profilePictureLocalPath = $v.profilePictureLocalPath;
      _associations = $v.associations.toBuilder();
      _primoEntrant = $v.primoEntrant;
      _attiranceVieAsso = $v.attiranceVieAsso;
      _feteOuCours = $v.feteOuCours;
      _aideOuSortir = $v.aideOuSortir;
      _organisationEvenements = $v.organisationEvenements;
      _goutsMusicaux = $v.goutsMusicaux.toBuilder();
      _year = $v.year;
      _lieuDeVie = $v.lieuDeVie;
      _groupeOuSeul = $v.groupeOuSeul;
      _horairesDeTravail = $v.horairesDeTravail.toBuilder();
      _enligneOuNon = $v.enligneOuNon;
      _matieresPreferees = $v.matieresPreferees.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuildBinome other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuildBinome;
  }

  @override
  void update(void Function(BuildBinomeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildBinome build() {
    _$BuildBinome _$result;
    try {
      _$result = _$v ??
          new _$BuildBinome._(
              statusScolaire: BuiltValueNullFieldError.checkNotNull(
                  statusScolaire, 'BuildBinome', 'statusScolaire'),
              score: BuiltValueNullFieldError.checkNotNull(
                  score, 'BuildBinome', 'score'),
              login: BuiltValueNullFieldError.checkNotNull(
                  login, 'BuildBinome', 'login'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'BuildBinome', 'name'),
              surname: BuiltValueNullFieldError.checkNotNull(
                  surname, 'BuildBinome', 'surname'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'BuildBinome', 'email'),
              school: BuiltValueNullFieldError.checkNotNull(
                  school, 'BuildBinome', 'school'),
              profilePictureLocalPath: profilePictureLocalPath,
              associations: associations.build(),
              primoEntrant: BuiltValueNullFieldError.checkNotNull(
                  primoEntrant, 'BuildBinome', 'primoEntrant'),
              attiranceVieAsso: BuiltValueNullFieldError.checkNotNull(
                  attiranceVieAsso, 'BuildBinome', 'attiranceVieAsso'),
              feteOuCours:
                  BuiltValueNullFieldError.checkNotNull(feteOuCours, 'BuildBinome', 'feteOuCours'),
              aideOuSortir: BuiltValueNullFieldError.checkNotNull(aideOuSortir, 'BuildBinome', 'aideOuSortir'),
              organisationEvenements: BuiltValueNullFieldError.checkNotNull(organisationEvenements, 'BuildBinome', 'organisationEvenements'),
              goutsMusicaux: goutsMusicaux.build(),
              year: BuiltValueNullFieldError.checkNotNull(year, 'BuildBinome', 'year'),
              lieuDeVie: BuiltValueNullFieldError.checkNotNull(lieuDeVie, 'BuildBinome', 'lieuDeVie'),
              groupeOuSeul: BuiltValueNullFieldError.checkNotNull(groupeOuSeul, 'BuildBinome', 'groupeOuSeul'),
              horairesDeTravail: horairesDeTravail.build(),
              enligneOuNon: BuiltValueNullFieldError.checkNotNull(enligneOuNon, 'BuildBinome', 'enligneOuNon'),
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
            'BuildBinome', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
