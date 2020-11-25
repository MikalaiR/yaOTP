import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class SettingsController with ChangeNotifier {
  static const String DB_KEY_PIN_CODE = "pinCode";
  static const String DB_KEY_IS_BIOMETRICS_ENABLED = "use_biometrics";

  Box<dynamic> box;

  SettingsController({this.box});

  bool get isAuthenticationEnabled {
    return box.get(DB_KEY_PIN_CODE, defaultValue: null) != null;
  }

  Future<void> setPinCode(String pin) async {
    if (pin == null) {
      await box.put(DB_KEY_PIN_CODE, null);
    } else {
      await box.put(DB_KEY_PIN_CODE, pin);
    }
    notifyListeners();
  }

  Future<bool> checkPinCode(String pin) async {
    final pin2 = box.get(DB_KEY_PIN_CODE, defaultValue: null);
    if (pin2 == null) {
      return false;
    }

    return pin == pin2;
  }

  bool get isBiometricsEnabled {
    return box.get(DB_KEY_IS_BIOMETRICS_ENABLED, defaultValue: false);
  }

  Future<void> setBiometricsEnabled(bool v) async {
    await box.put(DB_KEY_IS_BIOMETRICS_ENABLED, v);
    notifyListeners();
  }
}
