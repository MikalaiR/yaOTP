import 'package:dart_otp/dart_otp.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'securtotp.g.dart';

const List<String> supportedAlgorithms = ['SHA1', 'SHA256', 'SHA384', 'SHA512'];

OTPAlgorithm getAlgorithm(String algorithm) {
  if (algorithm == null) {
    return OTPAlgorithm.SHA1;
  }

  switch (algorithm) {
    case "SHA256":
      return OTPAlgorithm.SHA256;
    case "SHA1":
      return OTPAlgorithm.SHA1;
    case "SHA384":
      return OTPAlgorithm.SHA384;
    case "SHA512":
      return OTPAlgorithm.SHA512;
    default:
      return OTPAlgorithm.SHA1;
  }
}

@HiveType(typeId: 0)
class SecurTOTP extends HiveObject {
  @HiveField(0)
  final String algorithm;

  @HiveField(1)
  final int digits;

  @HiveField(2)
  final int interval;

  @HiveField(3)
  final String secret;

  @HiveField(4)
  final String issuer;

  @HiveField(5)
  final String accountName;

  @HiveField(6)
  final String imageUrl;

  SecurTOTP(
      {@required this.secret,
      this.algorithm = "SHA1",
      this.digits = 6,
      this.interval = 30,
      this.issuer = "Generic Issuer",
      this.accountName,
      this.imageUrl});

  SecurTOTP.fromJson(Map<String, dynamic> json)
      : algorithm = json['algorithm'],
        digits = json['digits'],
        interval = json['interval'],
        secret = json['secret'],
        issuer = json['issuer'],
        accountName = json['accountName'],
        imageUrl = json['imageUrl'];

  factory SecurTOTP.fromUri(String uri) {
    final parsedUri = Uri.parse(uri);
    final queryParams = parsedUri.queryParameters;

    var accountName =
        parsedUri.pathSegments.length > 0 ? parsedUri.pathSegments[0] : '';

    final secret = queryParams['secret'];
    var issuer = queryParams['issuer'];
    final digits = queryParams['digits'];
    final algorithm = queryParams['algorithm'];
    final interval = queryParams['period'];
    final imageUrl = queryParams['image'];

    if (secret == null) {
      return null;
    }

    if (issuer == null) {
      final arr = accountName.split(':');
      if (arr.length > 1) {
        issuer = arr[0];
        accountName = arr.sublist(1).join("");
      }
    }

    return SecurTOTP(
        secret: secret,
        digits: int.tryParse(digits) ?? 6,
        interval: int.tryParse(interval) ?? 30,
        algorithm: algorithm ?? "SHA1",
        issuer: issuer,
        accountName: accountName,
        imageUrl: imageUrl);
  }

  Map<String, dynamic> toJson() => {
        'algorithm': algorithm.toString(),
        'digits': digits,
        'interval': interval,
        'secret': secret,
        'issuer': issuer,
        'accountName': accountName,
        'imageUrl': imageUrl
      };

  String getTotp(DateTime current) {
    return TOTP(
      algorithm: getAlgorithm(algorithm),
      digits: digits,
      interval: interval,
      secret: secret,
    ).value(date: current);
  }

  @override
  String toString() {
    return "SecurOTP{ 'secret': ${this.secret}, "
        "'algorithm': ${this.algorithm}, "
        "'digits': ${this.digits}, "
        "'interval': ${this.interval}, "
        "'issuer': ${this.issuer}, "
        "'accountName': ${this.accountName} }";
  }
}
