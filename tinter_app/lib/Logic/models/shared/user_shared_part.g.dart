// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_shared_part.dart';

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

Serializer<BuildUserSharedPart> _$buildUserSharedPartSerializer =
    new _$BuildUserSharedPartSerializer();
Serializer<School> _$schoolSerializer = new _$SchoolSerializer();

class _$BuildUserSharedPartSerializer
    implements StructuredSerializer<BuildUserSharedPart> {
  @override
  final Iterable<Type> types = const [
    BuildUserSharedPart,
    _$BuildUserSharedPart
  ];
  @override
  final String wireName = 'BuildUserSharedPart';

  @override
  Iterable<Object> serialize(
      Serializers serializers, BuildUserSharedPart object,
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
  BuildUserSharedPart deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BuildUserSharedPartBuilder();

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

class _$BuildUserSharedPart extends BuildUserSharedPart {
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

  factory _$BuildUserSharedPart(
          [void Function(BuildUserSharedPartBuilder) updates]) =>
      (new BuildUserSharedPartBuilder()..update(updates)).build();

  _$BuildUserSharedPart._(
      {this.login,
      this.name,
      this.surname,
      this.email,
      this.school,
      this.profilePictureLocalPath,
      this.associations})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'login');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'name');
    }
    if (surname == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'surname');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'email');
    }
    if (school == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'school');
    }
    if (associations == null) {
      throw new BuiltValueNullFieldError('BuildUserSharedPart', 'associations');
    }
  }

  @override
  BuildUserSharedPart rebuild(
          void Function(BuildUserSharedPartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuildUserSharedPartBuilder toBuilder() =>
      new BuildUserSharedPartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuildUserSharedPart &&
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
                    $jc($jc($jc(0, login.hashCode), name.hashCode),
                        surname.hashCode),
                    email.hashCode),
                school.hashCode),
            profilePictureLocalPath.hashCode),
        associations.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BuildUserSharedPart')
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

class BuildUserSharedPartBuilder
    implements Builder<BuildUserSharedPart, BuildUserSharedPartBuilder> {
  _$BuildUserSharedPart _$v;

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

  BuildUserSharedPartBuilder();

  BuildUserSharedPartBuilder get _$this {
    if (_$v != null) {
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
  void replace(BuildUserSharedPart other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BuildUserSharedPart;
  }

  @override
  void update(void Function(BuildUserSharedPartBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BuildUserSharedPart build() {
    _$BuildUserSharedPart _$result;
    try {
      _$result = _$v ??
          new _$BuildUserSharedPart._(
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
        _$failedField = 'associations';
        associations.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'BuildUserSharedPart', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
