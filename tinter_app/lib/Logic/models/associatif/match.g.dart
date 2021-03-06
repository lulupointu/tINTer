// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MatchStatus _$heIgnoredYou = const MatchStatus._('heIgnoredYou');
const MatchStatus _$ignored = const MatchStatus._('ignored');
const MatchStatus _$none = const MatchStatus._('none');
const MatchStatus _$liked = const MatchStatus._('liked');
const MatchStatus _$matched = const MatchStatus._('matched');
const MatchStatus _$youAskedParrain = const MatchStatus._('youAskedParrain');
const MatchStatus _$heAskedParrain = const MatchStatus._('heAskedParrain');
const MatchStatus _$parrainAccepted = const MatchStatus._('parrainAccepted');
const MatchStatus _$parrainHeRefused = const MatchStatus._('parrainHeRefused');
const MatchStatus _$parrainYouRefused =
    const MatchStatus._('parrainYouRefused');

MatchStatus _$matchStatusValueOf(String name) {
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
    case 'youAskedParrain':
      return _$youAskedParrain;
    case 'heAskedParrain':
      return _$heAskedParrain;
    case 'parrainAccepted':
      return _$parrainAccepted;
    case 'parrainHeRefused':
      return _$parrainHeRefused;
    case 'parrainYouRefused':
      return _$parrainYouRefused;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<MatchStatus> _$matchStatusValues =
    new BuiltSet<MatchStatus>(const <MatchStatus>[
  _$heIgnoredYou,
  _$ignored,
  _$none,
  _$liked,
  _$matched,
  _$youAskedParrain,
  _$heAskedParrain,
  _$parrainAccepted,
  _$parrainHeRefused,
  _$parrainYouRefused,
]);

Serializer<BuildMatch> _$buildMatchSerializer = new _$BuildMatchSerializer();
Serializer<MatchStatus> _$matchStatusSerializer = new _$MatchStatusSerializer();

class _$BuildMatchSerializer implements StructuredSerializer<BuildMatch> {
  @override
  final Iterable<Type> types = const [BuildMatch, _$BuildMatch];
  @override
  final String wireName = 'BuildMatch';

  @override
  Iterable<Object> serialize(Serializers serializers, BuildMatch object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'statusAssociatif',
      serializers.serialize(object.statusAssociatif,
          specifiedType: const FullType(MatchStatus)),
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
  BuildMatch deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildMatchBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'statusAssociatif':
          result.statusAssociatif = serializers.deserialize(value,
              specifiedType: const FullType(MatchStatus)) as MatchStatus;
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

class _$MatchStatusSerializer implements PrimitiveSerializer<MatchStatus> {
  @override
  final Iterable<Type> types = const <Type>[MatchStatus];
  @override
  final String wireName = 'MatchStatus';

  @override
  Object serialize(Serializers serializers, MatchStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  MatchStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MatchStatus.valueOf(serialized as String);
}

class _$BuildMatch extends BuildMatch {
  @override
  final MatchStatus statusAssociatif;
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

  factory _$BuildMatch([void Function(BuildMatchBuilder) updates]) =>
      (new BuildMatchBuilder()..update(updates)).build();

  _$BuildMatch._(
      {this.statusAssociatif,
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
        statusAssociatif, 'BuildMatch', 'statusAssociatif');
    BuiltValueNullFieldError.checkNotNull(score, 'BuildMatch', 'score');
    BuiltValueNullFieldError.checkNotNull(login, 'BuildMatch', 'login');
    BuiltValueNullFieldError.checkNotNull(name, 'BuildMatch', 'name');
    BuiltValueNullFieldError.checkNotNull(surname, 'BuildMatch', 'surname');
    BuiltValueNullFieldError.checkNotNull(email, 'BuildMatch', 'email');
    BuiltValueNullFieldError.checkNotNull(school, 'BuildMatch', 'school');
    BuiltValueNullFieldError.checkNotNull(
        associations, 'BuildMatch', 'associations');
    BuiltValueNullFieldError.checkNotNull(
        primoEntrant, 'BuildMatch', 'primoEntrant');
    BuiltValueNullFieldError.checkNotNull(
        attiranceVieAsso, 'BuildMatch', 'attiranceVieAsso');
    BuiltValueNullFieldError.checkNotNull(
        feteOuCours, 'BuildMatch', 'feteOuCours');
    BuiltValueNullFieldError.checkNotNull(
        aideOuSortir, 'BuildMatch', 'aideOuSortir');
    BuiltValueNullFieldError.checkNotNull(
        organisationEvenements, 'BuildMatch', 'organisationEvenements');
    BuiltValueNullFieldError.checkNotNull(
        goutsMusicaux, 'BuildMatch', 'goutsMusicaux');
    BuiltValueNullFieldError.checkNotNull(year, 'BuildMatch', 'year');
    BuiltValueNullFieldError.checkNotNull(lieuDeVie, 'BuildMatch', 'lieuDeVie');
    BuiltValueNullFieldError.checkNotNull(
        groupeOuSeul, 'BuildMatch', 'groupeOuSeul');
    BuiltValueNullFieldError.checkNotNull(
        horairesDeTravail, 'BuildMatch', 'horairesDeTravail');
    BuiltValueNullFieldError.checkNotNull(
        enligneOuNon, 'BuildMatch', 'enligneOuNon');
    BuiltValueNullFieldError.checkNotNull(
        matieresPreferees, 'BuildMatch', 'matieresPreferees');
  }

  @override
  BuildMatch rebuild(void Function(BuildMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildMatchBuilder toBuilder() => new BuildMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildMatch &&
        statusAssociatif == other.statusAssociatif &&
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
                                                                            $jc($jc($jc(0, statusAssociatif.hashCode), score.hashCode),
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
    return (newBuiltValueToStringHelper('BuildMatch')
          ..add('statusAssociatif', statusAssociatif)
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

class BuildMatchBuilder implements Builder<BuildMatch, BuildMatchBuilder> {
  _$BuildMatch _$v;

  MatchStatus _statusAssociatif;
  MatchStatus get statusAssociatif => _$this._statusAssociatif;
  set statusAssociatif(MatchStatus statusAssociatif) =>
      _$this._statusAssociatif = statusAssociatif;

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

  BuildMatchBuilder();

  BuildMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _statusAssociatif = $v.statusAssociatif;
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
  void replace(BuildMatch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuildMatch;
  }

  @override
  void update(void Function(BuildMatchBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildMatch build() {
    _$BuildMatch _$result;
    try {
      _$result = _$v ??
          new _$BuildMatch._(
              statusAssociatif: BuiltValueNullFieldError.checkNotNull(
                  statusAssociatif, 'BuildMatch', 'statusAssociatif'),
              score: BuiltValueNullFieldError.checkNotNull(
                  score, 'BuildMatch', 'score'),
              login: BuiltValueNullFieldError.checkNotNull(
                  login, 'BuildMatch', 'login'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'BuildMatch', 'name'),
              surname: BuiltValueNullFieldError.checkNotNull(
                  surname, 'BuildMatch', 'surname'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'BuildMatch', 'email'),
              school: BuiltValueNullFieldError.checkNotNull(
                  school, 'BuildMatch', 'school'),
              profilePictureLocalPath: profilePictureLocalPath,
              associations: associations.build(),
              primoEntrant: BuiltValueNullFieldError.checkNotNull(
                  primoEntrant, 'BuildMatch', 'primoEntrant'),
              attiranceVieAsso: BuiltValueNullFieldError.checkNotNull(
                  attiranceVieAsso, 'BuildMatch', 'attiranceVieAsso'),
              feteOuCours: BuiltValueNullFieldError.checkNotNull(
                  feteOuCours, 'BuildMatch', 'feteOuCours'),
              aideOuSortir: BuiltValueNullFieldError.checkNotNull(aideOuSortir, 'BuildMatch', 'aideOuSortir'),
              organisationEvenements: BuiltValueNullFieldError.checkNotNull(organisationEvenements, 'BuildMatch', 'organisationEvenements'),
              goutsMusicaux: goutsMusicaux.build(),
              year: BuiltValueNullFieldError.checkNotNull(year, 'BuildMatch', 'year'),
              lieuDeVie: BuiltValueNullFieldError.checkNotNull(lieuDeVie, 'BuildMatch', 'lieuDeVie'),
              groupeOuSeul: BuiltValueNullFieldError.checkNotNull(groupeOuSeul, 'BuildMatch', 'groupeOuSeul'),
              horairesDeTravail: horairesDeTravail.build(),
              enligneOuNon: BuiltValueNullFieldError.checkNotNull(enligneOuNon, 'BuildMatch', 'enligneOuNon'),
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
            'BuildMatch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
