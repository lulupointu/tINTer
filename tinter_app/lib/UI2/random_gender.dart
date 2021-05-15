import 'dart:math';

enum Gender {
  M, F,
}

final randomGender = Random().nextDouble() >= 0.5 ? Gender.F : Gender.M;