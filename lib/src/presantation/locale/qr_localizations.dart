import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr/src/presantation/locale/strings.dart' as str;

class QrLocalizations {
  final Locale locale;

  QrLocalizations(this.locale);

  static QrLocalizations of(BuildContext context) {
    return Localizations.of<QrLocalizations>(context, QrLocalizations);
  }

  static const LocalizationsDelegate<QrLocalizations> delegate =
  _QrLocalizationsDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('locale/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String _translate(String key) {
    return _localizedStrings[key];
  }

  String get appName => _translate(str.appName);
  String get ok => _translate(str.ok);
  String get loginWithGoogle => _translate(str.loginWithGoogle);
  String get signUpViaGoogle => _translate(str.signUpViaGoogle);
  String get or => _translate(str.or);
  String get registration => _translate(str.registration);
  String get name => _translate(str.name);
  String get email => _translate(str.email);
  String get position => _translate(str.position);
  String get phone => _translate(str.phone);
  String get phoneExample => _translate(str.phoneExample);
  String get createAccount => _translate(str.createAccount);
  String get userProfile => _translate(str.userProfile);
  String get inventories => _translate(str.inventories);
  String get inventory => _translate(str.inventory);
  String get qrHelper => _translate(str.qrHelper);
  String get adminCapabilities => _translate(str.adminCapabilities);
  String get quit => _translate(str.quit);
  String get platformException => _translate(str.platformException);
  String get stateException => _translate(str.stateException);
  String get unknownError => _translate(str.unknownError);
  String get takeInventory => _translate(str.takeInventory);
  String get returnInventory => _translate(str.returnInventory);
  String get takenInventory => _translate(str.takenInventory);
  String get lostInventory => _translate(str.lostInventory);
  String get scan => _translate(str.scan);
  String get cancel => _translate(str.cancel);
  String get id => _translate(str.id);
  String get description => _translate(str.description);
  String get status => _translate(str.status);
  String get retrieve => _translate(str.retrieve);
  String get take => _translate(str.take);
  String get successfullyTaken => _translate(str.successfullyTaken);
  String get successfullyReturned => _translate(str.successfullyReturned);
  String get listIsEmpty => _translate(str.listIsEmpty);
  String get taken => _translate(str.taken);
  String get history => _translate(str.history);
  String get pressScanButton => _translate(str.pressScanButton);
  String get areYouSureWantToLogout => _translate(str.areYouSureWantToLogout);
  String get userAlreadyRegistered => _translate(str.userAlreadyRegistered);
  String get wrongCredits => _translate(str.wrongCredits);
  String get checkConnection => _translate(str.checkConnection);
  String get rules => _translate(str.rules);
  String get edit => _translate(str.edit);
  String get superUserCapabilities => _translate(str.superUserCapabilities);
  String get addUserToAdmins => _translate(str.addUserToAdmins);
  String get removeUserFromAdmins => _translate(str.removeUserFromAdmins);
  String get removeInventoryStatistic => _translate(str.removeInventoryStatistic);
  String get users => _translate(str.users);
  String get allInventories => _translate(str.allInventories);
  String get addNewInventoryToDB => _translate(str.addNewInventoryToDB);
  String get removeInventoriesFromDB => _translate(str.removeInventoriesFromDB);
  String get unknownInfo => _translate(str.unknownInfo);
  String get notGrantCameraPermission => _translate(str.notGrantCameraPermission);
  String get userStatistic => _translate(str.userStatistic);
  String get checkYourPersonalData => _translate(str.checkYourPersonalData);
  String get all => _translate(str.all);
  String get admins => _translate(str.admins);
  String get free => _translate(str.free);
  String get lost => _translate(str.lost);
  String get statistic => _translate(str.statistic);
  String get getUserInfo => _translate(str.getUserInfo);
  String get getTakenInventoryByUser => _translate(str.getTakenInventoryByUser);
  String get noAnyInventoryForRemove => _translate(str.noAnyInventoryForRemove);
  String get areYouSureWantToRemoveInventory => _translate(str.areYouSureWantToRemoveInventory);
  String get changeStatus => _translate(str.changeStatus);
  String get isLost => _translate(str.isLost);
  String get isFound => _translate(str.isFound);
  String get areYouSureWantMakeItLost => _translate(str.areYouSureWantMakeItLost);
  String get areYouSureWantMakeItFound => _translate(str.areYouSureWantMakeItFound);
  String get checkInventoryData => _translate(str.checkInventoryData);
  String get addNewInventory => _translate(str.addNewInventory);
  String get inventoryAlreadyExist => _translate(str.inventoryAlreadyExist);
  String get successfullyInventoryAdded => _translate(str.successfullyInventoryAdded);
  String get successfullyUserAdded => _translate(str.successfullyUserAdded);
  String get successfullyUserRemoved => _translate(str.successfullyUserRemoved);
  String get thereIsNoAnySimpleUser => _translate(str.thereIsNoAnySimpleUser);
  String get thereIsNoAnyAdmin => _translate(str.thereIsNoAnyAdmin);
  String get areYouSureWantToAddUserToAdmins => _translate(str.areYouSureWantToAddUserToAdmins);
  String get areYouSureWantToRemoveUserFromAdmins => _translate(str.areYouSureWantToRemoveUserFromAdmins);
  String get noAnyInventoryForRemovingStatistic => _translate(str.noAnyInventoryForRemovingStatistic);
  String get areYouSureWantToRemoveInventoryStatistic => _translate(str.areYouSureWantToRemoveInventoryStatistic);
  String get takenInventoryByUser => _translate(str.takenInventoryByUser);
  String get invalidData => _translate(str.invalidData);
}

class _QrLocalizationsDelegate
    extends LocalizationsDelegate<QrLocalizations> {
  const _QrLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'uk'].contains(locale.languageCode);
  }

  @override
  Future<QrLocalizations> load(Locale locale) async {
    QrLocalizations localizations = QrLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_QrLocalizationsDelegate old) => false;
}