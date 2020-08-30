import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tinter_backend/models/scolaire/binome_pair.dart';
import 'package:tinter_backend/models/serializers.dart';

part 'relation_score_binome_pair.g.dart';

abstract class RelationScoreBinomePair
    implements Built<RelationScoreBinomePair, RelationScoreBinomePairBuilder> {
  // otherBinomePairId is defined so that binomePairId < otherBinomePairId
  int get binomePairId;

  int get otherBinomePairId;

  int get score;

  RelationScoreBinomePair._();

  factory RelationScoreBinomePair([void Function(RelationScoreBinomePairBuilder) updates]) =
      _$RelationScoreBinomePair;

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RelationScoreBinomePair.serializer, this);
  }

  static RelationScoreBinomePair fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RelationScoreBinomePair.serializer, json);
  }

  static Serializer<RelationScoreBinomePair> get serializer =>
      _$relationScoreBinomePairSerializer;


  static Map<int, RelationScoreBinomePair> getScoreBetweenMultiple(BuildBinomePair binomePair,
      List<BuildBinomePair> otherBinomePairs, int numberMaxOfAssociations, int numberMaxOfMatieres,
      {int NumberMaxOfHorairesDeTravail: 4}) {
    return {
      for (BuildBinomePair otherBinomePair in otherBinomePairs)
        otherBinomePair.binomePairId: RelationScoreBinomePair.getScoreBetween(binomePair, otherBinomePair,
            numberMaxOfAssociations, numberMaxOfMatieres, NumberMaxOfHorairesDeTravail)
    };
  }

  static RelationScoreBinomePair getScoreBetween(BuildBinomePair binomePair, BuildBinomePair otherBinomePair,
      int numberMaxOfAssociations, int numberMaxOfMatieres, int NumberMaxOfHorairesDeTravail) {
    return RelationScoreBinomePair((b) => b
      ..binomePairId = binomePair.binomePairId
      ..otherBinomePairId = otherBinomePair.binomePairId
      ..score = ((1 -
          (getNormalizedScoreBetweenLists(binomePair.associations.toList(),
              otherBinomePair.associations.toList(), numberMaxOfAssociations) +
              0.3 *
                  getNormalizedScoreBetweenLists(
                      [binomePair.lieuDeVie], [otherBinomePair.lieuDeVie], 1) +
              (binomePair.groupeOuSeul - otherBinomePair.groupeOuSeul).abs() +
              (binomePair.enligneOuNon - otherBinomePair.enligneOuNon).abs() +
              getNormalizedScoreBetweenLists(binomePair.horairesDeTravail.toList(),
                  otherBinomePair.horairesDeTravail.toList(), numberMaxOfMatieres) +
              getNormalizedScoreBetweenLists(binomePair.matieresPreferees.toList(),
                  otherBinomePair.matieresPreferees.toList(), numberMaxOfMatieres)) /
              5.3) *
          100)
          .floor());
  }

  static double getNormalizedScoreBetweenLists(List list, List otherList, int maxLengthList) {
    final int numberOfCommonAssociations =
    list.fold(0, (value, element) => otherList.contains(element) ? 1 : 0);
    final int numberOfDifferentAssociations = (list.length - numberOfCommonAssociations) +
        (otherList.length - numberOfCommonAssociations);
    final int numberOfAbsentAssociations =
        maxLengthList - (numberOfCommonAssociations + numberOfDifferentAssociations);

    return (numberOfDifferentAssociations + 0.5 * numberOfAbsentAssociations) / maxLengthList;
  }
}
