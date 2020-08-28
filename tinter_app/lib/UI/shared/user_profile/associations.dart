import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tinterapp/Logic/blocs/shared/associations/associations_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/UI/shared_element/custom_flare_controller.dart';
import '../shared_element/const.dart';

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
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool isSearching = false;
  String searchString = "";
  PanelController _panelController;

  @protected
  void initState() {
    super.initState();
    _panelController = PanelController();
    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
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
  void dispose() {
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TinterColors.background,
        resizeToAvoidBottomInset: false,
        appBar: AllAssociationsAppBar(
          height: 120,
        ),
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(
                top: constraints.maxHeight * AssociationsTab.fractions['topSeparator']),
            child: SlidingUpPanel(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              color: TinterColors.grey,
              backdropEnabled: true,
              backdropOpacity: 1.0,
              backdropColor: TinterColors.background,
              controller: _panelController,
              maxHeight: constraints.maxHeight,
              minHeight: constraints.maxHeight *
                  (1 -
                      (AssociationsTab.fractions['topSeparator'] +
                          AssociationsTab.fractions['sheetSeparator'] +
                          AssociationsTab.fractions['likedAssociations'] +
                          AssociationsTab.fractions['titles'] +
                          AssociationsTab.fractions['titlesSeparator'])),
              body: LikedAssociationsWidgetWithTitle(
                titleHeight: constraints.maxHeight * AssociationsTab.fractions['titles'],
                titleSeparatorHeight:
                    constraints.maxHeight * AssociationsTab.fractions['titlesSeparator'],
                likedAssociationsHeight:
                    constraints.maxHeight * AssociationsTab.fractions['likedAssociations'],
                width: constraints.maxWidth,
                margin: constraints.maxHeight * AssociationsTab.fractions['horizontalMargin'],
              ),
              panelBuilder: (ScrollController scrollController) {
                return AllAssociationsSheetBody(
                  scrollController: scrollController,
                  keyboardMargin: KeyboardVisibility.isVisible
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0,
                  width: constraints.maxWidth,
                  margin:
                      constraints.maxHeight * AssociationsTab.fractions['horizontalMargin'],
                  headerHeight: constraints.maxHeight * AssociationsTab.fractions['titles'],
                  headerSpacing:
                      constraints.maxHeight * AssociationsTab.fractions['headerSpacing'],
                  searchString: searchString,
                );
              },
              header: TitleAndSearchBarAllAssociations(
                height: constraints.maxHeight * AssociationsTab.fractions['titles'],
                width: constraints.maxWidth,
                margin: constraints.maxHeight * AssociationsTab.fractions['horizontalMargin'],
                headerSpacing:
                    constraints.maxHeight * AssociationsTab.fractions['headerSpacing'],
                isSearching: isSearching,
                searchString: searchString,
                onSearch: onSearch,
                clearSearch: clearSearch,
              ),
            ),
          );
        }),
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

class AllAssociationsAppBar extends PreferredSize {
  final double height;

  AllAssociationsAppBar({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        fit: StackFit.expand,
        children: <Widget>[
          SvgPicture.asset(
            'assets/profile/topProfile.svg',
            color: TinterColors.primaryLight,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: AutoSizeText(
                'Associations',
                style: TinterTextStyle.headline1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 24,
                color: TinterColors.hint,
              ),
            ),
          ),
        ],
      ),
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: titleHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: margin),
            child: AutoSizeText(
              'Vos Associations',
              style: TinterTextStyle.headline2,
            ),
          ),
        ),
        SizedBox(
          height: titleSeparatorHeight,
        ),
        LikedAssociationsWidget(
          height: likedAssociationsHeight,
          width: width,
          margin: margin,
        ),
      ],
    );
  }
}

class LikedAssociationsWidget extends StatefulWidget {
  final duration = Duration(milliseconds: 300);
  final Curve curve = Curves.easeIn;
  final double height, width, margin; // TODO : use margin

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
        if ((previousState as UserLoadSuccessState)
                .user
                .associations
                .length !=
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
          return CircularProgressIndicator();
        }
        if ((userState as UserLoadSuccessState).user.associations.length ==
            0)
          return NoLikedAssociationWidget(
            margin: widget.margin,
          );
        return AnimatedList(
          physics: (_selectedItem == null) ? null : NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          key: _listKey,
          initialItemCount:
              (userState as UserLoadSuccessState).user.associations.length,
          controller: controller,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return LikedAssociationWidget(
              height: widget.height,
              maxWidth: widget.width,
              margin: widget.margin,
              addOrRemoveAnimation: animation,
              association: (userState as UserLoadSuccessState)
                  .user
                  .associations[index],
              isFirst: index == 0,
              selected: _selectedItem ==
                  (userState as UserLoadSuccessState)
                      .user
                      .associations[index],
              onSelect: (AnimationController controller) => _onSelect(
                  index,
                  controller,
                  (userState as UserLoadSuccessState)
                      .user
                      .associations[index]),
              onDislike: () => BlocProvider.of<UserBloc>(context).add(
                UserStateChangedEvent(
                  newState: (userState as UserLoadSuccessState)
                      .user
                      .rebuild((u) => u.associations.remove(
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
  final double margin;

  const NoLikedAssociationWidget({Key key, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: TinterColors.primaryAccent,
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Aucune association selectionnée.',
              style: TinterTextStyle.headline2,
            ),
          ),
        ],
      ),
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
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            widget.onSelect(_animationController);
          },
          child: Center(
            child: TweenAnimationBuilder(
              duration: duration,
              tween: Tween<double>(begin: 0, end: widget.selected ? 1 : 0),
              builder: (BuildContext context, double selectedValue, Widget child) {
                return Container(
                  margin: EdgeInsets.only(
                      right: widget.margin, left: widget.isFirst ? widget.margin : 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: TinterColors.primaryAccent,
                  ),
                  width: widget.height +
                      selectedValue *
                          (widget.maxWidth -
                              2 *
                                  widget.maxWidth *
                                  AssociationsTab.fractions['horizontalMargin'] -
                              widget.height),
                  height: widget.height,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          height: 20,
                          width: 20,
                          child: FlareActor(
                            'assets/icons/AnimatedExpand.flr',
                            color: TinterColors.white,
                            fit: BoxFit.contain,
                            controller: flareController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: widget.selected ? 20.0 : 10.0,
                                  bottom: 5.0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 500,
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
                                      width: 10.0 * selectedValue,
                                    ),
                                    Flexible(
                                      flex: (1000 * selectedValue).round() + 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            widget.association.name,
                                            style: TinterTextStyle.headline2.copyWith(
                                              fontSize: TinterTextStyle.headline2.fontSize *
                                                  selectedValue,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: AutoSizeText(
                                                widget.association.description,
                                                style: TinterTextStyle.smallLabel.copyWith(
                                                  fontSize:
                                                      TinterTextStyle.smallLabel.fontSize *
                                                          selectedValue,
                                                ),
                                                maxLines: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.association.name,
                                style: TinterTextStyle.headline2.copyWith(
                                  fontSize:
                                      TinterTextStyle.headline2.fontSize * (1 - selectedValue),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: widget.onDislike,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: TinterColors.secondaryAccent,
                                  size: 28 + 6 * selectedValue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
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
    return Container(
      height: height,
      width: width - 2 * margin,
      color: TinterColors.grey,
      margin: EdgeInsets.only(left: margin, right: margin, top: headerSpacing),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedOpacity(
            duration: duration,
            opacity: isSearching ? 0 : 1,
            child: Text(
              'Toutes les associations',
              style: TinterTextStyle.headline2,
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
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: TinterColors.primaryAccent,
                ),
                width: isSearching ? width : height,
                height: height,
                child: !isSearching
                    ? Icon(
                        Icons.search,
                        color: TinterColors.hint,
                      )
                    : TextField(
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: TinterColors.hint,
                          ),
                          suffixIcon: searchString == ""
                              ? null
                              : InkWell(
                                  onTap: clearSearch,
                                  child: Icon(
                                    Icons.clear,
                                    color: TinterColors.white,
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
        ],
      ),
    );
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
      padding: EdgeInsets.only(left: margin, right: margin, top: headerSpacing + headerHeight),
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
              return CircularProgressIndicator();
            }
            final _allAssociations =
                (associationsState as AssociationsLoadSuccessfulState).associations;
            RegExp searchStringRegex = new RegExp(
              searchString,
              caseSensitive: false,
              multiLine: false,
            );
            final _associations = (searchString == null)
                ? _allAssociations
                : _allAssociations
                    .where((Association association) =>
                        searchStringRegex.hasMatch(association.name))
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
                  return CircularProgressIndicator();
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

  AssociationCard({@required this.association, @required this.onLike, this.liked: false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: TinterColors.primary,
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
                child: getLogoFromAssociation(associationName: association.name),
              ),
            ),
          ),
        ),
        title: Text(
          association.name,
          style: TinterTextStyle.headline2,
        ),
        subtitle: Text(
          association.description,
          style: TinterTextStyle.bigLabel,
        ),
        trailing: IconButton(
          onPressed: onLike,
          icon: Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: TinterColors.secondaryAccent,
          ),
        ),
      ),
    );
  }
}
