import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:polarstar_flutter/session.dart';

String pwCrypto(String id, String pw) {
  var pwSalt = pw + id;
  var cryptedPw = sha512.convert(utf8.encode(pwSalt)).toString();

  for (int i = 0; i < 1000; i++) {
    cryptedPw = sha512.convert(utf8.encode(cryptedPw + id)).toString();
  }

  return cryptedPw;
}

String crypto_login(String id, String pw) {
  var salt = Session.cookies['salt'];
  salt = Uri.decodeComponent(salt);

  var pwSalt = pwCrypto(id, pw) + salt;

  var cryptedPw = sha512.convert(utf8.encode(pwSalt)).toString();

  for (int i = 0; i < 1000; i++) {
    cryptedPw = sha512.convert(utf8.encode(cryptedPw + salt)).toString();
  }

  return cryptedPw;
}

String crypto_sign_up(String id, String pw) {
  var pwSalt = pw + id;

  var cryptedPw = sha512.convert(utf8.encode(pwSalt)).toString();

  for (int i = 0; i < 1000; i++) {
    cryptedPw = sha512.convert(utf8.encode(cryptedPw + id)).toString();
  }

  return cryptedPw;
}
