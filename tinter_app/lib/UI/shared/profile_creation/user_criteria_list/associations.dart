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

import '../../const.dart';
import '../../ui_elements/custom_flare_controller.dart';

main() => runApp(MaterialApp(
      home: AssociationsTab(),
    ));

class AssociationsTab extends StatefulWidget {
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
  _AssociationsTabState createState() => _AssociationsTabState();
}

class _AssociationsTabState extends State<AssociationsTab> {
  int _keyboardVisibilitySubscriberId;
  bool isSearching = false;
  String searchString = "";
  PanelController _panelController;

  @protected
  void initState() {
    super.initState();
    _panelController = PanelController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (BuildContext, bool isKeyboardVisible) {
        if (!isKeyboardVisible) {
          FocusScope.of(context).unfocus();
          if (searchString == "") {
            clearSearch();
          }
        }
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
              child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: 0.0,
                  ),
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return SlidingUpPanel(
                      margin: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 20.0,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      ),
                      color: Colors.white,
                      backdropEnabled: true,
                      backdropOpacity: 1.0,
                      backdropColor: Theme.of(context).scaffoldBackgroundColor,
                      controller: _panelController,
                      maxHeight: constraints.maxHeight,
                      minHeight: constraints.maxHeight *
                          (1 -
                              (AssociationsTab.fractions['topSeparator'] +
                                  AssociationsTab.fractions['sheetSeparator'] +
                                  AssociationsTab.fractions['likedAssociations'] +
                                  AssociationsTab.fractions['titles'] +
                                  AssociationsTab.fractions['titlesSeparator'])) *
                          1.175,
                      body: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 20.0,
                            ),
                            child: LikedAssociationsWidgetWithTitle(
                              titleHeight:
                                  constraints.maxHeight * AssociationsTab.fractions['titles'],
                              titleSeparatorHeight: constraints.maxHeight *
                                  AssociationsTab.fractions['titlesSeparator'],
                              likedAssociationsHeight: constraints.maxHeight *
                                  AssociationsTab.fractions['likedAssociations'],
                              width: constraints.maxWidth,
                              margin: constraints.maxHeight *
                                  AssociationsTab.fractions['horizontalMargin'],
                            ),
                          )
                        ],
                      ),
                      panelBuilder: (ScrollController scrollController) {
                        return AllAssociationsSheetBody(
                          scrollController: scrollController,
                          keyboardMargin: KeyboardVisibilityProvider.isKeyboardVisible(context)
                              ? MediaQuery.of(context).viewInsets.bottom
                              : 0,
                          width: constraints.maxWidth,
                          margin: constraints.maxHeight *
                              AssociationsTab.fractions['horizontalMargin'],
                          headerHeight:
                              constraints.maxHeight * AssociationsTab.fractions['titles'],
                          headerSpacing: constraints.maxHeight *
                              AssociationsTab.fractions['headerSpacing'],
                          searchString: searchString,
                        );
                      },
                      header: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        child: TitleAndSearchBarAllAssociations(
                          height: constraints.maxHeight * AssociationsTab.fractions['titles'],
                          width: constraints.maxWidth,
                          margin: constraints.maxHeight *
                              AssociationsTab.fractions['horizontalMargin'],
                          headerSpacing: constraints.maxHeight *
                              AssociationsTab.fractions['headerSpacing'],
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
      },
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isSearching = false;
        searchString = "";
      });
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
              height: likedAssociationsHeight * 0.9,
              width: width * 0.9,
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
  _LikedAssociationsWidgetState createState() => _LikedAssociationsWidgetState();
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
        if ((previousState as UserLoadSuccessState).user.associations.length != 0) {
          checkForChanges((previousState as UserLoadSuccessState).user.associations.toList(),
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
          return NoLikedAssociationWidget();
        return AnimatedList(
          physics: (_selectedItem == null) ? null : NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          key: _listKey,
          initialItemCount: (userState as UserLoadSuccessState).user.associations.length,
          controller: controller,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return LikedAssociationWidget(
              height: widget.height,
              maxWidth: widget.width,
              margin: widget.margin,
              addOrRemoveAnimation: animation,
              association: (userState as UserLoadSuccessState).user.associations[index],
              isFirst: index == 0,
              selected: _selectedItem ==
                  (userState as UserLoadSuccessState).user.associations[index],
              onSelect: (AnimationController controller) => _onSelect(index, controller,
                  (userState as UserLoadSuccessState).user.associations[index]),
              onDislike: () => BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState).user.rebuild((u) => u
                      .associations
                      .remove((userState as UserLoadSuccessState).user.associations[index])),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _onSelect(int index, AnimationController animationController, Association association) {
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

  void checkForChanges(List<Association> oldAssociations, List<Association> associations) {
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
  const NoLikedAssociationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Aucune association sélectionnée',
          style: Theme.of(context).textTheme.headline5,
        ),
      ],
    );
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
            builder: (BuildContext context, double selectedValue, Widget child) {
              return Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 15.0,
                    ),
                    child: Container(
                      width: widget.height +
                          selectedValue *
                              (widget.maxWidth -
                                  2 *
                                      widget.maxWidth *
                                      AssociationsTab.fractions['horizontalMargin'] -
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
                    vertical: 5.0,
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
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2.5,
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
                                  transitionDuration: Duration(milliseconds: 300),
                                  context: context,
                                  pageBuilder: (BuildContext context, animation, _) =>
                                      Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: SimpleDialog(
                                        elevation: 5.0,
                                        children: [
                                          InkWell(
                                            onTap: () {},
                                            splashColor: Colors.transparent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                  ),
                                                  child: Text(
                                                    "Description",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        Theme.of(context).textTheme.headline4,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0,
                                                  ),
                                                  child: Text(
                                                    widget.association.description,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        Theme.of(context).textTheme.headline5,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                  ),
                                                  child: Container(
                                                    width: 200,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context, false);
                                                      },
                                                      child: Text(
                                                        "Continuer",
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
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
        height: !isSearching ? height : 50.0,
        width: MediaQuery.of(context).size.width - 70.0,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedOpacity(
              duration: duration,
              opacity: isSearching ? 0 : 1,
              child: Text(
                'Toutes les associations',
                style: Theme.of(context).textTheme.headline5,
                maxLines: 1,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => onSearch(""),
                child: AnimatedContainer(
                  duration: duration,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    color: isSearching ? Colors.white : Theme.of(context).primaryColor,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: !isSearching ? 0.0 : 2.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  width: isSearching ? width : height * 2.5,
                  height: !isSearching ? height : height * 1.5,
                  child: !isSearching
                      ? Icon(
                          Icons.search,
                          color: Colors.white,
                        )
                      : Container(
                          height: 50.0,
                          alignment: Alignment.center,
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            style: TextStyle(textBaseline: TextBaseline.alphabetic),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                top: 5.0,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                              suffixIcon: searchString == ""
                                  ? null
                                  : InkWell(
                                      onTap: clearSearch,
                                      child: Icon(
                                        Icons.clear,
                                        color: Theme.of(context).primaryColor,
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
      padding: const EdgeInsets.only(
        right: 20.0,
        left: 20.0,
        top: 50.0,
      ),
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          if (overscroll.leading) {
            overscroll.disallowGlow();
          }
          return true;
        },
        child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
          return BlocBuilder<AssociationsBloc, AssociationsState>(
              builder: (BuildContext context, AssociationsState associationsState) {
            if (!(associationsState is AssociationsLoadSuccessfulState)) {
              if (associationsState is AssociationsInitialState) {
                BlocProvider.of<AssociationsBloc>(context).add(AssociationsLoadEvent());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Association> _allAssociations =
                (associationsState as AssociationsLoadSuccessfulState).associations;
            _allAssociations.sort((Association associationA, Association associationB) =>
                associationA.name.compareTo(associationB.name));
            RegExp searchStringRegex = new RegExp(
              searchString,
              caseSensitive: false,
              multiLine: false,
            );
            final _associations = (searchString == null)
                ? _allAssociations
                : _allAssociations
                    .where((Association association) => searchStringRegex
                        .hasMatch(association.name + ' ' + association.description))
                    .toList();
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (_) {
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
              child: ListView.separated(
                controller: scrollController,
                itemCount: _associations.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 15,
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
                                  .rebuild((u) => u.associations.remove(_associations[index])),
                            ),
                          );
                        } else {
                          BlocProvider.of<UserBloc>(context).add(
                            UserStateChangedEvent(
                              newState: (userState as UserLoadSuccessState)
                                  .user
                                  .rebuild((u) => u.associations.add(_associations[index])),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            );
          });
        }),
      ),
    );
  }

  void onLike(int index) {}
}

class AssociationCard extends StatefulWidget {
  final Association association;
  final bool liked;
  final VoidCallback onLike;

  const AssociationCard({
    Key key,
    @required this.association,
    @required this.onLike,
    this.liked = false,
  }) : super(key: key);

  @override
  _AssociationCardState createState() => _AssociationCardState();
}

class _AssociationCardState extends State<AssociationCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 2.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            top: 12.5,
            bottom: 12.5,
            right: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
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
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isTapped = !isTapped),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.association.name,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            Text(
                              widget.association.description,
                              style: Theme.of(context).textTheme.headline6,
                              overflow: TextOverflow.ellipsis,
                              maxLines: isTapped ? 100 : 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                onTap: widget.onLike,
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    child: Icon(
                      widget.liked ? Icons.favorite : Icons.favorite_border,
                      color: Theme.of(context).indicatorColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
