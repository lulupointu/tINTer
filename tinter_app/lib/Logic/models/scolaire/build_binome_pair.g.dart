// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'build_binome_pair.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BuildBinomePair> _$buildBinomePairSerializer =
    new _$BuildBinomePairSerializer();

class _$BuildBinomePairSerializer
    implements StructuredSerializer<BuildBinomePair> {
  @override
  final Iterable<Type> types = const [BuildBinomePair, _$BuildBinomePair];
  @override
  final String wireName = 'BuildBinomePair';

  @override
  Iterable<Object> serialize(Serializers serializers, BuildBinomePair object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
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
    if (object.lieuDeVie != null) {
      result
        ..add('lieuDeVie')
        ..add(serializers.serialize(object.lieuDeVie,
            specifiedType: const FullType(LieuDeVie)));
    }
    return result;
  }

  @override
  BuildBinomePair deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildBinomePairBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
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

class _$BuildBinomePair extends BuildBinomePair {
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

  factory _$BuildBinomePair([void Function(BuildBinomePairBuilder) updates]) =>
      (new BuildBinomePairBuilder()..update(updates)).build();

  _$BuildBinomePair._(
      {this.binomePairId,
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
    if (binomePairId == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'binomePairId');
    }
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'email');
    }
    if (otherLogin == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'otherLogin');
    }
    if (otherName == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'otherName');
    }
    if (otherSurname == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'otherSurname');
    }
    if (otherEmail == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'otherEmail');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'associations');
    }
    if (groupeOuSeul == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'groupeOuSeul');
    }
    if (horairesDeTravail == null) {
      throw new BuiltValueNullFieldError(
          'BuildBinomePair', 'horairesDeTravail');
    }
    if (enligneOuNon == null) {
      throw new BuiltValueNullFieldError('BuildBinomePair', 'enligneOuNon');
    }
    if (matieresPreferees == null) {
      throw new BuiltValueNullFieldError(
          'BuildBinomePair', 'matieresPreferees');
    }
  }

  @override
  BuildBinomePair rebuild(void Function(BuildBinomePairBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildBinomePairBuilder toBuilder() =>
      new BuildBinomePairBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildBinomePair &&
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
                                                                0,
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
    return (newBuiltValueToStringHelper('BuildBinomePair')
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

class BuildBinomePairBuilder
    implements Builder<BuildBinomePair, BuildBinomePairBuilder> {
  _$BuildBinomePair _$v;

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

  BuildBinomePairBuilder();

  BuildBinomePairBuilder get _$this {
    if (_$v != null) {
      _binomePairId = _$v.binomePairId;
      _login = _$v.login;
      _name = _$v.name;
      _surname = _$v.surname;
      _email = _$v.email;
      _otherLogin = _$v.otherLogin;
      _otherName = _$v.otherName;
      _otherSurname = _$v.otherSurname;
      _otherEmail = _$v.otherEmail;
      _associations = _$v.associations?.toBuilder();
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
  void replace(BuildBinomePair other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuildBinomePair;
  }

  @override
  void update(void Function(BuildBinomePairBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildBinomePair build() {
    _$BuildBinomePair _$result;
    try {
      _$result = _$v ??
          new _$BuildBinomePair._(
              binomePairId: binomePairId,
              login: login,
              name: name,
              surname: surname,
              email: email,
              otherLogin: otherLogin,
              otherName: otherName,
              otherSurname: otherSurname,
              otherEmail: otherEmail,
              associations: associations.build(),
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

        _$failedField = 'horairesDeTravail';
        horairesDeTravail.build();

        _$failedField = 'matieresPreferees';
        matieresPreferees.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuildBinomePair', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
