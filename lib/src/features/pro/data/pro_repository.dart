import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

abstract interface class ProRepository {
  const ProRepository();

  int getShowCount();
  Future<void> saveShowCount(int value);
  Future<bool> getPro();
  Future<Offering?> getOffering(String identifier);
}

final class ProRepositoryImpl implements ProRepository {
  ProRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  int getShowCount() {
    return _prefs.getInt(Keys.showCount) ?? 0;
  }

  @override
  Future<void> saveShowCount(int value) async {
    await _prefs.setInt(Keys.showCount, value);
  }

  @override
  Future<bool> getPro() async {
    CustomerInfo customerInfo = await Purchases.getCustomerInfo().timeout(
      const Duration(seconds: 3),
    );
    return customerInfo.entitlements.active.isNotEmpty;
  }

  @override
  Future<Offering?> getOffering(String identifier) async {
    Offerings offerings = await Purchases.getOfferings().timeout(
      const Duration(seconds: 3),
    );
    return offerings.getOffering(identifier);
  }
}
