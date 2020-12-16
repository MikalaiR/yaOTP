import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:yaotp/components/app_lock.dart';
import 'package:yaotp/components/loading_overlay.dart';
import 'package:yaotp/components/password_dialog.dart';
import 'package:yaotp/components/screen_lock/screen_lock.dart';
import 'package:yaotp/generated/l10n.dart';
import 'package:yaotp/services/backup_encryption_helper.dart';
import 'package:yaotp/viewmodels/otp.dart';
import 'package:yaotp/viewmodels/settings.dart';

class Settings extends StatelessWidget {
  Future<String> showPasswordDialog(
      BuildContext context, bool isForEncryption) async {
    return showDialog(
      context: context,
      builder: (context) => EncryptionPasswordDialog(
        isForEncryption: isForEncryption,
      ),
    );
  }

  Future<void> doBackup(BuildContext context) async {
    final password = await showPasswordDialog(context, true);
    if (password == null) {
      return;
    }

    await LoadingOverlay.of(context).during(() async {
      final OTPListViewModel controller =
          Provider.of<OTPListViewModel>(context, listen: false);

      try {
        final Uint8List rawBackup = utf8.encode(await controller.makeBackup());

        if (password == '') {
          await FlutterFileDialog.saveFile(
              params: SaveFileDialogParams(
                  fileName: 'backup.json', data: rawBackup));
        } else {
          final encryptedBackup = await compute(
            backupEncryptionBackgroundTask,
            BackupEncryptionHelperParam(
              password: password,
              data: rawBackup,
            ),
          );

          FlutterFileDialog.saveFile(
            params: SaveFileDialogParams(
              fileName: 'backup.json.aes',
              data: encryptedBackup,
            ),
          );
        }

        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(S.of(context).backupSuccessfullySaved),
            ),
          );
      } catch (e) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(S.of(context).somethingWentWrong + e.toString()),
            ),
          );
      }
    }());
  }

  Future<void> doImport(BuildContext context) async {
    try {
      final filePath = await FlutterFileDialog.pickFile(
        params: OpenFileDialogParams(
          dialogType: OpenFileDialogType.document,
        ),
      );

      if (filePath == null) {
        return;
      }

      final pickedFile = File(filePath);
      final raw = await pickedFile.readAsBytes();

      Uint8List rawBackup;

      if (BackupEncryptionHelper.checkIsEncrypted(raw)) {
        final password = await showPasswordDialog(context, false);
        if (password == null) {
          return;
        }

        rawBackup = await LoadingOverlay.of(context).during(compute(
            backupDecryptionBackgroundTask,
            BackupEncryptionHelperParam(password: password, data: raw)));
      } else {
        rawBackup = raw;
      }

      await Provider.of<OTPListViewModel>(context, listen: false)
          .loadBackup(utf8.decode(rawBackup));

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).successfullyImported),
          ),
        );
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(S.of(context).wrongPasswordOrBrokenFile),
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text(S.of(context).somethingWentWrong + e.toString()),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<bool> isBiometricsAvailable =
        LocalAuthentication().canCheckBiometrics;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, settingsController, _) => ListView(
          children: <Widget>[
            SwitchListTile(
              secondary: Icon(Icons.visibility_off),
              title: Text(S.of(context).hideCodes),
              value: settingsController.isCodesHidden,
              onChanged: (bool val) async {
                settingsController.setCodesHidden(val);
              },
            ),
            Divider(height: 1),
            SwitchListTile(
              secondary: Icon(Icons.security),
              title: Text(S.of(context).usePinCode),
              value: settingsController.isAuthenticationEnabled,
              onChanged: (bool val) async {
                if (val) {
                  await showConfirmPasscode(
                    title: S.of(context).pleaseEnterPinCode,
                    confirmTitle: S.of(context).pleaseConfirmPinCode,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    backgroundColorOpacity: 1,
                    context: context,
                    onCompleted: (_, pin) async {
                      await settingsController.setPinCode(pin);
                      AppLock.of(context).enable();
                      Navigator.of(context).maybePop();
                    },
                  );
                } else {
                  await settingsController.setPinCode(null);
                  AppLock.of(context).disable();
                }
              },
            ),
            FutureBuilder<bool>(
              future: isBiometricsAvailable,
              builder: (BuildContext context, AsyncSnapshot<bool> canCheck) =>
                  SwitchListTile(
                secondary: Icon(Icons.fingerprint),
                title: Text(S.of(context).useBiometrics),
                value: settingsController.isAuthenticationEnabled &&
                    settingsController.isBiometricsEnabled &&
                    canCheck.hasData &&
                    canCheck.data,
                onChanged: settingsController.isAuthenticationEnabled &&
                        canCheck.hasData &&
                        canCheck.data
                    ? (bool val) async {
                        await settingsController.setBiometricsEnabled(val);
                      }
                    : null,
              ),
            ),
            Divider(height: 1),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text(S.of(context).makeBackup),
              onTap: () => doBackup(context),
            ),
            ListTile(
              leading: Icon(Icons.settings_backup_restore),
              title: Text(S.of(context).importFromBackup),
              onTap: () => doImport(context),
            )
          ],
        ),
      ),
    );
  }
}
