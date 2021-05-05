// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binome_pair_match.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BinomePairMatchStatus _$heIgnoredYou =
    const BinomePairMatchStatus._('heIgnoredYou');
const BinomePairMatchStatus _$ignored =
    const BinomePairMatchStatus._('ignored');
const BinomePairMatchStatus _$none = const BinomePairMatchStatus._('none');
const BinomePairMatchStatus _$liked = const BinomePairMatchStatus._('liked');
const BinomePairMatchStatus _$matched =
    const BinomePairMatchStatus._('matched');
const BinomePairMatchStatus _$youAskedBinomePairMatch =
    const BinomePairMatchStatus._('youAskedBinomePairMatch');
const BinomePairMatchStatus _$heAskedBinomePairMatch =
    const BinomePairMatchStatus._('heAskedBinomePairMatch');
const BinomePairMatchStatus _$binomePairMatchAccepted =
    const BinomePairMatchStatus._('binomePairMatchAccepted');
const BinomePairMatchStatus _$binomePairMatchHeRefused =
    const BinomePairMatchStatus._('binomePairMatchHeRefused');
const BinomePairMatchStatus _$binomePairMatchYouRefused =
    const BinomePairMatchStatus._('binomePairMatchYouRefused');

BinomePairMatchStatus _$binomePairMatchStatusValueOf(String name) {
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
    case 'youAskedBinomePairMatch':
      return _$youAskedBinomePairMatch;
    case 'heAskedBinomePairMatch':
      return _$heAskedBinomePairMatch;
    case 'binomePairMatchAccepted':
      return _$binomePairMatchAccepted;
    case 'binomePairMatchHeRefused':
      return _$binomePairMatchHeRefused;
    case 'binomePairMatchYouRefused':
      return _$binomePairMatchYouRefused;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<BinomePairMatchStatus> _$binomePairMatchStatusValues =
    new BuiltSet<BinomePairMatchStatus>(const <BinomePairMatchStatus>[
  _$heIgnoredYou,
  _$ignored,
  _$none,
  _$liked,
  _$matched,
  _$youAskedBinomePairMatch,
  _$heAskedBinomePairMatch,
  _$binomePairMatchAccepted,
  _$binomePairMatchHeRefused,
  _$binomePairMatchYouRefused,
]);

Serializer<BuildBinomePairMatch> _$buildBinomePairMatchSerializer =
    new _$BuildBinomePairMatchSerializer();
Serializer<BinomePairMatchStatus> _$binomePairMatchStatusSerializer =
    new _$BinomePairMatchStatusSerializer();

class _$BuildBinomePairMatchSerializer
    implements StructuredSerializer<BuildBinomePairMatch> {
  @override
  final Iterable<Type> types = const [
    BuildBinomePairMatch,
    _$BuildBinomePairMatch
  ];
  @override
  final String wireName = 'BuildBinomePairMatch';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuildBinomePairMatch object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(BinomePairMatchStatus)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'binomePairId',
      serializers.serialize(object.binomePairId,
          specifiedType: const FullType(int)),
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
      'otherLogin',
      serializers.serialize(object.otherLogin,
          specifiedType: const FullType(String)),
      'otherName',
      serializers.serialize(object.otherName,
          specifiedType: const FullType(String)),
      'otherSurname',
      serializers.serialize(object.otherSurname,
          specifiedType: const FullType(String)),
      'otherEmail',
      serializers.serialize(object.otherEmail,
          specifiedType: const FullType(String)),
      'associations',
      serializers.serialize(object.associations,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Association)])),
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
    value = object.lieuDeVie;
    if (value != null) {
      result
        ..add('lieuDeVie')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(LieuDeVie)));
    }
    return result;
  }

  @override
  BuildBinomePairMatch deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildBinomePairMatchBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'status':
          result.status = serializers.deserialize(value,
                  specifiedType: const FullType(BinomePairMatchStatus))
              as BinomePairMatchStatus;
          break;
        case 'score':
          result.score = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'binomePairId':
          result.binomePairId = serializers.deserialize(value,
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
        case 'otherLogin':
          result.otherLogin = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherName':
          result.otherName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherSurname':
          result.otherSurname = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'otherEmail':
          result.otherEmail = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'associations':
          result.associations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Association)]))
              as BuiltList<Object>);
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

class _$BinomePairMatchStatusSerializer
    implements PrimitiveSerializer<BinomePairMatchStatus> {
  @override
  final Iterable<Type> types = const <Type>[BinomePairMatchStatus];
  @override
  final String wireName = 'BinomePairMatchStatus';

  @override
  Object serialize(Serializers serializers, BinomePairMatchStatus object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  BinomePairMatchStatus deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BinomePairMatchStatus.valueOf(serialized as String);
}

class _$BuildBinomePairMatch extends BuildBinomePairMatch {
  @override
  final BinomePairMatchStatus status;
  @override
  final int score;
  @override
  final int binomePairId;
  @override
  final String login;
  @override
  final String name;
  @override
  final String surname;
  @override
  final String email;
  @override
  final String otherLogin;
  @override
  final String otherName;
  @override
  final String otherSurname;
  @override
  final String otherEmail;
  @override
  final BuiltList<Association> associations;
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

  factory _$BuildBinomePairMatch(
          [void Function(BuildBinomePairMatchBuilder) updates]) =>
      (new BuildBinomePairMatchBuilder()..update(updates)).build();

  _$BuildBinomePairMatch._(
      {this.status,
      this.score,
      this.binomePairId,
      this.login,
      this.name,
      this.surname,
      this.email,
      this.otherLogin,
      this.otherName,
      this.otherSurname,
      this.otherEmail,
      this.associations,
      this.lieuDeVie,
      this.groupeOuSeul,
      this.horairesDeTravail,
      this.enligneOuNon,
      this.matieresPreferees})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        status, 'BuildBinomePairMatch', 'status');
    BuiltValueNullFieldError.checkNotNull(
        score, 'BuildBinomePairMatch', 'score');
    BuiltValueNullFieldError.checkNotNull(
        binomePairId, 'BuildBinomePairMatch', 'binomePairId');
    BuiltValueNullFieldError.checkNotNull(
        login, 'BuildBinomePairMatch', 'login');
    BuiltValueNullFieldError.checkNotNull(name, 'BuildBinomePairMatch', 'name');
    BuiltValueNullFieldError.checkNotNull(
        surname, 'BuildBinomePairMatch', 'surname');
    BuiltValueNullFieldError.checkNotNull(
        email, 'BuildBinomePairMatch', 'email');
    BuiltValueNullFieldError.checkNotNull(
        otherLogin, 'BuildBinomePairMatch', 'otherLogin');
    BuiltValueNullFieldError.checkNotNull(
        otherName, 'BuildBinomePairMatch', 'otherName');
    BuiltValueNullFieldError.checkNotNull(
        otherSurname, 'BuildBinomePairMatch', 'otherSurname');
    BuiltValueNullFieldError.checkNotNull(
        otherEmail, 'BuildBinomePairMatch', 'otherEmail');
    BuiltValueNullFieldError.checkNotNull(
        associations, 'BuildBinomePairMatch', 'associations');
    BuiltValueNullFieldError.checkNotNull(
        groupeOuSeul, 'BuildBinomePairMatch', 'groupeOuSeul');
    BuiltValueNullFieldError.checkNotNull(
        horairesDeTravail, 'BuildBinomePairMatch', 'horairesDeTravail');
    BuiltValueNullFieldError.checkNotNull(
        enligneOuNon, 'BuildBinomePairMatch', 'enligneOuNon');
    BuiltValueNullFieldError.checkNotNull(
        matieresPreferees, 'BuildBinomePairMatch', 'matieresPreferees');
  }

  @override
  BuildBinomePairMatch rebuild(
          void Function(BuildBinomePairMatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildBinomePairMatchBuilder toBuilder() =>
      new BuildBinomePairMatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildBinomePairMatch &&
        status == other.status &&
        score == other.score &&
        binomePairId == other.binomePairId &&
        login == other.login &&
        name == other.name &&
        surname == other.surname &&
        email == other.email &&
        otherLogin == other.otherLogin &&
        otherName == other.otherName &&
        otherSurname == other.otherSurname &&
        otherEmail == other.otherEmail &&
        associations == other.associations &&
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
                                                                        0,
                                                                        status
                                                                            .hashCode),
                                                                    score
                                                                        .hashCode),
                                                                binomePairId
                                                                    .hashCode),
                                                            login.hashCode),
                                                        name.hashCode),
                                                    surname.hashCode),
                                                email.hashCode),
                                            otherLogin.hashCode),
                                        otherName.hashCode),
                                    otherSurname.hashCode),
                                otherEmail.hashCode),
                            associations.hashCode),
                        lieuDeVie.hashCode),
                    groupeOuSeul.hashCode),
                horairesDeTravail.hashCode),
            enligneOuNon.hashCode),
        matieresPreferees.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuildBinomePairMatch')
          ..add('status', status)
          ..add('score', score)
          ..add('binomePairId', binomePairId)
          ..add('login', login)
          ..add('name', name)
          ..add('surname', surname)
          ..add('email', email)
          ..add('otherLogin', otherLogin)
          ..add('otherName', otherName)
          ..add('otherSurname', otherSurname)
          ..add('otherEmail', otherEmail)
          ..add('associations', associations)
          ..add('lieuDeVie', lieuDeVie)
          ..add('groupeOuSeul', groupeOuSeul)
          ..add('horairesDeTravail', horairesDeTravail)
          ..add('enligneOuNon', enligneOuNon)
          ..add('matieresPreferees', matieresPreferees))
        .toString();
  }
}

class BuildBinomePairMatchBuilder
    implements Builder<BuildBinomePairMatch, BuildBinomePairMatchBuilder> {
  _$BuildBinomePairMatch _$v;

  BinomePairMatchStatus _status;
  BinomePairMatchStatus get status => _$this._status;
  set status(BinomePairMatchStatus status) => _$this._status = status;

  int _score;
  int get score => _$this._score;
  set score(int score) => _$this._score = score;

  int _binomePairId;
  int get binomePairId => _$this._binomePairId;
  set binomePairId(int binomePairId) => _$this._binomePairId = binomePairId;

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

  String _otherLogin;
  String get otherLogin => _$this._otherLogin;
  set otherLogin(String otherLogin) => _$this._otherLogin = otherLogin;

  String _otherName;
  String get otherName => _$this._otherName;
  set otherName(String otherName) => _$this._otherName = otherName;

  String _otherSurname;
  String get otherSurname => _$this._otherSurname;
  set otherSurname(String otherSurname) => _$this._otherSurname = otherSurname;

  String _otherEmail;
  String get otherEmail => _$this._otherEmail;
  set otherEmail(String otherEmail) => _$this._otherEmail = otherEmail;

  ListBuilder<Association> _associations;
  ListBuilder<Association> get associations =>
      _$this._associations ??= new ListBuilder<Association>();
  set associations(ListBuilder<Association> associations) =>
      _$this._associations = associations;

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

  BuildBinomePairMatchBuilder();

  BuildBinomePairMatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _score = $v.score;
      _binomePairId = $v.binomePairId;
      _login = $v.login;
      _name = $v.name;
      _surname = $v.surname;
      _email = $v.email;
      _otherLogin = $v.otherLogin;
      _otherName = $v.otherName;
      _otherSurname = $v.otherSurname;
      _otherEmail = $v.otherEmail;
      _associations = $v.associations.toBuilder();
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
  void replace(BuildBinomePairMatch other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BuildBinomePairMatch;
  }

  @override
  void update(void Function(BuildBinomePairMatchBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildBinomePairMatch build() {
    _$BuildBinomePairMatch _$result;
    try {
      _$result = _$v ??
          new _$BuildBinomePairMatch._(
              status: BuiltValueNullFieldError.checkNotNull(
                  status, 'BuildBinomePairMatch', 'status'),
              score: BuiltValueNullFieldError.checkNotNull(
                  score, 'BuildBinomePairMatch', 'score'),
              binomePairId: BuiltValueNullFieldError.checkNotNull(
                  binomePairId, 'BuildBinomePairMatch', 'binomePairId'),
              login: BuiltValueNullFieldError.checkNotNull(
                  login, 'BuildBinomePairMatch', 'login'),
              name: BuiltValueNullFieldError.checkNotNull(
                  name, 'BuildBinomePairMatch', 'name'),
              surname: BuiltValueNullFieldError.checkNotNull(
                  surname, 'BuildBinomePairMatch', 'surname'),
              email: BuiltValueNullFieldError.checkNotNull(
                  email, 'BuildBinomePairMatch', 'email'),
              otherLogin: BuiltValueNullFieldError.checkNotNull(
                  otherLogin, 'BuildBinomePairMatch', 'otherLogin'),
              otherName:
                  BuiltValueNullFieldError.checkNotNull(otherName, 'BuildBinomePairMatch', 'otherName'),
              otherSurname: BuiltValueNullFieldError.checkNotNull(otherSurname, 'BuildBinomePairMatch', 'otherSurname'),
              otherEmail: BuiltValueNullFieldError.checkNotNull(otherEmail, 'BuildBinomePairMatch', 'otherEmail'),
              associations: associations.build(),
              lieuDeVie: lieuDeVie,
              groupeOuSeul: BuiltValueNullFieldError.checkNotNull(groupeOuSeul, 'BuildBinomePairMatch', 'groupeOuSeul'),
              horairesDeTravail: horairesDeTravail.build(),
              enligneOuNon: BuiltValueNullFieldError.checkNotNull(enligneOuNon, 'BuildBinomePairMatch', 'enligneOuNon'),
              matieresPreferees: matieresPreferees.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'associations';
        associations.build();

        _$failedField = 'horairesDeTravail';
        horairesDeTravail.build();

        _$failedField = 'matieresPreferees';
        matieresPreferees.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuildBinomePairMatch', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
