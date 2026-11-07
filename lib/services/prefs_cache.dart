import 'package:shared_preferences/shared_preferences.dart';

/// Cached SharedPreferences singleton — prevents repeated disk I/O
/// from multiple `SharedPreferences.getInstance()` calls.
class PrefsCache {
  static SharedPreferences? _instance;

  /// Initialize once at app startup (in `main()`).
  static Future<void> init() async {
    _instance ??= await SharedPreferences.getInstance();
  }

  /// Returns the cached instance, initializing on first call if needed.
  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  /// Synchronous accessor — only safe after `init()` has completed.
  static SharedPreferences get sync {
    assert(
      _instance != null,
      'PrefsCache.init() must be called before using PrefsCache.sync',
    );
    return _instance!;
  }
}
