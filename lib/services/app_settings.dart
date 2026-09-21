import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:orderly_worker_web/models/weekly_archive.dart';

/// Ø­ÙØ¸ ÙˆØ§Ø³ØªØ±Ø¬Ø§Ø¹ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ (Ø±Ù‚Ù… ÙˆØ§ØªØ³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ±ØŒ Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª FirebaseØŒ ÙˆØ§Ù„ÙˆÙ‚Øª Ø§Ù„Ù…Ø¹ØªØ§Ø¯).
class AppSettings {
  const AppSettings._();

  // --- Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø±Ù‚Ù… ÙˆØ§ØªØ³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ± ---
  static const String whatsAppPhoneKey = 'whatsapp_phone';

  // --- Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø³Ø±ÙŠ (Admin PIN) ---
  static const String adminPinKey = 'admin_pin_code';
  static const String defaultAdminPin = '7777';

  // --- Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø§Ù„ØªØªØ¨Ø¹ ÙˆØ§Ù„Ø±Ø¨Ø· Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠ (Firebase) ---
  static const String firebaseDatabaseUrlKey = 'firebase_database_url';
  static const String expectedDurationKey = 'expected_delivery_duration_mins';
  static const String soundAlertsKey = 'sound_alerts_enabled';

  static Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Ù‚Ø±Ø§Ø¡Ø© Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø³Ø±ÙŠ (Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠ: 7777).
  static Future<String> getAdminPin() async {
    final SharedPreferences prefs = await _prefs;
    final String? pin = prefs.getString(adminPinKey);
    if (pin == null || pin.trim().isEmpty) {
      return defaultAdminPin;
    }
    return pin.trim();
  }

  /// Ø­ÙØ¸ / ØªØ¹Ø¯ÙŠÙ„ Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø³Ø±ÙŠ.
  static Future<void> setAdminPin(String newPin) async {
    final SharedPreferences prefs = await _prefs;
    final String clean = newPin.trim();
    if (clean.isNotEmpty) {
      await prefs.setString(adminPinKey, clean);
    }
  }

  /// Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† ØªØ·Ø§Ø¨Ù‚ Ø§Ù„Ø±Ù…Ø² Ø§Ù„Ù…Ø¯Ø®Ù„ Ù…Ø¹ Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ±.
  static Future<bool> verifyAdminPin(String enteredPin) async {
    final String current = await getAdminPin();
    return current == enteredPin.trim();
  }

  /// Ù‚Ø±Ø§Ø¡Ø© Ø±Ù‚Ù… Ù‡Ø§ØªÙ Ø§Ù„Ù…Ø¯ÙŠØ±/Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„Ù…Ø®Ø²Ù† Ø¨ØµÙŠØºØªÙ‡ Ø§Ù„Ø¯ÙˆÙ„ÙŠØ© (Ø¨Ø¯ÙˆÙ† +).
  static Future<String> getWhatsAppPhone() async {
    final SharedPreferences prefs = await _prefs;
    return (prefs.getString(whatsAppPhoneKey) ?? '').trim();
  }

  /// Ø­ÙØ¸ / ØªØ­Ø¯ÙŠØ« Ø±Ù‚Ù… Ù‡Ø§ØªÙ Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø­Ù„ÙŠ.
  static Future<void> setWhatsAppPhone(String phone) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(whatsAppPhoneKey, phone.trim());
  }

  /// Ù‚Ø±Ø§Ø¡Ø© Ø¹Ù†ÙˆØ§Ù† Ù‚Ø§Ø¹Ø¯Ø© Ø¨ÙŠØ§Ù†Ø§Øª Firebase Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ©.
  static Future<String> getFirebaseDatabaseUrl() async {
    final SharedPreferences prefs = await _prefs;
    return (prefs.getString(firebaseDatabaseUrlKey) ?? '').trim();
  }

  /// Ø­ÙØ¸ Ø¹Ù†ÙˆØ§Ù† Ù‚Ø§Ø¹Ø¯Ø© Ø¨ÙŠØ§Ù†Ø§Øª Firebase Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ©.
  static Future<void> setFirebaseDatabaseUrl(String url) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(firebaseDatabaseUrlKey, url.trim());
  }

  /// Ù…Ø¯Ø© Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø§Ù„Ù…Ø¹ØªØ§Ø¯Ø© Ø¨Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚ Ù„ÙƒØ´Ù Ø§Ù„ØªØ£Ø®ÙŠØ± ÙˆØ§Ù„ØªØ³Ø®ÙŠØª (Ø§ÙØªØ±Ø§Ø¶ÙŠØ§Ù‹ 25 Ø¯Ù‚ÙŠÙ‚Ø©).
  static Future<int> getExpectedDeliveryDuration() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(expectedDurationKey) ?? 25;
  }

  /// ØªØ¹Ø¯ÙŠÙ„ Ù…Ø¯Ø© Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø§Ù„Ù…Ø¹ØªØ§Ø¯Ø©.
  static Future<void> setExpectedDeliveryDuration(int minutes) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setInt(expectedDurationKey, minutes);
  }

  /// Ù‡Ù„ Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡Ø§Øª Ø§Ù„ØµÙˆØªÙŠØ© Ù„Ù„Ø·Ù„Ø¨Ø§Øª ÙˆØ§Ù„ØªØ³Ù„ÙŠÙ… Ù…ÙØ¹Ù„Ø©ØŸ
  static Future<bool> getSoundAlertsEnabled() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(soundAlertsKey) ?? true;
  }

  /// ØªÙØ¹ÙŠÙ„ / ÙƒØªÙ… Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡Ø§Øª Ø§Ù„ØµÙˆØªÙŠØ©.
  static Future<void> setSoundAlertsEnabled(bool enabled) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(soundAlertsKey, enabled);
  }

  // --- Ø§Ù„Ø£Ø±Ø´ÙŠÙ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠ ---
  static const String archivesKey = 'weekly_archives';

  /// Ø¬Ù…ÙŠØ¹ Ø§Ù„Ø£Ø±Ø´ÙŠÙØ§Øª Ø§Ù„Ù…Ø®Ø²Ù†Ø© (Ù…Ø±ØªÙ‘Ø¨Ø© Ù…Ù† Ø§Ù„Ø£Ø­Ø¯Ø« Ø¥Ù„Ù‰ Ø§Ù„Ø£Ù‚Ø¯Ù…).
  static Future<List<WeeklyArchive>> loadArchives() async {
    final SharedPreferences prefs = await _prefs;
    try {
      final String? raw = prefs.getString(archivesKey);
      if (raw == null || raw.trim().isEmpty) {
        return <WeeklyArchive>[];
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <WeeklyArchive>[];
      }
      return decoded
          .whereType<Map<Object?, Object?>>()
          .map(
            (Map<Object?, Object?> item) =>
                WeeklyArchive.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList()
          ..sort((WeeklyArchive a, WeeklyArchive b) =>
              b.periodEnd.compareTo(a.periodEnd));
    } catch (_) {
      return <WeeklyArchive>[];
    }
  }

  /// Ø­ÙØ¸ / Ø§Ø³ØªØ¨Ø¯Ø§Ù„ Ø§Ù„Ø£Ø±Ø´ÙŠÙØ§Øª.
  static Future<void> saveArchives(List<WeeklyArchive> archives) async {
    final SharedPreferences prefs = await _prefs;
    if (archives.isEmpty) {
      await prefs.remove(archivesKey);
      return;
    }
    final String payload = jsonEncode(
      archives.map((WeeklyArchive archive) => archive.toJson()).toList(),
    );
    await prefs.setString(archivesKey, payload);
  }

  /// Ø¥ØºÙ„Ø§Ù‚ ÙØªØ±Ø© Ø£Ø³Ø¨ÙˆØ¹ÙŠØ©: Ø£Ø±Ø´ÙØ© Ù…Ù„Ø®ØµÙ‡Ø§ Ø§Ù„Ø¢Ù†ØŒ Ø«Ù… Ø­Ø°Ù Ø§Ù„Ø£Ø±Ø´ÙŠÙØ§Øª Ø§Ù„Ø£Ù‚Ø¯Ù… Ù…Ù† Ø£Ø³Ø¨ÙˆØ¹.
  static Future<void> archiveWeek({
    required int totalOrders,
    required double totalAmount,
    required double totalWage,
    required double netAmount,
    required DateTime periodStart,
    required DateTime periodEnd,
  }) async {
    final List<WeeklyArchive> archives = await loadArchives();
    archives.add(
      WeeklyArchive(
        totalOrders: totalOrders,
        totalAmount: totalAmount,
        totalWage: totalWage,
        netAmount: netAmount,
        periodStart: periodStart,
        periodEnd: periodEnd,
      ),
    );
    await _pruneOld(archives);
  }

  /// Ø­Ø°Ù Ø§Ù„Ø£Ø±Ø´ÙŠÙØ§Øª Ø§Ù„ØªÙŠ Ù…Ø±Ù‘ Ø¹Ù„ÙŠÙ‡Ø§ Ø£ÙƒØ«Ø± Ù…Ù† 7 Ø£ÙŠØ§Ù… (ØªÙ†Ù‚ÙŠØ© Ø£Ø³Ø¨ÙˆØ¹ÙŠØ©).
  static Future<void> pruneOldArchives() async {
    final List<WeeklyArchive> archives = await loadArchives();
    await _pruneOld(archives);
  }

  static Future<void> _pruneOld(List<WeeklyArchive> archives) async {
    final DateTime cutoff = DateTime.now().subtract(const Duration(days: 7));
    final List<WeeklyArchive> kept = archives
        .where((WeeklyArchive archive) => !archive.createdAt.isBefore(cutoff))
        .toList();
    await saveArchives(kept);
  }

  /// Ù…Ø³Ø­ ÙƒÙ„ Ø§Ù„Ø£Ø±Ø´ÙŠÙØ§Øª ÙˆØ§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª (Ù„Ù„Ø§Ø®ØªØ¨Ø§Ø±Ø§Øª ÙÙ‚Ø·).
  static Future<void> clearAll() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(whatsAppPhoneKey);
    await prefs.remove(archivesKey);
    await prefs.remove(_lastNoticeKey);
    await prefs.remove(firebaseDatabaseUrlKey);
    await prefs.remove(expectedDurationKey);
    await prefs.remove(soundAlertsKey);
    await prefs.remove(adminPinKey);
    await prefs.remove('orderly_distributor_license_activated');
  }

  // --- ØªÙ†Ø¨ÙŠÙ‡ Ø£Ø³Ø¨ÙˆØ¹ÙŠ ---
  static const String _lastNoticeKey = 'weekly_notice_last_shown';

  /// Ø¢Ø®Ø± Ù…Ø±Ø© Ø¹Ø±Ø¶ ÙÙŠÙ‡Ø§ Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠ (Ø£Ùˆ ØªØ§Ø±ÙŠØ® Ø¨Ø¹ÙŠØ¯ Ø¥Ø°Ø§ Ù„Ù… ÙŠÙØ¹Ø±Ø¶ Ø£Ø¨Ø¯Ø§Ù‹).
  static Future<DateTime> getLastWeeklyNotice() async {
    final SharedPreferences prefs = await _prefs;
    final String? raw = prefs.getString(_lastNoticeKey);
    if (raw == null || raw.trim().isEmpty) {
      return DateTime(2000);
    }
    final DateTime? parsed = DateTime.tryParse(raw);
    return parsed ?? DateTime(2000);
  }

  /// ØªØ³Ø¬ÙŠÙ„ Ø£Ù† Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠ Ø¹ÙØ±Ø¶ ÙÙŠ [when].
  static Future<void> setLastWeeklyNotice(DateTime when) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_lastNoticeKey, when.toIso8601String());
  }
}
