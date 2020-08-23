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
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(BinomeStatus)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
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
  BuildBinome deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildBinomeBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(BinomeStatus)) as BinomeStatus;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
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
  final BinomeStatus status;
  @override
  final int score;
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

  factory _$BuildBinome([void Function(BuildBinomeBuilder) updates]) =>
      (new BuildBinomeBuilder()..update(updates)).build();

  _$BuildBinome._(
      {this.status,
      this.score,
      this.year,
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
    if (status == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'status');
    }
    if (score == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'score');
    }
    if (year == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'year');
    }
    if (groupeOuSeul == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'groupeOuSeul');
    }
    if (lieuDeVie == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'lieuDeVie');
    }
    if (horairesDeTravail == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'horairesDeTravail');
    }
    if (enligneOuNon == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'enligneOuNon');
    }
    if (matieresPreferees == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'matieresPreferees');
    }
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'email');
    }
    if (school == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'school');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildBinome', 'associations');
    }
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
        status == other.status &&
        score == other.score &&
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
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                0,
                                                                status
                                                                    .hashCode),
                                                            score.hashCode),
                                                        year.hashCode),
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
    return (newBuiltValueToStringHelper('BuildBinome')
          ..add('status', status)
          ..add('score', score)
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

class BuildBinomeBuilder implements Builder<BuildBinome, BuildBinomeBuilder> {
  _$BuildBinome _$v;

  BinomeStatus _status;
  BinomeStatus get status => _$this._status;
  set status(BinomeStatus status) => _$this._status = status;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

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

  BuildBinomeBuilder();

  BuildBinomeBuilder get _$this {
    if (_$v != null) {
      _status = _$v.status;
      _score = _$v.score;
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
  void replace(BuildBinome other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
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
              status: status,
              score: score,
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
            'BuildBinome', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
