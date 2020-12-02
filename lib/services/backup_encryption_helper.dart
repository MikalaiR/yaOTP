import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/api.dart';
import 'package:pointycastle/export.dart';

/*
 * Backup format [bytes]:
 * [4] - iterations count, big endian
 * [4] - key length, big endian
 * [16] - pbkdf2 salt
 * [12] - aes-gcm nonce
 * [remaining] - encrypted data
 */

class BackupEncryptionHelperParam {
  String password;
  Uint8List data;

  BackupEncryptionHelperParam({this.password, this.data});
}

class BackupEncryptionHelper {
  static const int pbkdf2IterationsCount = 8192;
  static const int pbkdf2KeyLength = 32;

  static Uint8List int32BigEndianBytes(int value) =>
      Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

  static Uint8List deriveKey(
    String password, {
    Uint8List salt,
    int iterationsCount = pbkdf2IterationsCount,
    int keyLength = pbkdf2KeyLength,
  }) {
    final derivator = KeyDerivator("SHA-512/HMAC/PBKDF2")
      ..init(Pbkdf2Parameters(salt, iterationsCount, keyLength));

    return derivator.process(utf8.encode(password));
  }

  static Uint8List encrypt(String password, Uint8List data) {
    final Random random = Random.secure();
    final salt = random.nextBytes(16);

    final key = deriveKey(password, salt: salt);
    final nonce = random.nextBytes(12);

    final Uint8List header = Uint8List.fromList(
        int32BigEndianBytes(pbkdf2IterationsCount) +
            int32BigEndianBytes(pbkdf2KeyLength) +
            salt);

    final GCMBlockCipher cipher = GCMBlockCipher(AESFastEngine())
      ..init(true, AEADParameters(KeyParameter(key), 16 * 8, nonce, header));

    return Uint8List.fromList(header + nonce + cipher.process(data));
  }

  static Uint8List decrypt(String password, Uint8List data) {
    final header = Uint8List.sublistView(data, 0, 8 + 16);
    final nonce = Uint8List.sublistView(data, 8 + 16, 8 + 16 + 12);

    final iterationsCount = header.buffer.asByteData().getInt32(0, Endian.big);
    final keyLength = header.buffer.asByteData().getInt32(4, Endian.big);
    final salt = Uint8List.sublistView(header, 8, 8 + 16);

    final key = deriveKey(password,
        salt: salt, iterationsCount: iterationsCount, keyLength: keyLength);

    final GCMBlockCipher cipher = GCMBlockCipher(AESFastEngine())
      ..init(false, AEADParameters(KeyParameter(key), 16 * 8, nonce, header));

    return cipher.process(Uint8List.sublistView(data, 8 + 16 + 12));
  }

  static bool checkIsEncrypted(Uint8List data) {
    return String.fromCharCode(data[0]) != '[';
  }
}

Uint8List backupDecryptionBackgroundTask(BackupEncryptionHelperParam param) {
  return BackupEncryptionHelper.decrypt(param.password, param.data);
}

Uint8List backupEncryptionBackgroundTask(BackupEncryptionHelperParam param) {
  return BackupEncryptionHelper.encrypt(param.password, param.data);
}

/// Not part of public API
extension RandomX on Random {
  /// Not part of public API
  Uint8List nextBytes(int bytes) {
    var buffer = Uint8List(bytes);
    for (var i = 0; i < bytes; i++) {
      buffer[i] = nextInt(0xFF + 1);
    }
    return buffer;
  }
}
