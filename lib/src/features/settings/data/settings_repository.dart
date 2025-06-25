import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants.dart';

abstract interface class SettingsRepository {
  const SettingsRepository();

  String getCurrency();
  Future<void> setCurrency(String currency);
}

final class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  @override
  String getCurrency() {
    return _prefs.getString(Keys.currency) ?? '\$';
  }

  @override
  Future<void> setCurrency(String currency) async {
    await _prefs.setString(Keys.currency, currency);
  }
}
