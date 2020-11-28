import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:yaotp/models/securtotp.dart';

class OTPController with ChangeNotifier {
  Box<dynamic> box;

  UnmodifiableListView<SecurTOTP> _all;

  UnmodifiableListView<SecurTOTP> get all => _all ??=  UnmodifiableListView(
      box.values.where((element) => element is SecurTOTP).cast<SecurTOTP>());

  OTPController({this.box});

  @override
  void notifyListeners() {
    _all = null;
    super.notifyListeners();
  }

  Future<void> add(SecurTOTP otp) async {
    await box.add(otp);
    notifyListeners();
  }

  Future<void> delete(SecurTOTP otp) async {
    await box.delete(otp.key);
    notifyListeners();
  }

  Future<String> makeBackup() {
    return Future.sync(() => jsonEncode(all));
  }

  Future<void> loadBackup(String source) async {
    Iterable it = jsonDecode(source);
    it.map<SecurTOTP>((e) => SecurTOTP.fromJson(e)).forEach((element) {
      add(element);
    });
  }
}
