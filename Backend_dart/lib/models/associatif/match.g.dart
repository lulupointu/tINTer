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
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(MatchStatus)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
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
  BuildMatch deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildMatchBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(MatchStatus)) as MatchStatus;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
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
  final MatchStatus status;
  @override
  final int score;
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

  factory _$BuildMatch([void Function(BuildMatchBuilder) updates]) =>
      (new BuildMatchBuilder()..update(updates)).build();

  _$BuildMatch._(
      {this.status,
      this.score,
      this.primoEntrant,
      this.attiranceVieAsso,
      this.feteOuCours,
      this.aideOuSortir,
      this.organisationEvenements,
      this.goutsMusicaux,
      this.login,
      this.name,
      this.surname,
      this.email,
      this.school,
      this.profilePictureLocalPath,
      this.associations})
      : super._() {
    if (status == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'status');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'score');
    }
    if (primoEntrant == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'primoEntrant');
    }
    if (attiranceVieAsso == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'attiranceVieAsso');
    }
    if (feteOuCours == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'feteOuCours');
    }
    if (aideOuSortir == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'aideOuSortir');
    }
    if (organisationEvenements == null) {
      throw new BuiltValueNullFieldError(
          'BuildMatch', 'organisationEvenements');
    }
    if (goutsMusicaux == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'goutsMusicaux');
    }
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'email');
    }
    if (school == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'school');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildMatch', 'associations');
    }
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
        status == other.status &&
        score == other.score &&
        primoEntrant == other.primoEntrant &&
        attiranceVieAsso == other.attiranceVieAsso &&
        feteOuCours == other.feteOuCours &&
        aideOuSortir == other.aideOuSortir &&
        organisationEvenements == other.organisationEvenements &&
        goutsMusicaux == other.goutsMusicaux &&
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
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                0,
                                                                status
                                                                    .hashCode),
                                                            score.hashCode),
                                                        primoEntrant.hashCode),
                                                    attiranceVieAsso.hashCode),
                                                feteOuCours.hashCode),
                                            aideOuSortir.hashCode),
                                        organisationEvenements.hashCode),
                                    goutsMusicaux.hashCode),
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
    return (newBuiltValueToStringHelper('BuildMatch')
          ..add('status', status)
          ..add('score', score)
          ..add('primoEntrant', primoEntrant)
          ..add('attiranceVieAsso', attiranceVieAsso)
          ..add('feteOuCours', feteOuCours)
          ..add('aideOuSortir', aideOuSortir)
          ..add('organisationEvenements', organisationEvenements)
          ..add('goutsMusicaux', goutsMusicaux)
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

class BuildMatchBuilder implements Builder<BuildMatch, BuildMatchBuilder> {
  _$BuildMatch _$v;

  MatchStatus _status;
  MatchStatus get status => _$this._status;
  set status(MatchStatus status) => _$this._status = status;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

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

  BuildMatchBuilder();

  BuildMatchBuilder get _$this {
    if (_$v != null) {
      _status = _$v.status;
      _score = _$v.score;
      _primoEntrant = _$v.primoEntrant;
      _attiranceVieAsso = _$v.attiranceVieAsso;
      _feteOuCours = _$v.feteOuCours;
      _aideOuSortir = _$v.aideOuSortir;
      _organisationEvenements = _$v.organisationEvenements;
      _goutsMusicaux = _$v.goutsMusicaux?.toBuilder();
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
  void replace(BuildMatch other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
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
              status: status,
              score: score,
              primoEntrant: primoEntrant,
              attiranceVieAsso: attiranceVieAsso,
              feteOuCours: feteOuCours,
              aideOuSortir: aideOuSortir,
              organisationEvenements: organisationEvenements,
              goutsMusicaux: goutsMusicaux.build(),
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
        _$failedField = 'goutsMusicaux';
        goutsMusicaux.build();

        _$failedField = 'associations';
        associations.build();
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
