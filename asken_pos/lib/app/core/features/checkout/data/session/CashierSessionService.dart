import 'package:shared_preferences/shared_preferences.dart';

class CashierSessionService {
  static const String CashierKey = 'asken_pos.active_cashier.v1';

  const CashierSessionService();

  Future<void> SaveCashierName(String CashierName) async {
    final Preferences = await SharedPreferences.getInstance();
    await Preferences.setString(CashierKey, CashierName.trim());
  }

  Future<String?> LoadCashierName() async {
    final Preferences = await SharedPreferences.getInstance();
    final CashierName = Preferences.getString(CashierKey)?.trim();

    if (CashierName == null || CashierName.isEmpty) {
      return null;
    }

    return CashierName;
  }

  Future<void> ClearCashierName() async {
    final Preferences = await SharedPreferences.getInstance();
    await Preferences.remove(CashierKey);
  }
}
