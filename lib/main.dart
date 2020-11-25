import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yaotp/components/app_lock.dart';
import 'package:yaotp/controllers/otpcontroller.dart';
import 'package:yaotp/controllers/settings.dart';
import 'package:yaotp/generated/l10n.dart';
import 'package:yaotp/models/securtotp.dart';
import 'package:yaotp/views/form.dart';
import 'package:yaotp/views/home.dart';
import 'package:yaotp/views/lock.dart';
import 'package:yaotp/views/scan.dart';
import 'package:yaotp/views/settings.dart';

const String KEYCHAIN_KEY_ENCRYPTION_KEY = "encryption_key_000";
const String DB_NAME_SETTINGS = "db_settings_001";

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SecurTOTPAdapter());

  String base64key =
      await FlutterKeychain.get(key: KEYCHAIN_KEY_ENCRYPTION_KEY);

  if (base64key == null) {
    final newKey = Hive.generateSecureKey();
    base64key = base64.encode(newKey);
    await FlutterKeychain.put(
        key: KEYCHAIN_KEY_ENCRYPTION_KEY, value: base64key);
  }

  final key = base64.decode(base64key);

  await Hive.openBox(DB_NAME_SETTINGS, encryptionCipher: HiveAesCipher(key));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<OTPController>(
          create: (_) => OTPController(box: Hive.box(DB_NAME_SETTINGS))),
      ChangeNotifierProvider<SettingsController>(
          create: (_) => SettingsController(box: Hive.box(DB_NAME_SETTINGS))),
      StreamProvider<DateTime>.value(
          initialData: DateTime.now(),
          value: Stream.periodic(Duration(milliseconds: 100), (_) {
            return DateTime.now();
          }))
    ], child: MainWidget());
  }
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppLock(
      enabled: Provider.of<SettingsController>(context, listen: false)
          .isAuthenticationEnabled,
      builder: (_) => MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        title: 'yaOTP',
        initialRoute: '/',
        routes: {
          '/': (_) => Home(),
          '/settings': (_) => Settings(),
          '/form': (_) => OTPForm(),
          '/scan': (_) => QRScanner()
        },
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
      lockScreen: Lock(),
    );
  }
}
