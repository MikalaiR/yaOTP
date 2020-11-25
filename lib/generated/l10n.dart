// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Wrong password or broken file`
  String get wrongPasswordOrBrokenFile {
    return Intl.message(
      'Wrong password or broken file',
      name: 'wrongPasswordOrBrokenFile',
      desc: '',
      args: [],
    );
  }

  /// `Successfully imported`
  String get successfullyImported {
    return Intl.message(
      'Successfully imported',
      name: 'successfullyImported',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong: `
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong: ',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Backup successfully saved`
  String get backupSuccessfullySaved {
    return Intl.message(
      'Backup successfully saved',
      name: 'backupSuccessfullySaved',
      desc: '',
      args: [],
    );
  }

  /// `Import from backup`
  String get importFromBackup {
    return Intl.message(
      'Import from backup',
      name: 'importFromBackup',
      desc: '',
      args: [],
    );
  }

  /// `Make backup`
  String get makeBackup {
    return Intl.message(
      'Make backup',
      name: 'makeBackup',
      desc: '',
      args: [],
    );
  }

  /// `Use biometrics`
  String get useBiometrics {
    return Intl.message(
      'Use biometrics',
      name: 'useBiometrics',
      desc: '',
      args: [],
    );
  }

  /// `Use PIN code`
  String get usePinCode {
    return Intl.message(
      'Use PIN code',
      name: 'usePinCode',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Wrong QR code format.`
  String get wrongQrCodeFormat {
    return Intl.message(
      'Wrong QR code format.',
      name: 'wrongQrCodeFormat',
      desc: '',
      args: [],
    );
  }

  /// `Secret key`
  String get secretKey {
    return Intl.message(
      'Secret key',
      name: 'secretKey',
      desc: '',
      args: [],
    );
  }

  /// `eg: JBSWY3DPEHPK3PXP`
  String get secureKeyHintText {
    return Intl.message(
      'eg: JBSWY3DPEHPK3PXP',
      name: 'secureKeyHintText',
      desc: '',
      args: [],
    );
  }

  /// `Account Name`
  String get accountName {
    return Intl.message(
      'Account Name',
      name: 'accountName',
      desc: '',
      args: [],
    );
  }

  /// `Issuer`
  String get issuer {
    return Intl.message(
      'Issuer',
      name: 'issuer',
      desc: '',
      args: [],
    );
  }

  /// `interval`
  String get interval {
    return Intl.message(
      'interval',
      name: 'interval',
      desc: '',
      args: [],
    );
  }

  /// `Digits`
  String get digits {
    return Intl.message(
      'Digits',
      name: 'digits',
      desc: '',
      args: [],
    );
  }

  /// `Algorithm`
  String get algorithm {
    return Intl.message(
      'Algorithm',
      name: 'algorithm',
      desc: '',
      args: [],
    );
  }

  /// `Icon URL`
  String get iconUrl {
    return Intl.message(
      'Icon URL',
      name: 'iconUrl',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR code`
  String get scanQrCode {
    return Intl.message(
      'Scan QR code',
      name: 'scanQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Grant camera access to proceed`
  String get grantCameraAccessToProceed {
    return Intl.message(
      'Grant camera access to proceed',
      name: 'grantCameraAccessToProceed',
      desc: '',
      args: [],
    );
  }

  /// `Enter a provided key`
  String get enterAProvidedKey {
    return Intl.message(
      'Enter a provided key',
      name: 'enterAProvidedKey',
      desc: '',
      args: [],
    );
  }

  /// `Please authenticate`
  String get pleaseAuthenticate {
    return Intl.message(
      'Please authenticate',
      name: 'pleaseAuthenticate',
      desc: '',
      args: [],
    );
  }

  /// `Add new account`
  String get addNewAccount {
    return Intl.message(
      'Add new account',
      name: 'addNewAccount',
      desc: '',
      args: [],
    );
  }

  /// `Field cannot be empty`
  String get fieldCannotBeEmpty {
    return Intl.message(
      'Field cannot be empty',
      name: 'fieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `The entered secret is invalid`
  String get theEnteredSecretIsInvalid {
    return Intl.message(
      'The entered secret is invalid',
      name: 'theEnteredSecretIsInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter PIN code`
  String get pleaseEnterPinCode {
    return Intl.message(
      'Please enter PIN code',
      name: 'pleaseEnterPinCode',
      desc: '',
      args: [],
    );
  }

  /// `OTP has been copied to clipboard`
  String get otpHasBeenCopiedToClipboard {
    return Intl.message(
      'OTP has been copied to clipboard',
      name: 'otpHasBeenCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm PIN code`
  String get pleaseConfirmPinCode {
    return Intl.message(
      'Please confirm PIN code',
      name: 'pleaseConfirmPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `eg: Google`
  String get issuerHintText {
    return Intl.message(
      'eg: Google',
      name: 'issuerHintText',
      desc: '',
      args: [],
    );
  }

  /// `eg: https://google.com/favicon.ico`
  String get imageUrlHintText {
    return Intl.message(
      'eg: https://google.com/favicon.ico',
      name: 'imageUrlHintText',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Empty to leave unencrypted`
  String get emptyToLeaveUnencrypted {
    return Intl.message(
      'Empty to leave unencrypted',
      name: 'emptyToLeaveUnencrypted',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}