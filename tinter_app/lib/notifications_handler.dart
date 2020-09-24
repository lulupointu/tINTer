import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/notification_relation_status_types/notification_relation_status_title.dart';
import 'package:tinterapp/Logic/repository/shared/notification_repository.dart';
import 'package:tinterapp/UI/associatif/matches/matches.dart';
import 'package:tinterapp/UI/scolaire/binomes/binomes.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';


class NotificationHandler {
  FirebaseMessaging _firebaseMessaging;
  String token;
  BuildContext context;
  bool _isInit = false;
  NotificationRepository notificationRepository;

  NotificationHandler({@required this.notificationRepository});

  Future<void> init({@required BuildContext context}) async {
    if (_isInit) return;
    _isInit = true;

    this.context = context;

    WidgetsFlutterBinding.ensureInitialized();
    _firebaseMessaging = FirebaseMessaging();
    token = await _firebaseMessaging.getToken();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    // print(
    //     'DOES CONTAIN NOTIFICAITONTOKEN ${await _firebaseMessaging.getToken()} ? ${await flutterSecureStorage.containsKey(key: 'notificationToken')}');
    if (!await flutterSecureStorage.containsKey(key: 'notificationToken')) {
      print('SENDING NOTIFICATION TOKEN TO DATABSE');
      await notificationRepository.sendNotificationToken(
          notificationToken: await _firebaseMessaging.getToken());

      await flutterSecureStorage.write(
          key: 'notificationToken', value: await _firebaseMessaging.getToken());
    }

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings =
        InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        onDidReceiveForegroundNotification(message);
      },
      onBackgroundMessage: onDidReceiveBackgroundNotification,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        onDidReceiveForegroundNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        onDidReceiveForegroundNotification(message);
      },
    );

    print('Notification handler configured.');
  }

  // WARNING: we just treat RelationStatusNotification for now
  Future onSelectNotification(String payload) async {
    print('onSelectNotification was called with arg payload: $payload');
    Map<String, dynamic> data = jsonDecode(payload);

    NotificationRelationStatusTitle notificationRelationStatusTitle =
        NotificationRelationStatusTitle.valueOf(data['title']);

    int id;
    switch (notificationRelationStatusTitle) {
      case NotificationRelationStatusTitle.relationStatusAssociatifUpdate:
        var relationStatus =
            RelationStatusAssociatif.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.login.hashCode;

        // Pass the selectedLogin to this tab
        context.read<SelectedAssociatif>().matchLogin = relationStatus.login;

        // Make sure the theme is the right one
        Provider.of<TinterTheme>(context, listen: false).theme = MyTheme.dark;

        break;
      case NotificationRelationStatusTitle.relationStatusScolaireUpdate:
        RelationStatusScolaire relationStatus =
            RelationStatusScolaire.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.login.hashCode;

        // Pass the selectedLogin to this tab
        context.read<SelectedScolaire>().binomeLogin = relationStatus.login;

        // Make sure the theme is the right one
        Provider.of<TinterTheme>(context, listen: false).theme = MyTheme.light;

        break;
      case NotificationRelationStatusTitle.relationStatusBinomeUpdate:
        RelationStatusBinomePair relationStatus =
            RelationStatusBinomePair.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.binomePairId.hashCode;

        // Pass the selectedLogin to this tab
        context.read<SelectedScolaire>().binomePairId = relationStatus.binomePairId;

        // Make sure the theme is the right one
        Provider.of<TinterTheme>(context, listen: false).theme = MyTheme.light;

        break;
      default:
        throw UnknownNotificationTitle(title: notificationRelationStatusTitle.serialize());
    }

    // Change the tab index
    Provider.of<TinterTabs>(context, listen: false).selectedTabIndex = 0;
  }

  Future onDidReceiveForegroundNotification(Map<String, dynamic> message) async {
    print('onDidReceiveForegroundNotification: $message');
    var data = message['data'] ?? message;

    // get message data
    // WARNING: we just treat RelationStatusNotification for now
    NotificationRelationStatusTitle notificationRelationStatusTitle =
        NotificationRelationStatusTitle.valueOf(data['title']);

    int id;
    String title;
    String body;
    Color color;
    switch (notificationRelationStatusTitle) {
      case NotificationRelationStatusTitle.relationStatusAssociatifUpdate:
        var relationStatus =
            RelationStatusAssociatif.fromJson(jsonDecode(data['relationStatus']));

        // If we are looking at this person, do nothing
        if (Provider.of<TinterTabs>(context, listen: false).selectedTabIndex == 0 &&
            Provider.of<TinterTheme>(context, listen: false).theme == MyTheme.dark &&
            context.read<SelectedAssociatif>().matchLogin == relationStatus.login) return;

        id = relationStatus.login.hashCode;
        title = '${data['matchName']} ${data['matchSurname']}';
        color = TinterDarkThemeColors.primary;
        switch (relationStatus.status) {
          case EnumRelationStatusAssociatif.none:
          case EnumRelationStatusAssociatif.ignored:
            return;
          case EnumRelationStatusAssociatif.liked:
            body =
                '${data['matchName']} ${data['matchSurname']} t\'a matché !🎉🎉';
            break;
          case EnumRelationStatusAssociatif.askedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} t\'a fait une demande de parrainage !🎉🎉';
            break;
          case EnumRelationStatusAssociatif.acceptedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} a accepté.e ta demande de parrainage 🎉🎉';
            break;
          case EnumRelationStatusAssociatif.refusedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} a refusé.e ta demande de parrainage';
            break;
        }
        break;
      case NotificationRelationStatusTitle.relationStatusScolaireUpdate:
        RelationStatusScolaire relationStatus =
            RelationStatusScolaire.fromJson(jsonDecode(data['relationStatus']));

        // If we are looking at this person, do nothing
        if (Provider.of<TinterTabs>(context, listen: false).selectedTabIndex == 0 &&
            Provider.of<TinterTheme>(context, listen: false).theme == MyTheme.light &&
            context.read<SelectedScolaire>().binomeLogin == relationStatus.login) return;

        id = relationStatus.login.hashCode;
        title = '${data['binomeName']} ${data['binomeSurname']}';
        color = TinterLightThemeColors.primary;
        switch (relationStatus.statusScolaire) {
          case EnumRelationStatusScolaire.none:
          case EnumRelationStatusScolaire.ignored:
            return;
          case EnumRelationStatusScolaire.liked:
            body =
                '${data['binomeName']} ${data['binomeSurname']} t\'a matché !🎉🎉';
            break;
          case EnumRelationStatusScolaire.askedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} veut être ton binome !🎉🎉';
            break;
          case EnumRelationStatusScolaire.acceptedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} a accepté.e d\'être votre binome 🎉🎉';
            break;
          case EnumRelationStatusScolaire.refusedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} a refusé.e d\'être votre binome';
            break;
        }
        break;
      case NotificationRelationStatusTitle.relationStatusBinomeUpdate:
        var relationStatus =
            RelationStatusBinomePair.fromJson(jsonDecode(data['relationStatus']));

        // If we are looking at this person, do nothing
        if (Provider.of<TinterTabs>(context, listen: false).selectedTabIndex == 0 &&
            Provider.of<TinterTheme>(context, listen: false).theme == MyTheme.light &&
            context.read<SelectedScolaire>().binomePairId == relationStatus.binomePairId) return;

        id = relationStatus.binomePairId.hashCode;
        title =
            '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']}';
        color = TinterLightThemeColors.primary;
        switch (relationStatus.status) {
          case EnumRelationStatusBinomePair.none:
          case EnumRelationStatusBinomePair.ignored:
            return;
          case EnumRelationStatusBinomePair.liked:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} vous ont matché !🎉🎉';
            break;
          case EnumRelationStatusBinomePair.askedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} vous ont fait une demande!🎉🎉';
            break;
          case EnumRelationStatusBinomePair.acceptedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} ont accepté.e votre demande 🎉🎉';
            break;
          case EnumRelationStatusBinomePair.refusedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} ont refusé.e votre demande';
            break;
        }
        break;
      default:
        throw UnknownNotificationTitle(title: notificationRelationStatusTitle.serialize());
    }

    await showNotification(
      id: id,
      title: title,
      body: body,
      color: color,
      payload: Map<String, dynamic>.from(data),
    );
  }

  static Future onDidReceiveBackgroundNotification(Map<String, dynamic> message) async {
    print('onDidReceiveBackgroundNotification: $message');
    var data = message['data'] ?? message;

    // get message data
    // WARNING: we just treat RelationStatusNotification for now
    NotificationRelationStatusTitle notificationRelationStatusTitle =
        NotificationRelationStatusTitle.valueOf(data['title']);

    int id;
    String title;
    String body;
    Color color;
    switch (notificationRelationStatusTitle) {
      case NotificationRelationStatusTitle.relationStatusAssociatifUpdate:
        var relationStatus =
            RelationStatusAssociatif.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.login.hashCode;
        title = '${data['matchName']} ${data['matchSurname']}';
        color = TinterDarkThemeColors.primary;
        switch (relationStatus.status) {
          case EnumRelationStatusAssociatif.none:
          case EnumRelationStatusAssociatif.ignored:
            break;
          case EnumRelationStatusAssociatif.liked:
            body =
                '${data['matchName']} ${data['matchSurname']} t\'a matché !🎉🎉';
            break;
          case EnumRelationStatusAssociatif.askedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} t\'a fait une demande de parrainage !🎉🎉';
            break;
          case EnumRelationStatusAssociatif.acceptedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} a accepté.e votre demande de parrainage 🎉🎉';
            break;
          case EnumRelationStatusAssociatif.refusedParrain:
            body =
                '${data['matchName']} ${data['matchSurname']} a refusé.e votre demande de parrainage';
            break;
        }
        break;
      case NotificationRelationStatusTitle.relationStatusScolaireUpdate:
        RelationStatusScolaire relationStatus =
            RelationStatusScolaire.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.login.hashCode;
        title = '${data['binomeName']} ${data['binomeSurname']}';
        color = TinterLightThemeColors.primary;
        switch (relationStatus.statusScolaire) {
          case EnumRelationStatusScolaire.none:
          case EnumRelationStatusScolaire.ignored:
            break;
          case EnumRelationStatusScolaire.liked:
            body =
                '${data['binomeName']} ${data['binomeSurname']} t\'a matché !🎉🎉';
            break;
          case EnumRelationStatusScolaire.askedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} veut être ton binome !🎉🎉';
            break;
          case EnumRelationStatusScolaire.acceptedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} a accepté.e d\'être votre binome 🎉🎉';
            break;
          case EnumRelationStatusScolaire.refusedBinome:
            body =
                '${data['binomeName']} ${data['binomeSurname']} a refusé.e d\'être votre binome';
            break;
        }
        break;
      case NotificationRelationStatusTitle.relationStatusBinomeUpdate:
        var relationStatus =
            RelationStatusBinomePair.fromJson(jsonDecode(data['relationStatus']));
        id = relationStatus.binomePairId.hashCode;
        title =
            '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']}';
        color = TinterLightThemeColors.primary;
        switch (relationStatus.status) {
          case EnumRelationStatusBinomePair.none:
          case EnumRelationStatusBinomePair.ignored:
            break;
          case EnumRelationStatusBinomePair.liked:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} vous ont matché !🎉🎉';
            break;
          case EnumRelationStatusBinomePair.askedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} vous ont fait une demande!🎉🎉';
            break;
          case EnumRelationStatusBinomePair.acceptedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} ont accepté.e votre demande 🎉🎉';
            break;
          case EnumRelationStatusBinomePair.refusedBinomePairMatch:
            body =
                '${data['binomePairName']} ${data['binomePairSurname']} & ${data['binomePairOtherName']} ${data['binomePairOtherSurname']} ont refusé.e votre demande';
            break;
        }
        break;
      default:
        throw UnknownNotificationTitle(title: notificationRelationStatusTitle.serialize());
    }

    await showNotification(
      id: id,
      title: title,
      body: body,
      color: color,
      payload: Map<String, dynamic>.from(data),
    );
  }

  static Future showNotification({
    @required int id,
    @required String title,
    @required String body,
    @required Color color,
    @required Map<String, dynamic> payload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: body, color: color);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics,
        payload: jsonEncode(payload));
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) {
    print(
        'onDidReceiveLocalNotification: id: $id, title: $title, body: $body, playload: $payload');
  }

  static Future deleteNotificationToken() async {
    FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
    await flutterSecureStorage.delete(key: 'notificationToken');
  }

  Future removeNotification(int notificationId) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}

class NotificationHandlerError implements Exception {}

class NotificationHandlerNotInitialized extends NotificationHandlerError {
  @override
  String toString() => '[${this.runtimeType}]: Please initialize this class with init().';
}

class UnknownNotificationTitle extends NotificationHandlerError {
  final String title;

  UnknownNotificationTitle({@required this.title});

  @override
  String toString() => '[${this.runtimeType}]: $title is not a known notification title.';
}
