import 'dart:math';
import 'dart:typed_data';

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

/// Not part of public API
extension Uint8ListX on Uint8List {
  /// Not part of public API
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  Uint8List view(int offset, int bytes) {
    return Uint8List.view(buffer, offsetInBytes + offset, bytes);
  }
}
