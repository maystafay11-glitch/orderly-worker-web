/// Ø®Ø¯Ù…Ø© Ø¯Ù„ÙŠÙ„ Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ù…ÙˆØ¸ÙÙŠÙ† (Ø§Ù„Ø¹Ù…Ø§Ù„ ÙˆØ§Ù„Ù…Ø¯Ø±Ø§Ø¡) Ù…Ø¹Ø²ÙˆÙ„Ø© Ø¨Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù….
///
/// **Ù‡ÙŠÙƒÙ„ Ø§Ù„ØªØ®Ø²ÙŠÙ† (Ù…Ø­Ù„ÙŠØ§Ù‹ ÙˆØ³Ø­Ø§Ø¨ÙŠØ§Ù‹ Ø¨Ù†ÙØ³ Ø§Ù„Ù…Ø³Ø§Ø±Ø§Øª):**
/// ```
/// restaurants/{restaurant_id}/staff/{staff_id}   â† ÙÙŠ Firebase Realtime DB
/// orderly.staff_directory â†’ { "<rid>": { "<staffId>": {...} } }  â† Ù…Ø­Ù„ÙŠØ§Ù‹
/// ```
///
/// **Ø¶Ù…Ø§Ù†Ø§Øª Ø§Ù„Ù†Ø¸Ø§Ù…:**
/// 1. ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„ ÙŠØªØ·Ù„Ø¨ (Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… + Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… + ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø£Ùˆ PIN).
/// 2. ÙŠÙØ³Ù…Ø­ Ø¨ØªØ´Ø§Ø¨Ù‡ Ø§Ù„Ø£Ø³Ù…Ø§Ø¡ ÙˆÙƒÙ„Ù…Ø§Øª Ø§Ù„Ù…Ø±ÙˆØ± Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠØ© Ø¨ÙŠÙ† Ù…Ø·Ø¹Ù…ÙŠÙ† Ù…Ø®ØªÙ„ÙÙŠÙ†ØŒ
///    Ù„Ø£Ù† Ø§Ù„Ø¨Ø­Ø« ÙŠÙ‚ØªØµØ± Ø­ØµØ±Ø§Ù‹ Ø¹Ù„Ù‰ Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ù…ÙˆØ¬ÙˆØ¯Ø© ØªØ­Øª Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„Ù…Ø¯Ø®Ù„.
/// 3. ÙƒÙ„Ù…Ø§Øª Ø§Ù„Ù…Ø±ÙˆØ± Ù„Ø§ ØªÙØ®Ø²ÙŽÙ‘Ù† Ù†ØµØ§Ù‹ Ø£Ø¨Ø¯Ø§Ù‹ â€” Ø¨ØµÙ…Ø© SHA-256 Ù…Ø¹ Ù…Ù„Ø­ Ø¹Ø´ÙˆØ§Ø¦ÙŠ.
/// 4. ØªØ²ÙˆÙŠØ¯ ØªÙ„Ù‚Ø§Ø¦ÙŠ: Ø­Ø³Ø§Ø¨ Ù…Ø¯ÙŠØ± (Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… `manager` ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± = Ø±Ù…Ø²
///    Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø­Ø§Ù„ÙŠ) ÙˆØ­Ø³Ø§Ø¨ Ø¹Ø§Ù…Ù„ Ù„ÙƒÙ„ Ø³Ø§Ø¦Ù‚ (ÙƒÙ„Ù…Ø© Ù…Ø±ÙˆØ± Ø§ÙØªØ±Ø§Ø¶ÙŠØ© `1234`).
library;

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:orderly_worker_web/models/driver.dart';
import 'package:orderly_worker_web/models/staff_member.dart';
import 'package:orderly_worker_web/services/app_settings.dart';
import 'package:orderly_worker_web/services/driver_storage.dart';

/// Ù†ØªÙŠØ¬Ø© Ù…Ø­Ø§ÙˆÙ„Ø© Ù…ØµØ§Ø¯Ù‚Ø©/ØªØ³Ø¬ÙŠÙ„ Ø­Ø³Ø§Ø¨ Ù…ÙˆØ¸Ù.
class StaffAuthResult {
  const StaffAuthResult({required this.success, this.staff, this.message});

  factory StaffAuthResult.success(StaffMember staff, [String? message]) =>
      StaffAuthResult(success: true, staff: staff, message: message);

  factory StaffAuthResult.failure(String message) =>
      StaffAuthResult(success: false, message: message);

  final bool success;
  final StaffMember? staff;
  final String? message;
}

class StaffDirectoryService {
  const StaffDirectoryService._();

  /// Ù…ÙØªØ§Ø­ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„Ù…Ø­Ù„ÙŠ ÙÙŠ SharedPreferences (Ù…Ù‚Ø³Ù‘Ù… Ø­Ø³Ø¨ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù…).
  static const String directoryKey = 'orderly.staff_directory';

  /// Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠ Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ±.
  static const String defaultManagerUsername = 'manager';

  /// Ø§Ù„Ø§Ø³Ù… Ø§Ù„Ù…Ø¹Ø±ÙˆØ¶ Ù„Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠ.
  static const String defaultManagerName = 'Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø·Ø¹Ù…';

  /// ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠØ© Ù„Ù„Ø¹Ù…Ø§Ù„ Ø¹Ù†Ø¯ Ø§Ù„ØªØ²ÙˆÙŠØ¯ Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ.
  /// ØªØªØ·Ø§Ø¨Ù‚ Ø¹Ø§Ø¯Ø©Ù‹ Ø¨ÙŠÙ† Ø§Ù„Ù…Ø·Ø§Ø¹Ù… Ø§Ù„Ù…Ø®ØªÙ„ÙØ© â€” ÙˆÙ‡Ø°Ø§ Ù…Ù‚ØµÙˆØ¯ ÙˆØ¢Ù…Ù† Ù„Ø£Ù† Ø§Ù„Ø¨Ø­Ø«
  /// Ù…Ø±ØªØ¨Ø· Ø­ØµØ±Ø§Ù‹ Ø¨Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„Ù…Ø¯Ø®Ù„ Ø¹Ù†Ø¯ ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„.
  static const String defaultWorkerPassword = '1234';

  /// Ø±Ø§Ø¨Ø· Ù‚Ø§Ø¹Ø¯Ø© Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ø®ØªÙŠØ§Ø±ÙŠ ÙŠÙØ®Ø¨ÙŽØ² ÙÙŠ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ Ø¹Ù†Ø¯ Ø§Ù„Ø¨Ù†Ø§Ø¡ (Ù„Ù„Ù…ÙˆØ²Ù‘Ø¹ SaaS).
  /// ÙŠÙØ³ØªØ®Ø¯Ù… ÙÙ‚Ø· Ø¥Ø°Ø§ Ù„Ù… ÙŠÙØ¯Ø®Ù„ Ø§Ù„Ù…Ø¯ÙŠØ± Ø±Ø§Ø¨Ø·Ø§Ù‹ ÙÙŠ Ø´Ø§Ø´Ø© Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª.
  /// Ø§ØªØ±ÙƒÙ‡ ÙØ§Ø±ØºØ§Ù‹ Ù„ØªØ¹ØªÙ…Ø¯ Ø§Ù„Ø®Ø¯Ù…Ø© Ø¹Ù„Ù‰ Ø§Ù„Ø±Ø§Ø¨Ø· Ø§Ù„Ù…ÙØ¯Ø®Ù„ ÙÙŠ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª ÙÙ‚Ø·.
  static const String defaultDatabaseUrl = '';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  /// Ù…Ø³Ø§Ø± Ø§Ù„Ø­Ø³Ø§Ø¨ Ø¯Ø§Ø®Ù„ Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª (Ù„Ù„Ø¹Ø±Ø¶ ÙˆØ§Ù„ØªÙˆØ«ÙŠÙ‚).
  static String staffPath(String restaurantId, String staffId) =>
      'restaurants/${_normalizeRid(restaurantId)}/staff/$staffId';

  static String _normalizeRid(String raw) =>
      StaffMember.normalizeRestaurantId(raw);

  /// Ù‚Ø±Ø§Ø¡Ø© Ø±Ø§Ø¨Ø· Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª (Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª Ø£ÙˆÙ„Ø§Ù‹ Ø«Ù… Ø§Ù„Ø±Ø§Ø¨Ø· Ø§Ù„Ù…Ø®Ø¨ÙˆØ²).
  static Future<String> resolveDatabaseUrl() async {
    final String configured = await AppSettings.getFirebaseDatabaseUrl();
    if (configured.isNotEmpty) return configured;
    return defaultDatabaseUrl;
  }

  // â”€â”€â”€ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„Ù…Ø­Ù„ÙŠ (Ù…Ù‚Ø³Ù‘Ù… Ø­Ø³Ø¨ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù…) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Ù‚Ø±Ø§Ø¡Ø© Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„ÙƒØ§Ù…Ù„: { Ù…Ø¹Ø±Ù_Ø§Ù„Ù…Ø·Ø¹Ù…: { Ù…Ø¹Ø±Ù_Ø§Ù„Ø­Ø³Ø§Ø¨: Ø¨ÙŠØ§Ù†Ø§Øª } }.
  static Future<Map<String, Map<String, Map<String, dynamic>>>> _loadAll() async {
    final SharedPreferences prefs = await _prefs;
    final String? raw = prefs.getString(directoryKey);
    if (raw == null || raw.trim().isEmpty) {
      return <String, Map<String, Map<String, dynamic>>>{};
    }
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return <String, Map<String, Map<String, dynamic>>>{};
      }
      return decoded.map(
        (Object? rid, Object? bucket) => MapEntry<String,
            Map<String, Map<String, dynamic>>>(
          rid.toString(),
          bucket is Map
              ? bucket.map(
                  (Object? id, Object? account) => MapEntry<String,
                      Map<String, dynamic>>(
                    id.toString(),
                    account is Map
                        ? Map<String, dynamic>.from(account)
                        : <String, dynamic>{},
                  ),
                )
              : <String, Map<String, dynamic>>{},
        ),
      );
    } catch (_) {
      return <String, Map<String, Map<String, dynamic>>>{};
    }
  }

  /// Ø­ÙØ¸ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„ÙƒØ§Ù…Ù„ Ù…Ø­Ù„ÙŠØ§Ù‹.
  static Future<void> _saveAll(
    Map<String, Map<String, Map<String, dynamic>>> all,
  ) async {
    final SharedPreferences prefs = await _prefs;
    if (all.isEmpty) {
      await prefs.remove(directoryKey);
      return;
    }
    await prefs.setString(directoryKey, jsonEncode(all));
  }

  /// ØªØ­Ù…ÙŠÙ„ Ø­Ø³Ø§Ø¨Ø§Øª Ù…ÙˆØ¸ÙÙŠ Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯ ÙÙ‚Ø· (Ø¹Ø²Ù„ ØªØ§Ù… Ø¨ÙŠÙ† Ø§Ù„Ù…Ø·Ø§Ø¹Ù…).
  static Future<List<StaffMember>> loadStaff(String restaurantId) async {
    final String rid = _normalizeRid(restaurantId);
    if (rid.isEmpty) return <StaffMember>[];
    final Map<String, Map<String, Map<String, dynamic>>> all = await _loadAll();
    final Map<String, Map<String, dynamic>> bucket =
        all[rid] ?? const <String, Map<String, dynamic>>{};
    final List<StaffMember> staff = bucket.values
        .where((Map<String, dynamic> json) => json.isNotEmpty)
        .map(StaffMember.fromJson)
        .toList();
    staff.sort((StaffMember a, StaffMember b) {
      if (a.isManager != b.isManager) return a.isManager ? -1 : 1;
      return a.name.compareTo(b.name);
    });
    return staff;
  }

  /// Ø­ÙØ¸ (Ø¥Ø¶Ø§ÙØ©/ØªØ­Ø¯ÙŠØ«) Ø­Ø³Ø§Ø¨Ø§Øª Ù„Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯ Ù…Ø¹ Ø¯ÙØ¹Ù‡Ø§ Ø³Ø­Ø§Ø¨ÙŠØ§Ù‹ Ø§Ø®ØªÙŠØ§Ø±ÙŠØ§Ù‹.
  static Future<void> saveStaff(
    String restaurantId,
    List<StaffMember> staff, {
    bool pushToCloud = true,
  }) async {
    final String rid = _normalizeRid(restaurantId);
    if (rid.isEmpty) return;
    final Map<String, Map<String, Map<String, dynamic>>> all = await _loadAll();
    final Map<String, Map<String, dynamic>> bucket = Map<String,
        Map<String, dynamic>>.of(all[rid] ?? <String, Map<String, dynamic>>{});
    for (final StaffMember member in staff) {
      bucket[member.staffId] = member.toJson();
    }
    all[rid] = bucket;
    await _saveAll(all);
    if (pushToCloud) {
      for (final StaffMember member in staff) {
        await _pushToCloud(rid, member);
      }
    }
  }

  /// Ø§Ù„Ø¨Ø­Ø« Ø¹Ù† Ø­Ø³Ø§Ø¨ Ø¨Ø§Ù„Ù…Ø¹Ø±Ù Ø¯Ø§Ø®Ù„ Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯.
  static Future<StaffMember?> findById(
    String restaurantId,
    String staffId,
  ) async {
    final List<StaffMember> staff = await loadStaff(restaurantId);
    for (final StaffMember member in staff) {
      if (member.staffId == staffId) return member;
    }
    return null;
  }

  /// Ø§Ù„Ø¨Ø­Ø« Ø¹Ù† Ø­Ø³Ø§Ø¨ Ø¨Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… (Ø£Ùˆ Ø§Ù„Ø§Ø³Ù… Ø§Ù„Ù…Ø¹Ø±ÙˆØ¶) Ø¯Ø§Ø®Ù„ Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯ ÙÙ‚Ø·.
  static Future<StaffMember?> findByUsername(
    String restaurantId,
    String usernameOrName,
  ) async {
    final String needle = StaffMember.normalizeUsername(usernameOrName);
    if (needle.isEmpty) return null;
    final List<StaffMember> staff = await loadStaff(restaurantId);
    for (final StaffMember member in staff) {
      if (StaffMember.normalizeUsername(member.username) == needle ||
          StaffMember.normalizeUsername(member.name) == needle) {
        return member;
      }
    }
    return null;
  }



  // â”€â”€â”€ Ø§Ù„ØªØ³Ø¬ÙŠÙ„ ÙˆØªØºÙŠÙŠØ± ÙƒÙ„Ù…Ø§Øª Ø§Ù„Ù…Ø±ÙˆØ± â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// ØªØ³Ø¬ÙŠÙ„ Ø­Ø³Ø§Ø¨ Ù…ÙˆØ¸Ù Ø¬Ø¯ÙŠØ¯ Ø¯Ø§Ø®Ù„ Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯.
  ///
  /// * Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… ÙØ±ÙŠØ¯ **Ø¯Ø§Ø®Ù„ Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„ÙˆØ§Ø­Ø¯ ÙÙ‚Ø·** â€” Ù„Ø§ Ù…Ø§Ù†Ø¹ Ù…Ù† ØªÙƒØ±Ø§Ø±Ù‡
  ///   ÙÙŠ Ù…Ø·Ø¹Ù… Ø¢Ø®Ø± (Ø§Ù„Ù…Ø¹Ø±Ù‘ÙØ§Ù† Ù…Ø®ØªÙ„ÙØ§Ù† â†’ Ù…Ø³Ø§Ø±Ø§Ù† Ù…Ø®ØªÙ„ÙØ§Ù† ØªÙ…Ø§Ù…Ø§Ù‹).
  /// * ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ØªÙØ®Ø²ÙŽÙ‘Ù† Ø¨ØµÙ…Ø© Ù…Ø´ÙØ±Ø© ÙÙ‚Ø·.
  static Future<StaffAuthResult> registerStaff({
    required String restaurantId,
    required String name,
    required String username,
    required String password,
    StaffRole role = StaffRole.worker,
    String pin = '',
    String driverPin = '',
    bool autoProvisioned = false,
  }) async {
    final String rid = _normalizeRid(restaurantId);
    final String displayName = name.trim();
    final String uname = username.trim();
    final String secret = password.trim();

    if (rid.isEmpty) {
      return StaffAuthResult.failure('Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ù…Ø·Ù„ÙˆØ¨ Ù„Ø¥Ù†Ø´Ø§Ø¡ Ø§Ù„Ø­Ø³Ø§Ø¨.');
    }
    if (displayName.isEmpty) {
      return StaffAuthResult.failure('ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ù…ÙˆØ¸Ù.');
    }
    if (uname.isEmpty) {
      return StaffAuthResult.failure('ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù….');
    }
    if (secret.length < 4) {
      return StaffAuthResult.failure(
          'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ÙŠØ¬Ø¨ Ø£Ù† ØªØªÙƒÙˆÙ† Ù…Ù† 4 Ø®Ø§Ù†Ø§Øª Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„.');
    }

    final StaffMember? existing = await findByUsername(rid, uname);
    if (existing != null) {
      return StaffAuthResult.failure(
          'Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… Â«$unameÂ» Ù…Ø³ØªØ®Ø¯Ù… Ø¨Ø§Ù„ÙØ¹Ù„ Ø¯Ø§Ø®Ù„ Ù‡Ø°Ø§ Ø§Ù„Ù…Ø·Ø¹Ù….');
    }

    final StaffMember member = StaffMember(
      staffId: StaffMember.buildStaffId(rid, uname),
      restaurantId: rid,
      name: displayName,
      username: uname,
      role: role,
      pin: pin.trim(),
      driverPin: driverPin.trim(),
      active: true,
      autoProvisioned: autoProvisioned,
      createdAtMs: DateTime.now().millisecondsSinceEpoch,
    ).withNewPassword(secret);

    await saveStaff(rid, <StaffMember>[member]);
    return StaffAuthResult.success(member);
  }

  /// ØªØ¹ÙŠÙŠÙ† ÙƒÙ„Ù…Ø© Ù…Ø±ÙˆØ± Ø¬Ø¯ÙŠØ¯Ø© Ù„Ø­Ø³Ø§Ø¨ (ÙŠØ­ÙˆÙ‘Ù„Ù‡ Ù„Ø­Ø³Ø§Ø¨ Ù…ÙØ¯Ø§Ø± ÙŠØ¯ÙˆÙŠØ§Ù‹).
  static Future<StaffAuthResult> setPassword(
    String restaurantId,
    String staffId,
    String newPassword, {
    String? newPin,
  }) async {
    final String rid = _normalizeRid(restaurantId);
    final String secret = newPassword.trim();
    if (rid.isEmpty) {
      return StaffAuthResult.failure('Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ù…Ø·Ù„ÙˆØ¨.');
    }
    if (secret.length < 4) {
      return StaffAuthResult.failure(
          'ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ÙŠØ¬Ø¨ Ø£Ù† ØªØªÙƒÙˆÙ† Ù…Ù† 4 Ø®Ø§Ù†Ø§Øª Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„.');
    }
    final StaffMember? existing = await findById(rid, staffId);
    if (existing == null) {
      return StaffAuthResult.failure('Ø§Ù„Ø­Ø³Ø§Ø¨ ØºÙŠØ± Ù…ÙˆØ¬ÙˆØ¯ Ù„Ù‡Ø°Ø§ Ø§Ù„Ù…Ø·Ø¹Ù….');
    }
    StaffMember updated = existing
        .withNewPassword(secret)
        .copyWith(autoProvisioned: false);
    if (newPin != null) {
      updated = updated.copyWith(pin: newPin.trim());
    }
    await saveStaff(rid, <StaffMember>[updated]);
    return StaffAuthResult.success(updated, 'ØªÙ… ØªØ­Ø¯ÙŠØ« ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø¨Ù†Ø¬Ø§Ø­.');
  }

  // â”€â”€â”€ Ø§Ù„ØªØ²ÙˆÙŠØ¯ Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ (Manager + Workers) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Ø¶Ù…Ø§Ù† Ø¬Ø§Ù‡Ø²ÙŠØ© Ø­Ø³Ø§Ø¨Ø§Øª ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„ Ù„Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯:
  /// 1. Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ±: Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… [defaultManagerUsername] ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± =
  ///    Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø­Ø§Ù„ÙŠ (ÙŠØªØ²Ø§Ù…Ù† ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹ Ø¹Ù†Ø¯ ØªØºÙŠÙŠØ± Ø§Ù„Ø±Ù…Ø² ÙÙŠ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª).
  /// 2. Ø­Ø³Ø§Ø¨ Ø¹Ø§Ù…Ù„ Ù„ÙƒÙ„ Ø³Ø§Ø¦Ù‚: Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… = Ø§Ø³Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚ØŒ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠØ©
  ///    [defaultWorkerPassword]ØŒ ÙˆØ±Ù…Ø² PIN = Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ (1001-1030).
  /// 3. Ø­Ø°Ù Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠØ© Ù„Ø¹Ù…Ø§Ù„ Ø­ÙØ°ÙÙˆØ§ Ù…Ù† Ø§Ù„Ù‚Ø§Ø¦Ù…Ø©.
  /// 4. Ø¯ÙØ¹ ÙƒÙ„ Ø§Ù„ØªØºÙŠÙŠØ±Ø§Øª Ø³Ø­Ø§Ø¨ÙŠØ§Ù‹ Ø¹Ù†Ø¯ ØªÙˆÙØ± Ø±Ø§Ø¨Ø· Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª.
  ///
  /// Ø§Ù„Ø¯Ø§Ù„Ø© idempotent (Ø¢Ù…Ù†Ø© Ù„Ù„Ø§Ø³ØªØ¯Ø¹Ø§Ø¡ Ø§Ù„Ù…ØªÙƒØ±Ø±) ÙˆÙ„Ø§ ØªÙ„Ù…Ø³ Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ù…ÙØ¯Ø§Ø±Ø©
  /// ÙŠØ¯ÙˆÙŠØ§Ù‹ (autoProvisioned = false).
  static Future<void> ensureProvisioned(String restaurantId) async {
    final String rid = _normalizeRid(restaurantId);
    if (rid.isEmpty) return;
    try {
      final Map<String, Map<String, Map<String, dynamic>>> all =
          await _loadAll();
      final Map<String, Map<String, dynamic>> bucket = Map<String,
          Map<String, dynamic>>.of(
          all[rid] ?? <String, Map<String, dynamic>>{});
      bool changed = false;
      final int now = DateTime.now().millisecondsSinceEpoch;

      // â‘  Ø­Ø³Ø§Ø¨ Ø§Ù„Ù…Ø¯ÙŠØ± â€” ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ØªØªØ¨Ø¹ Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ø­Ø§Ù„ÙŠ.
      final String adminPin = await AppSettings.getAdminPin();
      final String managerId =
          StaffMember.buildStaffId(rid, defaultManagerUsername);
      final Object? managerRaw = bucket[managerId];
      final StaffMember? existingManager =
          _memberFromRaw(managerRaw);

      if (existingManager == null) {
        bucket[managerId] = StaffMember(
          staffId: managerId,
          restaurantId: rid,
          name: defaultManagerName,
          username: defaultManagerUsername,
          role: StaffRole.manager,
          active: true,
          autoProvisioned: true,
          createdAtMs: now,
        ).withNewPassword(adminPin).toJson();
        changed = true;
      } else if (existingManager.autoProvisioned &&
          !existingManager.verifyPassword(adminPin)) {
        bucket[managerId] = existingManager.withNewPassword(adminPin).toJson();
        changed = true;
      }

      // â‘¡ Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ø¹Ù…Ø§Ù„ Ù…Ù† Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø³Ø§Ø¦Ù‚ÙŠÙ† Ø§Ù„Ø­Ø§Ù„ÙŠØ©.
      final List<Driver> drivers = await DriverStorage.loadDrivers();
      final Set<String> activeWorkerKeys = <String>{};
      for (final Driver driver in drivers) {
        final String uname = driver.name.trim();
        if (uname.isEmpty) continue;
        activeWorkerKeys.add(StaffMember.normalizeUsername(uname));
        final String workerId = StaffMember.buildStaffId(rid, uname);
        final StaffMember? existing = _memberFromRaw(bucket[workerId]);

        if (existing == null) {
          bucket[workerId] = StaffMember(
            staffId: workerId,
            restaurantId: rid,
            name: uname,
            username: uname,
            role: StaffRole.worker,
            pin: driver.pin,
            driverPin: driver.pin,
            active: true,
            autoProvisioned: true,
            createdAtMs: now,
          ).withNewPassword(defaultWorkerPassword).toJson();
          changed = true;
        } else if (existing.pin != driver.pin ||
            existing.driverPin != driver.pin) {
          bucket[workerId] = existing
              .copyWith(pin: driver.pin, driverPin: driver.pin, active: true)
              .toJson();
          changed = true;
        }
      }

      // â‘¢ Ø­Ø°Ù Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ø¹Ù…Ø§Ù„ Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠØ© Ø§Ù„ØªÙŠ Ø­ÙØ°Ù Ø¹Ø§Ù…Ù„Ù‡Ø§ Ù…Ù† Ø§Ù„Ù‚Ø§Ø¦Ù…Ø©.
      final List<String> orphanIds = <String>[];
      bucket.forEach((String id, Map<String, dynamic> json) {
        if (json.isEmpty) return;
        final StaffMember member = StaffMember.fromJson(json);
        if (member.isWorker &&
            member.autoProvisioned &&
            !activeWorkerKeys
                .contains(StaffMember.normalizeUsername(member.username))) {
          orphanIds.add(id);
        }
      });
      for (final String orphanId in orphanIds) {
        bucket.remove(orphanId);
        changed = true;
        await _deleteFromCloud(rid, orphanId);
      }

      if (changed) {
        all[rid] = bucket;
        await _saveAll(all);
        for (final Map<String, dynamic> json in bucket.values) {
          if (json.isEmpty) continue;
          await _pushToCloud(rid, StaffMember.fromJson(json));
        }
      }
    } catch (e) {
      debugPrint('[StaffDirectory] ensureProvisioned Ø®Ø·Ø£: $e');
    }
  }

  /// ØªØ­ÙˆÙŠÙ„ Ø¨ÙŠØ§Ù†Ø§Øª Ø®Ø§Ù… Ø¥Ù„Ù‰ Ø­Ø³Ø§Ø¨ Ø¨Ø£Ù…Ø§Ù† (ÙŠØ±Ø¬Ø¹ null Ø¥Ø°Ø§ ÙƒØ§Ù†Øª ÙØ§Ø±ØºØ©/ØªØ§Ù„ÙØ©).
  static StaffMember? _memberFromRaw(Object? raw) {
    if (raw is! Map || (raw as Map<Object?, Object?>).isEmpty) return null;
    try {
      return StaffMember.fromJson(
        Map<String, dynamic>.from(raw as Map<Object?, Object?>),
      );
    } catch (_) {
      return null;
    }
  }

  // â”€â”€â”€ Ø§Ù„Ù…ØµØ§Ø¯Ù‚Ø© (ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Ù…ØµØ§Ø¯Ù‚Ø© Ù…ÙˆØ¸Ù: (Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… + Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… + ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø£Ùˆ PIN).
  ///
  /// **Ø¢Ù„ÙŠØ© Ø§Ù„Ø¹Ø²Ù„:** Ø§Ù„Ø¨Ø­Ø« ÙŠÙ‚ØªØµØ± Ø­ØµØ±Ø§Ù‹ Ø¹Ù„Ù‰ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„ÙØ±Ø¹ÙŠ Ø§Ù„Ø®Ø§Øµ Ø¨Ù…Ø¹Ø±Ù‘Ù
  /// Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„Ù…Ø¯Ø®Ù„ â€” Ø­ØªÙ‰ Ù„Ùˆ ØªØ·Ø§Ø¨Ù‚ Ø§Ù„Ø§Ø³Ù… ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø­Ø±ÙÙŠØ§Ù‹ Ø¨ÙŠÙ† Ù…Ø·Ø¹Ù…ÙŠÙ†ØŒ
  /// Ù„Ø§ ÙŠÙ…ÙƒÙ† Ù„Ù„Ø­Ø³Ø§Ø¨ ÙÙŠ Ù…Ø·Ø¹Ù… Â«Ø£Ù„ÙÂ» Ø£Ù† ÙŠÙØªØ­ Ø¬Ù„Ø³Ø© Ù„Ù…Ø·Ø¹Ù… Â«Ø¨Ø§Ø¡Â».
  ///
  /// **Ø¢Ù„ÙŠØ© Ø§Ù„Ù…Ø²Ø§Ù…Ù†Ø©:** Ø¥Ø°Ø§ ÙƒØ§Ù† Ø±Ø§Ø¨Ø· Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ù…Ø¶Ø¨ÙˆØ·Ø§Ù‹ØŒ ØªÙØ¬Ù„Ø¨ Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª
  /// Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ© Ø£ÙˆÙ„Ø§Ù‹ (Ø§Ù„Ø³Ø­Ø§Ø¨Ø© Ù‡ÙŠ Ø§Ù„Ù…Ø±Ø¬Ø¹) ÙˆÙŠÙØ¯Ù…Ø¬ Ø¨Ù‡Ø§ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„Ù…Ø­Ù„ÙŠØŒ Ù…Ø¹
  /// Ø§Ù„Ø§Ø­ØªÙØ§Ø¸ Ø¨Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ù…Ø­Ù„ÙŠØ© ØºÙŠØ± Ø§Ù„Ù…Ø±ÙÙˆØ¹Ø© Ø¨Ø¹Ø¯ (ÙˆØ¶Ø¹ Offline-First).
  static Future<StaffAuthResult> authenticate({
    required String restaurantId,
    required String username,
    required String secret,
  }) async {
    final String rid = _normalizeRid(restaurantId);
    final String uname = StaffMember.normalizeUsername(username);
    final String pass = secret.trim();

    // ØªØ­Ù‚Ù‚ ØµØ§Ø±Ù… Ù…Ù† Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù…
    if (rid.isEmpty) {
      return StaffAuthResult.failure(
          'ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… (Restaurant ID).');
    }
    
    // ØªØ­Ù‚Ù‚ Ù…Ù† ØªÙ†Ø³ÙŠÙ‚ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… (ÙŠØ¬Ø¨ Ø£Ù† ÙŠØ­ØªÙˆÙŠ Ø¹Ù„Ù‰ Ø£Ø­Ø±Ù ÙˆØ£Ø±Ù‚Ø§Ù… ÙÙ‚Ø·)
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(rid)) {
      return StaffAuthResult.failure(
          'Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… ÙŠØ¬Ø¨ Ø£Ù† ÙŠØ­ØªÙˆÙŠ Ø¹Ù„Ù‰ Ø£Ø­Ø±Ù ÙˆØ£Ø±Ù‚Ø§Ù… ÙÙ‚Ø· (Ø¨Ø¯ÙˆÙ† Ù…Ø³Ø§ÙØ§Øª Ø£Ùˆ Ø±Ù…ÙˆØ² Ø®Ø§ØµØ©).');
    }
    
    // ØªØ­Ù‚Ù‚ Ù…Ù† Ø·ÙˆÙ„ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù…
    if (rid.length < 4) {
      return StaffAuthResult.failure(
          'Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ù‚ØµÙŠØ± Ø¬Ø¯Ø§Ù‹. ÙŠØ¬Ø¨ Ø£Ù† ÙŠÙƒÙˆÙ† 4 Ø£Ø­Ø±Ù Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„.');
    }

    if (uname.isEmpty) {
      return StaffAuthResult.failure('ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù….');
    }
    if (pass.isEmpty) {
      return StaffAuthResult.failure('ÙŠØ±Ø¬Ù‰ Ø¥Ø¯Ø®Ø§Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø£Ùˆ Ø§Ù„Ø±Ù…Ø² Ø§Ù„Ø³Ø±ÙŠ.');
    }

    List<StaffMember> staff = await loadStaff(rid);

    // Ù…Ø²Ø§Ù…Ù†Ø© Ù…Ù† Ø§Ù„Ø³Ø­Ø§Ø¨Ø© Ø¥Ù† ÙƒØ§Ù† Ø§Ù„Ø§ØªØµØ§Ù„ Ù…Ø¶Ø¨ÙˆØ·Ø§Ù‹ (Ù„Ø¶Ù…Ø§Ù† Ø§Ù„Ø­Ø¯Ø§Ø«Ø©).
    final Map<String, Map<String, dynamic>>? remote =
        await _fetchStaffFromCloud(rid);
    if (remote != null) {
      staff = await _mergeRemoteIntoLocal(rid, remote);
    }

    if (staff.isEmpty) {
      return StaffAuthResult.failure(
        'Ù„Ø§ ØªÙˆØ¬Ø¯ Ø­Ø³Ø§Ø¨Ø§Øª Ù…ÙˆØ¸ÙÙŠÙ† Ù„Ù‡Ø°Ø§ Ø§Ù„Ù…Ø¹Ø±Ù‘Ù ($rid). '
        'ØªØ£ÙƒØ¯ Ù…Ù† ØµØ­Ø© Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ø£Ùˆ Ù…Ù† Ø¥Ø¹Ø¯Ø§Ø¯ Ø±Ø§Ø¨Ø· Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª.',
      );
    }

    StaffMember? match;
    for (final StaffMember member in staff) {
      if (StaffMember.normalizeUsername(member.username) == uname ||
          StaffMember.normalizeUsername(member.name) == uname) {
        match = member;
        break;
      }
    }

    if (match == null || !match.active) {
      return StaffAuthResult.failure(
        'Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¯Ø®ÙˆÙ„ ØºÙŠØ± ØµØ­ÙŠØ­Ø© Ù„Ù‡Ø°Ø§ Ø§Ù„Ù…Ø·Ø¹Ù…. '
        'ØªØ­Ù‚Ù‚ Ù…Ù† Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±/PIN.',
      );
    }

    final bool passwordOk = match.verifyPassword(pass);
    final bool pinOk = match.pin.isNotEmpty && match.pin == pass;
    if (!passwordOk && !pinOk) {
      return StaffAuthResult.failure('ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø£Ùˆ Ø§Ù„Ø±Ù…Ø² Ø§Ù„Ø³Ø±ÙŠ ØºÙŠØ± ØµØ­ÙŠØ­.');
    }

    return StaffAuthResult.success(match, 'Ø£Ù‡Ù„Ø§Ù‹ Ø¨Ùƒ ÙŠØ§ ${match.name}');
  }

  // â”€â”€â”€ Ø§Ù„Ù…Ø²Ø§Ù…Ù†Ø© Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ© (Firebase REST â€” Offline-First) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Ø¬Ù„Ø¨ Ø­Ø³Ø§Ø¨Ø§Øª Ù…Ø·Ø¹Ù… Ù…Ù† Ø§Ù„Ø³Ø­Ø§Ø¨Ø©. Ø®Ø±ÙŠØ·Ø© ÙØ§Ø±ØºØ© = Ù†Ø¬Ø§Ø­ Ø§ØªØµØ§Ù„ Ø¨Ù„Ø§ Ø­Ø³Ø§Ø¨Ø§Øª.
  /// `null` ÙŠØ¹Ù†ÙŠ ÙØ´Ù„ Ø§Ù„Ø§ØªØµØ§Ù„ â€” Ø¹Ù†Ø¯Ù‡Ø§ ÙŠÙØ³ØªØ®Ø¯Ù… Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„Ù…Ø­Ù„ÙŠ ÙƒÙ…Ø§ Ù‡Ùˆ.
  static Future<Map<String, Map<String, dynamic>>?> _fetchStaffFromCloud(
    String rid,
  ) async {
    final String url = await resolveDatabaseUrl();
    if (url.isEmpty) return null;
    try {
      final http.Response response = await http
          .get(
            Uri.parse(
              '$url/restaurants/${Uri.encodeComponent(rid)}/staff.json',
            ),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final Object? decoded = jsonDecode(response.body);
      if (decoded == null) {
        // Ø§Ù„Ù…Ø·Ø¹Ù… ØºÙŠØ± Ù…ÙˆØ¬ÙˆØ¯ Ø³Ø­Ø§Ø¨ÙŠØ§Ù‹ Ø¨Ø¹Ø¯ â€” Ù†Ø¬Ø§Ø­ Ø§ØªØµØ§Ù„ Ø¨Ø¯Ù„ÙŠÙ„ ÙØ§Ø±Øº.
        return <String, Map<String, dynamic>>{};
      }
      if (decoded is! Map) return null;
      return decoded.map(
        (Object? id, Object? account) => MapEntry<String, Map<String, dynamic>>(
          id.toString(),
          account is Map
              ? Map<String, dynamic>.from(account)
              : <String, dynamic>{},
        ),
      );
    } catch (e) {
      debugPrint('[StaffDirectory] fetchStaffFromCloud Ø®Ø·Ø£: $e');
      return null;
    }
  }

  /// Ø¯Ù…Ø¬ Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ© Ù…Ø¹ Ø§Ù„Ø¯Ù„ÙŠÙ„ Ø§Ù„Ù…Ø­Ù„ÙŠ (Ø§Ù„Ø³Ø­Ø§Ø¨Ø© Ù‡ÙŠ Ø§Ù„Ù…Ø±Ø¬Ø¹ Ù„Ù„Ù…Ø¹ØªÙ…Ø¯).
  static Future<List<StaffMember>> _mergeRemoteIntoLocal(
    String rid,
    Map<String, Map<String, dynamic>> remote,
  ) async {
    final Map<String, Map<String, Map<String, dynamic>>> all = await _loadAll();
    final Map<String, Map<String, dynamic>> bucket = Map<String,
        Map<String, dynamic>>.of(
        all[rid] ?? <String, Map<String, dynamic>>{});
    bool changed = false;
    remote.forEach((String id, Map<String, dynamic> json) {
      if (json.isEmpty) return;
      final Map<String, dynamic>? local = bucket[id];
      if (local == null || jsonEncode(local) != jsonEncode(json)) {
        bucket[id] = json;
        changed = true;
      }
    });
    if (changed) {
      all[rid] = bucket;
      await _saveAll(all);
    }
    return bucket.values
        .where((Map<String, dynamic> json) => json.isNotEmpty)
        .map(StaffMember.fromJson)
        .toList();
  }

  /// Ø±ÙØ¹ Ø­Ø³Ø§Ø¨ ÙˆØ§Ø­Ø¯ Ø¥Ù„Ù‰ Ø§Ù„Ø³Ø­Ø§Ø¨Ø© (ØªØ¬Ø§Ù‡Ù„ Ø£Ø®Ø·Ø§Ø¡ Ø§Ù„Ø´Ø¨ÙƒØ© Ø¨Ù‡Ø¯ÙˆØ¡ â€” Offline-First).
  static Future<void> _pushToCloud(String rid, StaffMember member) async {
    final String url = await resolveDatabaseUrl();
    if (url.isEmpty) return;
    try {
      final http.Response response = await http
          .put(
            Uri.parse(
              '$url/restaurants/${Uri.encodeComponent(rid)}/staff/'
              '${Uri.encodeComponent(member.staffId)}.json',
            ),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(member.toJson()),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        debugPrint(
          '[StaffDirectory] pushToCloud ÙØ´Ù„ (${response.statusCode}) '
          'Ù„Ù€ ${member.staffId}',
        );
      }
    } catch (e) {
      debugPrint('[StaffDirectory] pushToCloud Ø®Ø·Ø£: $e');
    }
  }

  /// Ø­Ø°Ù Ø­Ø³Ø§Ø¨ Ù…Ù† Ø§Ù„Ø³Ø­Ø§Ø¨Ø© (Ù„ØªÙ†Ø¸ÙŠÙ Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„ÙŠØªÙŠÙ…Ø© Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠØ©).
  static Future<void> _deleteFromCloud(String rid, String staffId) async {
    final String url = await resolveDatabaseUrl();
    if (url.isEmpty) return;
    try {
      await http
          .delete(
            Uri.parse(
              '$url/restaurants/${Uri.encodeComponent(rid)}/staff/'
              '${Uri.encodeComponent(staffId)}.json',
            ),
          )
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('[StaffDirectory] deleteFromCloud Ø®Ø·Ø£: $e');
    }
  }
}
