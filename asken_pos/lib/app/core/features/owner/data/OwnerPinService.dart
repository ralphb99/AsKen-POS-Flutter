import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerPinService {
  static const String SaltKey = 'asken_pos.owner_pin.salt.v1';
  static const String HashKey = 'asken_pos.owner_pin.hash.v1';

  const OwnerPinService();

  Future<bool> HasConfiguredPin() async {
    final Preferences = await SharedPreferences.getInstance();
    return Preferences.getString(SaltKey) != null &&
        Preferences.getString(HashKey) != null;
  }

  Future<void> SetPin(String Pin) async {
    _ValidatePin(Pin);

    final Preferences = await SharedPreferences.getInstance();
    final Salt = _CreateSalt();

    await Preferences.setString(SaltKey, Salt);
    await Preferences.setString(HashKey, _HashPin(Pin, Salt));
  }

  Future<bool> VerifyPin(String Pin) async {
    _ValidatePin(Pin);

    final Preferences = await SharedPreferences.getInstance();
    final Salt = Preferences.getString(SaltKey);
    final StoredHash = Preferences.getString(HashKey);

    if (Salt == null || StoredHash == null) {
      return false;
    }

    return _HashPin(Pin, Salt) == StoredHash;
  }

  String _CreateSalt() {
    final RandomGenerator = Random.secure();
    final SaltBytes = List<int>.generate(
      32,
      (_) => RandomGenerator.nextInt(256),
    );

    return base64UrlEncode(SaltBytes);
  }

  String _HashPin(String Pin, String Salt) {
    return sha256.convert(utf8.encode('$Salt:$Pin')).toString();
  }

  void _ValidatePin(String Pin) {
    if (!RegExp(r'^\d{4,6}$').hasMatch(Pin)) {
      throw ArgumentError('PIN must contain 4 to 6 digits.');
    }
  }
}
