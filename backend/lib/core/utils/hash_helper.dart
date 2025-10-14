import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashHelper {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String password, String hash) {
    final passwordHash = hashPassword(password);
    return passwordHash == hash;
  }

  static String generateToken([int length = 32]) {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    final random = DateTime.now().microsecondsSinceEpoch.toString();
    final combined = '$now$random';
    final hash = sha256.convert(utf8.encode(combined));
    return hash.toString().substring(0, length);
  }
}
