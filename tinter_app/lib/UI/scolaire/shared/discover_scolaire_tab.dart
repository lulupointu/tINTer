import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binomes/binomes_bloc.dart';
import 'package:tinterapp/UI/scolaire/discover_binome_pair/discover_binome_pair.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI2/scolaire/discover_binome/discover_binome2.dart';
import 'package:tinterapp/UI2/scolaire/discover_quadrinome/discover_quadrinome2.dart';

class DiscoverScolaireTab extends StatelessWidget implements TinterTab {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(
      builder: (BuildContext context, MatchedBinomesState matchedBinomesState) {
        if (!(matchedBinomesState is MatchedBinomesHasBinomePairCheckedSuccessState))
          return CircularProgressIndicator();
        return (matchedBinomesState as MatchedBinomesHasBinomePairCheckedSuccessState)
                .hasBinomePair
            ? DiscoverBinomePairTab2()
            : DiscoverBinomeTab2();
      },
    );
  }
}
