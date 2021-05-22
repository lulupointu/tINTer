import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tinterapp/Logic/blocs/shared/associations/associations_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/custom_flare_controller.dart';

main() => runApp(MaterialApp(
      home: AssociationsTab2(),
    ));

class AssociationsTab2 extends StatefulWidget {
  static final Map<String, double> fractions = {
    'topSeparator': 0.08,
    'sheetSeparator': 0.1,
    'likedAssociations': 0.25,
    'horizontalMargin': 0.05,
    'titles': 0.05,
    'titlesSeparator': 0.01,
    'headerSpacing': 0.05,
  };
  final duration = Duration(milliseconds: 300);
  final Curve curve = Curves.easeIn;

  @override
  _AssociationsTab2State createState() => _AssociationsTab2State();
}

class _AssociationsTab2State extends State<AssociationsTab2> {
  int _keyboardVisibilitySubscriberId;
  bool isSearching = false;
  String searchString = "";
  PanelController _panelController;

  @protected
  void initState() {
    super.initState();
    _panelController = PanelController();
    KeyboardVisibilityController().onChange.listen(
      (bool visible) {
        if (!visible) {
          FocusScope.of(context).unfocus();
          if (searchString == "") {
            clearSearch();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Consumer<TinterTheme>(
          builder: (context, tinterTheme, child) {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                  'Associations',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: child,
            );
          },
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Padding(
              padding: EdgeInsets.only(top: 20.0),
              child:
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SlidingUpPanel(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    margin: EdgeInsets.only(top: 0.0),
                    color: tinterTheme.colors.bottomSheet,
                    backdropEnabled: true,
                    backdropOpacity: 1.0,
                    backdropColor: Theme.of(context).scaffoldBackgroundColor,
                    controller: _panelController,
                    maxHeight: constraints.maxHeight,
                    minHeight: constraints.maxHeight *
                        (1 -
                            (AssociationsTab2.fractions['topSeparator'] +
                                AssociationsTab2.fractions['sheetSeparator'] +
                                AssociationsTab2
                                    .fractions['likedAssociations'] +
                                AssociationsTab2.fractions['titles'] +
                                AssociationsTab2.fractions['titlesSeparator']))*1.15,
                    body: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: LikedAssociationsWidgetWithTitle(
                            titleHeight: constraints.maxHeight *
                                AssociationsTab2.fractions['titles'],
                            titleSeparatorHeight: constraints.maxHeight *
                                AssociationsTab2.fractions['titlesSeparator'],
                            likedAssociationsHeight: constraints.maxHeight *
                                AssociationsTab2.fractions['likedAssociations'],
                            width: constraints.maxWidth,
                            margin: constraints.maxHeight *
                                AssociationsTab2.fractions['horizontalMargin'],
                          ),
                        )
                      ],
                    ),
                    panelBuilder: (ScrollController scrollController) {
                      return AllAssociationsSheetBody(
                        scrollController: scrollController,
                        keyboardMargin:
                            KeyboardVisibilityProvider.isKeyboardVisible(
                                    context)
                                ? MediaQuery.of(context).viewInsets.bottom
                                : 0,
                        width: constraints.maxWidth,
                        margin: constraints.maxHeight *
                            AssociationsTab2.fractions['horizontalMargin'],
                        headerHeight: constraints.maxHeight *
                            AssociationsTab2.fractions['titles'],
                        headerSpacing: constraints.maxHeight *
                            AssociationsTab2.fractions['headerSpacing'],
                        searchString: searchString,
                      );
                    },
                    header: TitleAndSearchBarAllAssociations(
                      height: constraints.maxHeight *
                          AssociationsTab2.fractions['titles'],
                      width: constraints.maxWidth,
                      margin: constraints.maxHeight *
                          AssociationsTab2.fractions['horizontalMargin'],
                      headerSpacing: constraints.maxHeight *
                          AssociationsTab2.fractions['headerSpacing'],
                      isSearching: isSearching,
                      searchString: searchString,
                      onSearch: onSearch,
                      clearSearch: clearSearch,
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  void onSearch(String searchValue) {
    if (!_panelController.isPanelOpen) {
      _panelController.open();
    }
    setState(() {
      isSearching = true;
      searchString = searchValue;
    });
  }

  void clearSearch() {
    setState(() {
      isSearching = false;
      searchString = "";
    });
  }
}

class LikedAssociationsWidgetWithTitle extends StatelessWidget {
  final double titleHeight, titleSeparatorHeight;
  final double likedAssociationsHeight, width, margin;

  LikedAssociationsWidgetWithTitle({
    @required this.titleHeight,
    @required this.titleSeparatorHeight,
    @required this.likedAssociationsHeight,
    @required this.width,
    @required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 15.0,
          bottom: 15.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mes associations',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 10.0,
            ),
            LikedAssociationsWidget(
              height: likedAssociationsHeight,
              width: width,
              margin: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class LikedAssociationsWidget extends StatefulWidget {
  final duration = Duration(milliseconds: 300);
  final Curve curve = Curves.easeIn;
  final double height, width, margin;

  LikedAssociationsWidget({
    @required this.height,
    @required this.width,
    @required this.margin,
  });

  @override
  _LikedAssociationsWidgetState createState() =>
      _LikedAssociationsWidgetState();
}

class _LikedAssociationsWidgetState extends State<LikedAssociationsWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Association _selectedItem;
  ScrollController controller;

  _removeAssociation(int index, Association association) {
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return LikedAssociationWidget(
          height: widget.height,
          maxWidth: widget.width,
          margin: widget.margin,
          addOrRemoveAnimation: animation,
          association: association,
          selected: false,
        );
      },
      duration: widget.duration,
    );
    _selectedItem = null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: BlocBuilder<UserBloc, UserState>(
          buildWhen: (UserState previousState, UserState state) {
        if (!(state is UserLoadSuccessState)) {
          return false;
        }
        if (!(previousState is UserLoadSuccessState)) {
          return true;
        }
        if ((previousState as UserLoadSuccessState).user.associations ==
            (state as UserLoadSuccessState).user.associations) {
          return false;
        }
        if ((previousState as UserLoadSuccessState).user.associations.length !=
            0) {
          checkForChanges(
              (previousState as UserLoadSuccessState)
                  .user
                  .associations
                  .toList(),
              (state as UserLoadSuccessState).user.associations.toList());
        }
        return true;
      }, builder: (BuildContext context, UserState userState) {
        if (!(userState is UserLoadSuccessState)) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if ((userState as UserLoadSuccessState).user.associations.length == 0)
          return NoLikedAssociationWidget(
            margin: widget.margin,
          );
        return AnimatedList(
          physics:
              (_selectedItem == null) ? null : NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          key: _listKey,
          initialItemCount:
              (userState as UserLoadSuccessState).user.associations.length,
          controller: controller,
          itemBuilder:
              (BuildContext context, int index, Animation<double> animation) {
            return LikedAssociationWidget(
              height: widget.height,
              maxWidth: widget.width,
              margin: widget.margin,
              addOrRemoveAnimation: animation,
              association:
                  (userState as UserLoadSuccessState).user.associations[index],
              isFirst: index == 0,
              selected: _selectedItem ==
                  (userState as UserLoadSuccessState).user.associations[index],
              onSelect: (AnimationController controller) => _onSelect(
                  index,
                  controller,
                  (userState as UserLoadSuccessState).user.associations[index]),
              onDislike: () => BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState).user.rebuild(
                      (u) => u.associations.remove(
                          (userState as UserLoadSuccessState)
                              .user
                              .associations[index])),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _onSelect(int index, AnimationController animationController,
      Association association) {
    setState(() {
      _selectedItem = _selectedItem == association ? null : association;
    });
    _selectedItem == association
        ? animationController.forward()
        : animationController.reverse();

    // Delay by a small amount in order to wait for the association card to grow
    Future.delayed(const Duration(milliseconds: 10), () {}).then((_) {
      // The controller goes to the selected association.
      // Note that an unselected association width is the same as it's height
      controller.animateTo(index * (widget.height + widget.margin),
          duration: widget.duration, curve: widget.curve);
    });
  }

  @override
  void initState() {
    controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void checkForChanges(
      List<Association> oldAssociations, List<Association> associations) {
    for (Association association in oldAssociations) {
      if (!associations.contains(association)) {
        _removeAssociation(oldAssociations.indexOf(association), association);
      }
    }
    for (Association association in associations) {
      if (!oldAssociations.contains(association)) {
        _listKey.currentState.insertItem(associations.indexOf(association));
      }
    }
  }
}

class NoLikedAssociationWidget extends StatelessWidget {
  final double margin;

  const NoLikedAssociationWidget({Key key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: margin),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: tinterTheme.colors.primaryAccent,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                'Aucune association sélectionnée.',
                style: tinterTheme.textStyle.headline2
                    .copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class LikedAssociationWidget extends StatefulWidget {
  LikedAssociationWidget({
    Key key,
    @required this.maxWidth,
    @required this.height,
    @required this.addOrRemoveAnimation,
    @required this.margin,
    this.onSelect,
    this.onDislike,
    @required this.association,
    this.selected: false,
    this.isFirst: false,
  })  : assert(addOrRemoveAnimation != null),
        assert(association != null),
        assert(selected != null),
        super(key: key);

  final double maxWidth;
  final double height;
  final double margin;
  final Animation<double> addOrRemoveAnimation;
  final dynamic onSelect;
  final VoidCallback onDislike;
  final Association association;
  final bool selected;
  final bool isFirst;

  @override
  _LikedAssociationWidgetState createState() => _LikedAssociationWidgetState();
}

class _LikedAssociationWidgetState extends State<LikedAssociationWidget>
    with SingleTickerProviderStateMixin {
  final Duration duration = Duration(milliseconds: 200);
  AnimationController _animationController;
  FlareController flareController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: duration,
      lowerBound: 0,
      upperBound: 1,
    );
    flareController = CustomFlareController(
      controller: _animationController,
      forwardAnimationName: 'PlusToMinus',
      reverseAnimationName: 'MinusToPlus',
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: widget.addOrRemoveAnimation,
      child: ScaleTransition(
        scale: widget.addOrRemoveAnimation,
        child: Center(
          child: TweenAnimationBuilder(
            duration: duration,
            tween: Tween<double>(begin: 0, end: widget.selected ? 1 : 0),
            builder:
                (BuildContext context, double selectedValue, Widget child) {
              return Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Container(
                      width: widget.height +
                          selectedValue *
                              (widget.maxWidth -
                                  2 *
                                      widget.maxWidth *
                                      AssociationsTab2
                                          .fractions['horizontalMargin'] -
                                  widget.height),
                      height: widget.height,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 7.5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.association.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: Colors.black54,
                          ),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: getLogoFromAssociation(
                                  associationName: widget.association.name),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Icon(
                                Icons.info_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                showGeneralDialog(
                                    transitionDuration:
                                        Duration(milliseconds: 300),
                                    context: context,
                                    pageBuilder: (BuildContext context,
                                            animation, _) =>
                                        SimpleDialog(
                                          elevation: 5.0,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text(
                                                "Description",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline4,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,
                                                  right: 20.0,
                                                  top: 10.0,
                                                  bottom: 10.0),
                                              child: Text(
                                                widget.association.description,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 75.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text("Continuer"),
                                              ),
                                            ),
                                          ],
                                        ));
                              },
                            ),
                            GestureDetector(
                              onTap: widget.onDislike,
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).indicatorColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TitleAndSearchBarAllAssociations extends StatelessWidget {
  final double height, width, margin;
  final Duration duration = Duration(milliseconds: 300);
  final bool isSearching;
  final String searchString;
  final dynamic onSearch;
  final dynamic clearSearch;
  final double headerSpacing;

  TitleAndSearchBarAllAssociations({
    @required this.height,
    @required this.width,
    @required this.margin,
    @required this.isSearching,
    @required this.searchString,
    @required this.onSearch,
    @required this.clearSearch,
    @required this.headerSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        height: height,
        width: width - 2 * margin,
        color: tinterTheme.colors.bottomSheet,
        margin:
            EdgeInsets.only(left: margin, right: margin, top: headerSpacing),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedOpacity(
              duration: duration,
              opacity: isSearching ? 0 : 1,
              child: Text(
                'Toutes les associations',
                style: tinterTheme.textStyle.headline2
                    .copyWith(color: tinterTheme.colors.defaultTextColor),
                maxLines: 1,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 30.0,
                ),
                child: InkWell(
                  onTap: () => onSearch(""),
                  child: AnimatedContainer(
                    duration: duration,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: tinterTheme.colors.primaryAccent,
                    ),
                    width: isSearching ? width : height,
                    height: height,
                    child: !isSearching
                        ? Icon(
                            Icons.search,
                            color: Colors.black,
                          )
                        : TextField(
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              suffixIcon: searchString == ""
                                  ? null
                                  : InkWell(
                                      onTap: clearSearch,
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                                    ),
                            ),
                            autofocus: isSearching,
                            maxLines: 1,
                            onChanged: (String text) => onSearch(text),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AllAssociationsSheetBody extends StatelessWidget {
  final scrollController;
  final double headerHeight;
  final width;
  final double headerSpacing;
  final double margin;
  final double keyboardMargin;
  final String searchString;

  AllAssociationsSheetBody({
    @required this.scrollController,
    @required this.headerHeight,
    @required this.width,
    @required this.headerSpacing,
    @required this.margin,
    @required this.keyboardMargin,
    @required this.searchString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: margin, right: margin, top: headerSpacing + headerHeight),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          if (overscroll.leading) {
            overscroll.disallowGlow();
          }
          return true;
        },
        child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
          return BlocBuilder<AssociationsBloc, AssociationsState>(builder:
              (BuildContext context, AssociationsState associationsState) {
            if (!(associationsState is AssociationsLoadSuccessfulState)) {
              if (associationsState is AssociationsInitialState) {
                BlocProvider.of<AssociationsBloc>(context)
                    .add(AssociationsLoadEvent());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Association> _allAssociations =
                (associationsState as AssociationsLoadSuccessfulState)
                    .associations;
            _allAssociations.sort(
                (Association associationA, Association associationB) =>
                    associationA.name.compareTo(associationB.name));
            RegExp searchStringRegex = new RegExp(
              searchString,
              caseSensitive: false,
              multiLine: false,
            );
            final _associations = (searchString == null)
                ? _allAssociations
                : _allAssociations
                    .where((Association association) =>
                        searchStringRegex.hasMatch(
                            association.name + ' ' + association.description))
                    .toList();
            return ListView.separated(
              controller: scrollController,
              itemCount: _associations.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                if (!(userState is UserLoadSuccessState)) {
                  return Center(child: CircularProgressIndicator());
                }
                final bool liked = (userState as UserLoadSuccessState)
                    .user
                    .associations
                    .contains(_associations[index]);
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? headerSpacing : 0,
                    bottom: index == _associations.length - 1
                        ? headerSpacing + keyboardMargin + 30
                        : 0,
                  ),
                  child: AssociationCard(
                    association: _associations[index],
                    liked: liked,
                    onLike: () {
                      if (liked) {
                        BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((u) => u.associations
                                    .remove(_associations[index])),
                          ),
                        );
                      } else {
                        BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((u) =>
                                    u.associations.add(_associations[index])),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          });
        }),
      ),
    );
  }

  void onLike(int index) {}
}

class AssociationCard extends StatelessWidget {
  final Association association;
  final bool liked;
  final VoidCallback onLike;

  AssociationCard(
      {@required this.association, @required this.onLike, this.liked: false});

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: tinterTheme.colors.primary,
        ),
        child: ListTile(
          leading: Container(
            height: double.maxFinite,
            child: Container(
              alignment: Alignment.centerLeft,
              width: 50,
              height: 50,
              child: ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child:
                      getLogoFromAssociation(associationName: association.name),
                ),
              ),
            ),
          ),
          title: Text(
            association.name,
            style: tinterTheme.textStyle.headline2,
          ),
          subtitle: Text(
            association.description,
            style: tinterTheme.textStyle.bigLabel,
          ),
          trailing: IconButton(
            onPressed: onLike,
            icon: Icon(
              liked ? Icons.favorite : Icons.favorite_border,
              color: tinterTheme.colors.secondary,
            ),
          ),
        ),
      );
    });
  }
}
