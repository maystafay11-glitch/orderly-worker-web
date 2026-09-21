import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/driver.dart';
import 'package:orderly_worker_web/models/shift_record.dart';
import 'package:orderly_worker_web/services/app_settings.dart';

/// Ø­ÙØ¸ ÙˆØ§Ø³ØªØ±Ø¬Ø§Ø¹ Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ Ù…Ø­Ù„ÙŠØ§Ù‹ Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… `shared_preferences`.
///
/// ØªÙØ®Ø²ÙŽÙ‘Ù† ÙƒÙ„ Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ ÙÙŠ Ù…ÙØªØ§Ø­ ÙˆØ§Ø­Ø¯ ([driversKey]) Ø¨ØµÙŠØºØ© JSONØŒ Ù…Ø¹ Ø¥Ø³Ù†Ø§Ø¯
/// Ø±Ù…ÙˆØ² PIN ØªØ³Ù„Ø³Ù„ÙŠØ© (1001 Ø¥Ù„Ù‰ 1030) ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹ Ù„ÙƒÙ„ Ø³Ø§Ø¦Ù‚.
class DriverStorage {
  /// Ø§Ù„ØµÙ†Ù ÙŠØ­ØªÙˆÙŠ Ø¯ÙˆØ§Ù„Ø§Ù‹ Ø«Ø§Ø¨ØªØ© ÙÙ‚Ø·ØŒ ÙÙ„Ø§ Ø­Ø§Ø¬Ø© Ù„Ø¥Ù†Ø´Ø§Ø¡ ÙƒØ§Ø¦Ù† Ù…Ù†Ù‡.
  const DriverStorage._();

  /// Ù…ÙØªØ§Ø­ ØªØ®Ø²ÙŠÙ† Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ Ø¯Ø§Ø®Ù„ `SharedPreferences`.
  static const String driversKey = 'orderly.drivers';

  /// Ù…ÙØªØ§Ø­ ØªØ®Ø²ÙŠÙ† Ø³Ø¬Ù„Ø§Øª Ø§Ù„ÙˆØ±Ø¯ÙŠØ§Øª Ø§Ù„ÙŠÙˆÙ…ÙŠØ© Ù„Ù„Ø³Ø§Ø¦Ù‚ÙŠÙ†.
  static const String shiftRecordsKey = 'orderly.shift_records';

  /// Ø§Ù„ÙˆØµÙˆÙ„ Ø¥Ù„Ù‰ Ù…Ø®Ø²Ù† Ø§Ù„ØªÙØ¶ÙŠÙ„Ø§Øª.
  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  /// Ø­ÙØ¸ ÙƒÙ„ Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ (ÙŠØ³ØªØ¨Ø¯Ù„ Ø§Ù„Ù…Ø­ÙÙˆØ¸ Ø³Ø§Ø¨Ù‚Ø§Ù‹).
  static Future<void> saveDrivers(List<Driver> drivers) async {
    final SharedPreferences prefs = await _prefs;
    if (drivers.isEmpty) {
      await prefs.remove(driversKey);
      return;
    }
    final String payload = jsonEncode(
      drivers.map((Driver driver) => driver.toJson()).toList(),
    );
    await prefs.setString(driversKey, payload);
  }

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ ÙƒÙ„ Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ Ø§Ù„Ù…Ø­ÙÙˆØ¸Ø©ØŒ Ù…Ø¹ Ø¶Ù…Ø§Ù† ÙˆØ¬ÙˆØ¯ Ø±Ù…Ø² PIN Ù…Ø®ØµØµ Ù„ÙƒÙ„ Ø³Ø§Ø¦Ù‚ (1001-1030).
  static Future<List<Driver>> loadDrivers() async {
    final SharedPreferences prefs = await _prefs;
    try {
      final String? raw = prefs.getString(driversKey);
      if (raw == null || raw.trim().isEmpty) {
        return <Driver>[];
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <Driver>[];
      }
      final List<Driver> loaded = decoded
          .whereType<Map<Object?, Object?>>()
          .map(
            (Map<Object?, Object?> item) =>
                Driver.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();

      bool needsSave = false;
      final List<Driver> normalized = <Driver>[];
      for (final Driver d in loaded) {
        if (d.pin.isEmpty) {
          final String autoPin = Driver.findNextAvailablePin(normalized);
          normalized.add(d.copyWith(pin: autoPin));
          needsSave = true;
        } else {
          normalized.add(d);
        }
      }

      if (needsSave) {
        unawaited(saveDrivers(normalized));
      }
      return normalized;
    } catch (_) {
      return <Driver>[];
    }
  }

  /// Ø­ÙØ¸ Ø¹Ø§Ù…Ù„ ÙˆØ§Ø­Ø¯: ÙŠÙØ¶Ø§Ù Ø¥Ø°Ø§ ÙƒØ§Ù† Ø¬Ø¯ÙŠØ¯Ø§Ù‹ØŒ Ø£Ùˆ ÙŠÙØ­Ø¯ÙŽÙ‘Ø« Ø¥Ø°Ø§ ÙƒØ§Ù† Ø§Ø³Ù…Ù‡ Ù…Ø­ÙÙˆØ¸Ø§Ù‹ØŒ
  /// Ù…Ø¹ ØªÙˆÙ„ÙŠØ¯ Ø±Ù…Ø² PIN ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹ Ø¥Ù† Ù„Ù… ÙŠÙƒÙ† Ù…Ø­Ø¯Ø¯Ø§Ù‹.
  static Future<void> saveDriver(Driver driver) async {
    final List<Driver> drivers = List<Driver>.of(await loadDrivers());
    final int index = drivers.indexWhere(
      (Driver item) => item.name == driver.name,
    );

    Driver toSave = driver;
    if (toSave.pin.isEmpty) {
      toSave = toSave.copyWith(pin: Driver.findNextAvailablePin(drivers));
    }

    if (index == -1) {
      drivers.add(toSave);
    } else {
      drivers[index] = toSave;
    }
    await saveDrivers(drivers);
  }

  /// ØªØ­Ø¯ÙŠØ« ÙˆØªØ®ØµÙŠØµ Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ (PIN) Ù…Ø¹ Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† Ø¹Ø¯Ù… Ø§Ù„ØªÙƒØ±Ø§Ø± ÙˆØ¹Ø¯Ù… ØªØ·Ø§Ø¨Ù‚Ù‡ Ù…Ø¹ Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ±.
  ///
  /// ÙŠÙØ±Ø¬Ø¹ `null` Ø¹Ù†Ø¯ Ø§Ù„Ù†Ø¬Ø§Ø­ØŒ Ø£Ùˆ Ù†Øµ Ø±Ø³Ø§Ù„Ø© Ø§Ù„Ø®Ø·Ø£ Ø¹Ù†Ø¯ ÙØ´Ù„ Ø§Ù„ØªØ­Ù‚Ù‚.
  static Future<String?> updateDriverPin({
    required String driverName,
    required String newPin,
  }) async {
    final String cleanPin = newPin.trim();
    if (cleanPin.isEmpty) {
      return 'Ø§Ù„Ø±Ù…Ø² Ø§Ù„Ø³Ø±ÙŠ Ù„Ø§ ÙŠÙ…ÙƒÙ† Ø£Ù† ÙŠÙƒÙˆÙ† ÙØ§Ø±ØºØ§Ù‹';
    }
    if (cleanPin.length < 4) {
      return 'Ø§Ù„Ø±Ù…Ø² ÙŠØ¬Ø¨ Ø£Ù† ÙŠØªÙƒÙˆÙ† Ù…Ù† 4 Ø£Ø±Ù‚Ø§Ù… Ø¹Ù„Ù‰ Ø§Ù„Ø£Ù‚Ù„';
    }

    // Ø§Ù„ØªØ£ÙƒØ¯ Ù…Ù† Ø¹Ø¯Ù… ØªØ·Ø§Ø¨Ù‚Ù‡ Ù…Ø¹ Ø±Ù…Ø² Ø§Ù„Ù…Ø¯ÙŠØ±
    final String adminPin = await AppSettings.getAdminPin();
    if (cleanPin == adminPin) {
      return 'Ù‡Ø°Ø§ Ø§Ù„Ø±Ù…Ø² Ù…Ø­Ø¬ÙˆØ² Ù„Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø·Ø¹Ù…ØŒ ÙŠØ±Ø¬Ù‰ Ø§Ø®ØªÙŠØ§Ø± Ø±Ù…Ø² Ø¢Ø®Ø±';
    }

    final List<Driver> drivers = List<Driver>.of(await loadDrivers());
    final int targetIndex = drivers.indexWhere((Driver d) => d.name == driverName);
    if (targetIndex == -1) {
      return 'Ø§Ù„Ø¹Ø§Ù…Ù„ ØºÙŠØ± Ù…ÙˆØ¬ÙˆØ¯ ÙÙŠ Ø§Ù„Ù†Ø¸Ø§Ù…';
    }

    // Ø§Ù„ØªØ£ÙƒØ¯ Ù…Ù† Ø¹Ø¯Ù… ØªÙƒØ±Ø§Ø± Ø§Ù„Ø±Ù…Ø² Ù…Ø¹ Ø³Ø§Ø¦Ù‚ Ø¢Ø®Ø±
    final bool isDuplicate = drivers.any(
      (Driver d) => d.name != driverName && d.pin == cleanPin,
    );
    if (isDuplicate) {
      return 'Ù‡Ø°Ø§ Ø§Ù„Ø±Ù…Ø² ($cleanPin) Ù…Ø³ØªØ®Ø¯Ù… Ø¨Ø§Ù„ÙØ¹Ù„ Ù„Ø³Ø§Ø¦Ù‚ Ø¢Ø®Ø±';
    }

    drivers[targetIndex] = drivers[targetIndex].copyWith(pin: cleanPin);
    await saveDrivers(drivers);
    return null;
  }

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø¹Ø§Ù…Ù„ Ø¨Ø§Ù„Ø§Ø³Ù…ØŒ Ø£Ùˆ `null` Ø¥Ø°Ø§ Ù„Ù… ÙŠÙƒÙ† Ù…Ø­ÙÙˆØ¸Ø§Ù‹.
  static Future<Driver?> loadDriver(String name) async {
    final List<Driver> drivers = await loadDrivers();
    for (final Driver driver in drivers) {
      if (driver.name == name) {
        return driver;
      }
    }
    return null;
  }

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø¹Ø§Ù…Ù„ Ø¨Ø±Ù…Ø² Ø§Ù„Ù€ PIN (1001-1030).
  static Future<Driver?> loadDriverByPin(String pin) async {
    final List<Driver> drivers = await loadDrivers();
    final String clean = pin.trim();
    for (final Driver driver in drivers) {
      if (driver.pin == clean) {
        return driver;
      }
    }
    return null;
  }

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ø¹Ø§Ù…Ù„ Ø¨Ø§Ù„Ø§Ø³Ù…ØŒ ÙˆØ¥Ù† Ù„Ù… ÙŠÙƒÙ† Ù…Ø­ÙÙˆØ¸Ø§Ù‹ ÙŠÙÙ†Ø´Ø£ Ø¹Ø§Ù…Ù„ Ø¬Ø¯ÙŠØ¯ Ø¨Ø±Ù…Ø² PIN ØªÙ„Ù‚Ø§Ø¦ÙŠ.
  static Future<Driver> loadOrCreate(String name) async {
    final Driver? saved = await loadDriver(name);
    if (saved != null) {
      return saved;
    }
    final List<Driver> current = await loadDrivers();
    final String nextPin = Driver.findNextAvailablePin(current);
    final Driver created = Driver(name: name, pin: nextPin);
    await saveDriver(created);
    return created;
  }

  /// Ø­Ø°Ù Ø¹Ø§Ù…Ù„ Ø¨Ø§Ù„Ø§Ø³Ù…ØŒ ÙˆØªÙØ±Ø¬Ø¹ `true` Ø¥Ø°Ø§ ØªÙ… Ø§Ù„Ø­Ø°Ù ÙØ¹Ù„Ø§Ù‹.
  static Future<bool> deleteDriver(String name) async {
    final List<Driver> drivers = await loadDrivers();
    final List<Driver> remaining = drivers
        .where((Driver driver) => driver.name != name)
        .toList();
    if (remaining.length == drivers.length) {
      return false;
    }
    await saveDrivers(remaining);
    return true;
  }

  /// Ø­Ø°Ù ÙƒÙ„ Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø¹ÙˆØ§Ù…Ù„ Ø§Ù„Ù…Ø­ÙÙˆØ¸Ø©.
  static Future<void> clear() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(driversKey);
    await prefs.remove(shiftRecordsKey);
  }

  // --- Ø¥Ø¯Ø§Ø±Ø© Ø³Ø¬Ù„Ø§Øª Ø§Ù„ÙˆØ±Ø¯ÙŠØ§Øª (Shift Records) ---

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ ÙƒÙ„ Ø³Ø¬Ù„Ø§Øª Ø§Ù„ÙˆØ±Ø¯ÙŠØ§Øª Ø§Ù„ÙŠÙˆÙ…ÙŠØ© Ø§Ù„Ù…Ø­ÙÙˆØ¸Ø©.
  static Future<List<ShiftRecord>> loadShiftRecords() async {
    final SharedPreferences prefs = await _prefs;
    try {
      final String? raw = prefs.getString(shiftRecordsKey);
      if (raw == null || raw.trim().isEmpty) {
        return <ShiftRecord>[];
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <ShiftRecord>[];
      }
      return decoded
          .whereType<Map<Object?, Object?>>()
          .map((Map<Object?, Object?> item) =>
              ShiftRecord.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return <ShiftRecord>[];
    }
  }

  /// Ø­ÙØ¸ Ù‚Ø§Ø¦Ù…Ø© Ø³Ø¬Ù„Ø§Øª Ø§Ù„ÙˆØ±Ø¯ÙŠØ§Øª.
  static Future<void> saveShiftRecords(List<ShiftRecord> records) async {
    final SharedPreferences prefs = await _prefs;
    if (records.isEmpty) {
      await prefs.remove(shiftRecordsKey);
      return;
    }
    final String payload = jsonEncode(
      records.map((ShiftRecord r) => r.toJson()).toList(),
    );
    await prefs.setString(shiftRecordsKey, payload);
  }

  /// Ù…ÙØªØ§Ø­ ØªØ®Ø²ÙŠÙ† Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ø§Ù…Ø© / Ø§Ù„Ø³ÙØ±ÙŠ Ø¯Ø§Ø®Ù„ `SharedPreferences`.
  static const String generalOrdersKey = 'orderly.general_orders';

  /// Ø§Ø³ØªØ±Ø¬Ø§Ø¹ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ø§Ù…Ø© ÙˆØ§Ù„Ø³ÙØ±ÙŠ Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„Ø© Ø§Ù„ÙŠÙˆÙ….
  static Future<List<DeliveryOrder>> loadGeneralOrders() async {
    final SharedPreferences prefs = await _prefs;
    try {
      final String? raw = prefs.getString(generalOrdersKey);
      if (raw == null || raw.trim().isEmpty) {
        return <DeliveryOrder>[];
      }
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) {
        return <DeliveryOrder>[];
      }
      return decoded
          .whereType<Map<Object?, Object?>>()
          .map(
            (Map<Object?, Object?> item) =>
                DeliveryOrder.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (_) {
      return <DeliveryOrder>[];
    }
  }

  /// Ø­ÙØ¸ Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ø§Ù…Ø© ÙˆØ§Ù„Ø³ÙØ±ÙŠ (ÙŠØ³ØªØ¨Ø¯Ù„ Ø§Ù„Ù…Ø­ÙÙˆØ¸).
  static Future<void> saveGeneralOrders(List<DeliveryOrder> orders) async {
    final SharedPreferences prefs = await _prefs;
    if (orders.isEmpty) {
      await prefs.remove(generalOrdersKey);
      return;
    }
    final String payload = jsonEncode(
      orders.map((DeliveryOrder order) => order.toJson()).toList(),
    );
    await prefs.setString(generalOrdersKey, payload);
  }

  /// Ø¥Ø¶Ø§ÙØ© Ø·Ù„Ø¨ Ø¹Ø§Ù… / Ø³ÙØ±ÙŠ Ø¬Ø¯ÙŠØ¯ ÙˆØ­ÙØ¸Ù‡ ÙÙˆØ±Ø§Ù‹ ÙÙŠ Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ.
  static Future<void> addGeneralOrder(DeliveryOrder order) async {
    final List<DeliveryOrder> current = await loadGeneralOrders();
    current.add(order);
    await saveGeneralOrders(current);
  }

  /// Ø­Ø°Ù Ø·Ù„Ø¨ Ø¹Ø§Ù… Ù…Ø­Ø¯Ø¯ Ø¨Ø§Ù„ØªØ±ØªÙŠØ¨ Ø§Ù„Ø²Ù…Ù†ÙŠ.
  static Future<void> removeGeneralOrderAt(int index) async {
    final List<DeliveryOrder> current = await loadGeneralOrders();
    if (index >= 0 && index < current.length) {
      current.removeAt(index);
      await saveGeneralOrders(current);
    }
  }

  /// ØªØµÙÙŠØ± Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø¹Ø§Ù…Ø© Ù„Ù„ÙŠÙˆÙ….
  static Future<void> clearGeneralOrders() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(generalOrdersKey);
  }

  /// Ù‡Ù„ ØªÙˆØ¬Ø¯ Ø¨ÙŠØ§Ù†Ø§Øª Ø¹ÙˆØ§Ù…Ù„ Ù…Ø­ÙÙˆØ¸Ø©ØŸ
  static Future<bool> hasSavedDrivers() async =>
      (await loadDrivers()).isNotEmpty;
}

/// Ø§Ø®ØªØµØ§Ø±Ø§Øª Ù„Ù„Ø­ÙØ¸ Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ Ù…Ø¨Ø§Ø´Ø±Ø© Ù…Ù† ÙƒØ§Ø¦Ù† [Driver].
extension DriverPersistence on Driver {
  /// Ø­ÙØ¸ Ù‡Ø°Ø§ Ø§Ù„Ø¹Ø§Ù…Ù„ Ù…Ø­Ù„ÙŠØ§Ù‹ (Ø¥Ø¶Ø§ÙØ© Ø£Ùˆ ØªØ­Ø¯ÙŠØ«) Ø¨Ø¹Ø¯ Ø£ÙŠ ØªØ¹Ø¯ÙŠÙ„ Ø¹Ù„Ù‰ Ø¨ÙŠØ§Ù†Ø§ØªÙ‡.
  Future<void> save() => DriverStorage.saveDriver(this);

  /// Ø­Ø°Ù Ù‡Ø°Ø§ Ø§Ù„Ø¹Ø§Ù…Ù„ Ù…Ù† Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ.
  Future<bool> delete() => DriverStorage.deleteDriver(name);
}
