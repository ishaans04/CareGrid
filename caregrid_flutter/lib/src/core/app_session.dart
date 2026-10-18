import 'package:caregrid_client/caregrid_client.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../client.dart';
import 'live_feed.dart';

/// Sends the CareGrid bearer token with every call.
class TokenKeyProvider implements ClientAuthKeyProvider {
  String? token;

  @override
  Future<String?> get authHeaderValue async =>
      token == null ? null : wrapAsBearerAuthHeaderValue(token!);
}

/// Signed-in user state. The role decides which console the app shows.
class AppSession extends ChangeNotifier {
  AppSession._();

  static final instance = AppSession._();
  static const _tokenKey = 'caregrid.token';

  AppUser? user;
  bool restoring = true;

  TokenKeyProvider get _keys => client.authKeyProvider as TokenKeyProvider;

  /// Restores a stored token and validates it with the server.
  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token != null) {
      _keys.token = token;
      try {
        user = await client.account.me();
        LiveFeed.instance.start();
      } catch (_) {
        _keys.token = null;
        await prefs.remove(_tokenKey);
      }
    }
    restoring = false;
    notifyListeners();
  }

  Future<void> signIn(String handle, String pin) async {
    final result = await client.account.signIn(handle, pin);
    _keys.token = result.token;
    user = result.user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, result.token);
    LiveFeed.instance.start();
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await client.account.signOut();
    } catch (_) {
      // Signing out locally must work even when the server is unreachable.
    }
    LiveFeed.instance.stop();
    _keys.token = null;
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    notifyListeners();
  }
}
