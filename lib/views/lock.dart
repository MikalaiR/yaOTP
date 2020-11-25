import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:yaotp/components/app_lock.dart';
import 'package:yaotp/components/screen_lock/screen_lock.dart';
import 'package:yaotp/controllers/settings.dart';
import 'package:yaotp/generated/l10n.dart';

class Lock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LockScreen(
      title: S.of(context).pleaseEnterPinCode,
      confirmTitle: S.of(context).pleaseConfirmPinCode,
      cancelText: S.of(context).cancel,
      correctString: null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onUnlocked: () {
        AppLock.of(context).didUnlock();
      },
      backgroundColorOpacity: 1,
      canCancel: false,
      canBiometric:
          Provider.of<SettingsController>(context).isBiometricsEnabled,
      showBiometricFirst:
          Provider.of<SettingsController>(context).isBiometricsEnabled,
      onValidate: (context, pin) async {
        return await Provider.of<SettingsController>(context, listen: false)
            .checkPinCode(pin);
      },
      biometricAuthenticate: (context) async {
        final localAuth = LocalAuthentication();

        try {
          final didAuthenticate = await localAuth.authenticateWithBiometrics(
              localizedReason: S.current.pleaseAuthenticate, stickyAuth: true);

          if (didAuthenticate) {
            return true;
          }

          return false;
        } on PlatformException catch (e) {
          return false;
        }
      },
    );
  }
}
