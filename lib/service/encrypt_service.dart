import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class EncryptService {
  static final IV _iv = IV.fromUtf8("Jf3aZP9mQ2rH7tBxL8yVwC1nKdE4RpSs");
  static final Key _key = Key.fromUtf8("a7NQpF3xT2eB9mW6zR1kYhG5uV0sCjLd");

  static Codec<String, String> stringToBase64 = utf8.fuse(base64);

  static Encrypter get encrypter =>
      Encrypter(AES(_key, mode: AESMode.ofb64Gctr));

  static String encrypt(String data) {
    try {
      final encrypted = encrypter.encrypt(data, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      return "";
    }
  }

  static String decrypt(String data) {
    try {
      return encrypter.decrypt64(data, iv: _iv);
    } catch (e) {
      return "";
    }
  }
}
