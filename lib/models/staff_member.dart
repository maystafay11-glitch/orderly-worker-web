import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Ø£Ø¯ÙˆØ§Ø± Ø§Ù„Ù…ÙˆØ¸ÙÙŠÙ† ÙÙŠ Ù†Ø¸Ø§Ù… Ø§Ù„Ù…ØµØ§Ø¯Ù‚Ø© Ù…ØªØ¹Ø¯Ø¯ Ø§Ù„Ù…Ø·Ø§Ø¹Ù….
enum StaffRole {
  /// Ø¹Ø§Ù…Ù„ ØªÙˆØµÙŠÙ„: ÙˆØ§Ø¬Ù‡Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ÙŠØ¯Ø§Ù†ÙŠØ© Ø§Ù„Ù…Ø³Ù†Ø¯Ø© Ø¥Ù„ÙŠÙ‡ ÙÙ‚Ø·.
  worker,

  /// Ù…Ø¯ÙŠØ± Ø§Ù„Ù…Ø·Ø¹Ù…: ØµÙ„Ø§Ø­ÙŠØ© ÙƒØ§Ù…Ù„Ø© (Ø§Ù„ØµÙ†Ø¯ÙˆÙ‚ØŒ Ø§Ù„Ø£Ø¬ÙˆØ±ØŒ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯Ø§ØªØŒ Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª).
  manager,
}

/// Ø­Ø³Ø§Ø¨ Ù…ÙˆØ¸Ù Ø¯Ø§Ø®Ù„ Ù…Ø·Ø¹Ù… Ù…Ø­Ø¯Ø¯ (Worker / Manager Account).
///
/// **Ø¹Ø²Ù„ Ø§Ù„Ù…Ø·Ø§Ø¹Ù… (Multi-tenant):**
/// ÙƒÙ„ Ø­Ø³Ø§Ø¨ ÙŠÙ†ØªÙ…ÙŠ Ø­ØªÙ…Ø§Ù‹ Ø¥Ù„Ù‰ [restaurantId]ØŒ ÙˆÙŠÙØ®Ø²ÙŽÙ‘Ù† ÙÙŠ Ø§Ù„Ù…Ø³Ø§Ø±:
/// `restaurants/{restaurantId}/staff/{staffId}`
/// Ù„Ø°Ù„Ùƒ ÙŠÙØ³Ù…Ø­ Ø¨ØªÙƒØ±Ø§Ø± Ù†ÙØ³ Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… ÙˆÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ø¨ÙŠÙ† Ù…Ø·Ø¹Ù…ÙŠÙ† Ù…Ø®ØªÙ„ÙÙŠÙ†
/// ØªÙ…Ø§Ù…Ø§Ù‹ Ø¯ÙˆÙ† Ø£ÙŠ ØªØ¯Ø§Ø®Ù„ØŒ Ù„Ø£Ù† Ø§Ù„Ù…Ø³Ø§Ø± ÙŠØªØ¶Ù…Ù† Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù….
class StaffMember {
  const StaffMember({
    required this.staffId,
    required this.restaurantId,
    required this.name,
    required this.username,
    required this.role,
    this.passwordSalt = '',
    this.passwordHash = '',
    this.pin = '',
    this.driverPin = '',
    this.active = true,
    this.autoProvisioned = false,
    this.createdAtMs = 0,
  });

  /// Ø¥Ù†Ø´Ø§Ø¡ Ø¹Ø§Ù…Ù„ Ù…Ù† Ø®Ø±ÙŠØ·Ø© (JSON) Ù…Ø³ØªØ±Ø¬ÙŽØ¹Ø© Ù…Ù† Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ Ø£Ùˆ Firebase.
  factory StaffMember.fromJson(Map<String, dynamic> json) {
    final String roleRaw = (json[keyRole] ?? keyWorkerRole).toString();
    return StaffMember(
      staffId: (json[keyStaffId] ?? '').toString(),
      restaurantId: (json[keyRestaurantId] ?? '').toString(),
      name: (json[keyName] ?? '').toString(),
      username: (json[keyUsername] ?? '').toString(),
      role: roleRaw == keyManagerRole ? StaffRole.manager : StaffRole.worker,
      passwordSalt: (json[keyPasswordSalt] ?? '').toString(),
      passwordHash: (json[keyPasswordHash] ?? '').toString(),
      pin: (json[keyPin] ?? '').toString().trim(),
      driverPin: (json[keyDriverPin] ?? '').toString().trim(),
      active: json[keyActive] is bool ? json[keyActive] as bool : true,
      autoProvisioned: json[keyAutoProvisioned] == true,
      createdAtMs: _readInt(json[keyCreatedAt]),
    );
  }

  // â”€â”€â”€ Ù…ÙØ§ØªÙŠØ­ Ø§Ù„ØªØ®Ø²ÙŠÙ† / JSON â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  static const String keyStaffId = 'staffId';
  static const String keyRestaurantId = 'restaurantId';
  static const String keyName = 'name';
  static const String keyUsername = 'username';
  static const String keyRole = 'role';
  static const String keyWorkerRole = 'worker';
  static const String keyManagerRole = 'manager';
  static const String keyPasswordSalt = 'passwordSalt';
  static const String keyPasswordHash = 'passwordHash';
  static const String keyPin = 'pin';
  static const String keyDriverPin = 'driverPin';
  static const String keyActive = 'active';
  static const String keyAutoProvisioned = 'autoProvisioned';
  static const String keyCreatedAt = 'createdAt';

  /// Ø§Ù„Ù…Ø¹Ø±Ù Ø§Ù„ÙØ±ÙŠØ¯ Ù„Ù„Ø­Ø³Ø§Ø¨ Ø¯Ø§Ø®Ù„ Ø§Ù„Ù…Ø·Ø¹Ù… (Ù…ÙØªØ§Ø­ Ø§Ù„Ù…Ø³Ø§Ø± ÙÙŠ Ù‚Ø§Ø¹Ø¯Ø© Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª).
  final String staffId;

  /// Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„Ù…Ø§Ù„Ùƒ Ù„Ù„Ø­Ø³Ø§Ø¨ (Ø£Ø³Ø§Ø³ Ø§Ù„Ø¹Ø²Ù„ Ø¨ÙŠÙ† Ø§Ù„Ù…Ø·Ø§Ø¹Ù…).
  final String restaurantId;

  /// Ø§Ù„Ø§Ø³Ù… Ø§Ù„Ù…Ø¹Ø±ÙˆØ¶ Ù„Ù„Ø¹Ø§Ù…Ù„ (Ù‚Ø¯ ÙŠØªØ·Ø§Ø¨Ù‚ Ø¨ÙŠÙ† Ù…Ø·Ø¹Ù…ÙŠÙ† Ù…Ø®ØªÙ„ÙÙŠÙ†).
  final String name;

  /// Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… Ù„ØªØ³Ø¬ÙŠÙ„ Ø§Ù„Ø¯Ø®ÙˆÙ„ (ÙØ±ÙŠØ¯ Ø¯Ø§Ø®Ù„ Ø§Ù„Ù…Ø·Ø¹Ù… Ø§Ù„ÙˆØ§Ø­Ø¯ ÙÙ‚Ø·).
  final String username;

  /// Ø¯ÙˆØ± Ø§Ù„Ø­Ø³Ø§Ø¨: Ø¹Ø§Ù…Ù„ Ø£Ùˆ Ù…Ø¯ÙŠØ±.
  final StaffRole role;

  /// Ù…Ù„Ø­ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± (Ù‚ÙŠÙ…Ø© Ø¹Ø´ÙˆØ§Ø¦ÙŠØ© Ù„ÙƒÙ„ Ø­Ø³Ø§Ø¨).
  final String passwordSalt;

  /// Ø¨ØµÙ…Ø© ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± (SHA-256 Ø¨Ø¹Ø¯ Ø¯Ù…Ø¬ Ø§Ù„Ù…Ù„Ø­ â€” Ù„Ø§ ØªÙØ®Ø²ÙŽÙ‘Ù† ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ù†ØµØ§Ù‹).
  final String passwordHash;

  /// Ø±Ù…Ø² PIN Ø§Ø®ØªÙŠØ§Ø±ÙŠ (Ø¨Ø¯ÙŠÙ„ Ø³Ø±ÙŠØ¹ Ù„ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± â€” Ù…Ø«Ù„ Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ 1001-1030).
  final String pin;

  /// Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ù…Ø±ØªØ¨Ø· Ø¨Ø§Ù„Ø­Ø³Ø§Ø¨ (Ù„ÙØªØ­ Ù„ÙˆØ­Ø© Ø§Ù„Ø¹Ø§Ù…Ù„ Ø§Ù„ØµØ­ÙŠØ­Ø©).
  final String driverPin;

  /// Ù‡Ù„ Ø§Ù„Ø­Ø³Ø§Ø¨ Ù…ÙØ¹Ù‘Ù„ØŸ (Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ù…Ø¹Ø·Ù„Ø© Ù„Ø§ ØªÙØ³Ù…Ø­ Ù„Ù‡Ø§ Ø¨Ø§Ù„Ø¯Ø®ÙˆÙ„).
  final bool active;

  /// Ù‡Ù„ Ø£ÙÙ†Ø´Ø¦ Ø§Ù„Ø­Ø³Ø§Ø¨ ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹ Ù…Ù† Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø¹Ù…Ø§Ù„ØŸ (ÙŠÙØ­Ø¯ÙŽÙ‘Ø«/ÙŠÙØ­Ø°Ù ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹).
  final bool autoProvisioned;

  /// ØªØ§Ø±ÙŠØ® Ø§Ù„Ø¥Ù†Ø´Ø§Ø¡ Ø¨Ø§Ù„Ù…Ù„Ù„ÙŠ Ø«Ø§Ù†ÙŠØ© (0 = ØºÙŠØ± Ù…Ø­Ø¯Ø¯).
  final int createdAtMs;

  /// Ù‡Ù„ Ø§Ù„Ø­Ø³Ø§Ø¨ Ù…Ø¯ÙŠØ±ØŸ
  bool get isManager => role == StaffRole.manager;

  /// Ù‡Ù„ Ø§Ù„Ø­Ø³Ø§Ø¨ Ø¹Ø§Ù…Ù„ ØªÙˆØµÙŠÙ„ØŸ
  bool get isWorker => role == StaffRole.worker;

  /// Ù‡Ù„ ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± Ù…Ø¶Ø¨ÙˆØ·Ø© (ÙŠÙˆØ¬Ø¯ Ù…Ù„Ø­ ÙˆØ¨ØµÙ…Ø©)ØŸ
  bool get hasPassword => passwordSalt.isNotEmpty && passwordHash.isNotEmpty;

  /// Ø§Ù„ØªØ­Ù‚Ù‚ Ù…Ù† ÙƒÙ„Ù…Ø© Ù…Ø±ÙˆØ± Ù†ØµÙŠØ© Ù…Ù‚Ø§Ø¨Ù„ Ø§Ù„Ø¨ØµÙ…Ø© Ø§Ù„Ù…Ø­ÙÙˆØ¸Ø©.
  bool verifyPassword(String plainPassword) {
    if (passwordSalt.isEmpty || passwordHash.isEmpty) return false;
    final String candidate = hashPassword(plainPassword, passwordSalt);
    return _safeEquals(candidate, passwordHash);
  }

  /// ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø­Ø³Ø§Ø¨ Ø¥Ù„Ù‰ Ø®Ø±ÙŠØ·Ø© Ù‚Ø§Ø¨Ù„Ø© Ù„Ù„ØªØ®Ø²ÙŠÙ† Ø¨ØµÙŠØºØ© JSON Ø£Ùˆ Firebase.
  Map<String, dynamic> toJson() => <String, dynamic>{
    keyStaffId: staffId,
    keyRestaurantId: restaurantId,
    keyName: name,
    keyUsername: username,
    keyRole: role == StaffRole.manager ? keyManagerRole : keyWorkerRole,
    keyPasswordSalt: passwordSalt,
    keyPasswordHash: passwordHash,
    keyPin: pin,
    keyDriverPin: driverPin,
    keyActive: active,
    keyAutoProvisioned: autoProvisioned,
    keyCreatedAt: createdAtMs,
  };

  /// Ù†Ø³Ø®Ø© Ù…Ø¹Ø¯ÙŽÙ‘Ù„Ø© Ù…Ù† Ø§Ù„Ø­Ø³Ø§Ø¨.
  StaffMember copyWith({
    String? name,
    String? username,
    StaffRole? role,
    String? passwordSalt,
    String? passwordHash,
    String? pin,
    String? driverPin,
    bool? active,
    bool? autoProvisioned,
  }) {
    return StaffMember(
      staffId: staffId,
      restaurantId: restaurantId,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
      passwordSalt: passwordSalt ?? this.passwordSalt,
      passwordHash: passwordHash ?? this.passwordHash,
      pin: pin ?? this.pin,
      driverPin: driverPin ?? this.driverPin,
      active: active ?? this.active,
      autoProvisioned: autoProvisioned ?? this.autoProvisioned,
      createdAtMs: createdAtMs,
    );
  }

  /// ØªØ¹ÙŠÙŠÙ† ÙƒÙ„Ù…Ø© Ù…Ø±ÙˆØ± Ø¬Ø¯ÙŠØ¯Ø© (ÙŠÙˆÙ„ÙÙ‘Ø¯ Ù…Ù„Ø­Ø§Ù‹ Ø¬Ø¯ÙŠØ¯Ø§Ù‹ ÙˆÙŠØ­Ø¯Ù‘Ø« Ø§Ù„Ø¨ØµÙ…Ø©).
  StaffMember withNewPassword(String plainPassword) {
    final String salt = generateSalt();
    return copyWith(
      passwordSalt: salt,
      passwordHash: hashPassword(plainPassword, salt),
    );
  }

  /// ØªÙˆÙ„ÙŠØ¯ Ù…Ù„Ø­ Ø¹Ø´ÙˆØ§Ø¦ÙŠ Ø¢Ù…Ù† (16 Ø­Ø±ÙØ§Ù‹ Ø³Ø¯Ø§Ø³ÙŠ Ø¹Ø´Ø±ÙŠ).
  static String generateSalt() {
    final Random random = Random.secure();
    final List<String> parts = <String>[
      for (int i = 0; i < 8; i++) random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ];
    return parts.join();
  }

  /// Ø¨ØµÙ…Ø© ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ±: SHA-256( Ø§Ù„Ù…Ù„Ø­ ::: ÙƒÙ„Ù…Ø© Ø§Ù„Ù…Ø±ÙˆØ± ).
  static String hashPassword(String plainPassword, String salt) {
    final List<int> bytes =
        utf8.encode('$salt:::${plainPassword.trim()}:::orderly');
    return sha256.convert(bytes).toString();
  }

  /// ØªÙˆØ­ÙŠØ¯ Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù… Ù„Ù„Ù…Ù‚Ø§Ø±Ù†Ø© (ÙŠØªØ¬Ø§Ù‡Ù„ Ø­Ø§Ù„Ø© Ø§Ù„Ø£Ø­Ø±Ù ÙˆØ§Ù„Ù…Ø³Ø§ÙØ§Øª Ø§Ù„Ø²Ø§Ø¦Ø¯Ø©).
  static String normalizeUsername(String raw) =>
      raw.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// Ù…ÙØªØ§Ø­ Ù…Ø³Ø§Ø± ÙØ±ÙŠØ¯ Ø¯Ø§Ø®Ù„ Ø§Ù„Ù…Ø·Ø¹Ù…: restaurants/{rid}/staff/{staffId}.
  ///
  /// Ù…Ø´ØªÙ‚ Ø­ØªÙ…ÙŠØ§Ù‹ Ù…Ù† (Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… + Ø§Ø³Ù… Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…)ØŒ Ù„Ø°Ù„Ùƒ:
  /// * Ù†ÙØ³ Ø§Ù„Ø§Ø³Ù… ÙÙŠ Ù†ÙØ³ Ø§Ù„Ù…Ø·Ø¹Ù… = Ù†ÙØ³ staffId Ø¯Ø§Ø¦Ù…Ø§Ù‹ (ØªØ­Ø¯ÙŠØ« Ù„Ø§ ØªÙƒØ±Ø§Ø±).
  /// * Ù†ÙØ³ Ø§Ù„Ø§Ø³Ù… ÙÙŠ Ù…Ø·Ø¹Ù…ÙŠÙ† Ù…Ø®ØªÙ„ÙÙŠÙ† = Ù…Ø¹Ø±ÙØ§Ù† Ù…Ø®ØªÙ„ÙØ§Ù† (Ø¹Ø²Ù„ ØªØ§Ù…).
  /// * Ø§Ù„Ø±Ù…ÙˆØ² ØºÙŠØ± Ø§Ù„Ù…Ø¯Ø¹ÙˆÙ…Ø© ÙÙŠ Ù…Ø³Ø§Ø±Ø§Øª Firebase (.\$#[]/) ØªÙØ³ØªØ¨Ø¯Ù„.
  static String buildStaffId(String restaurantId, String username) {
    final String rid = normalizeRestaurantId(restaurantId);
    final String normalized = normalizeUsername(username);
    final String digest = sha256
        .convert(utf8.encode('$rid|$normalized|orderly-staff'))
        .toString();
    final String sanitized = normalized
        .replaceAll(RegExp(r'[^\w\u0600-\u06FF]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final String prefix =
        sanitized.isEmpty || sanitized == '_' ? 'staff' : sanitized;
    return '${prefix.substring(0, prefix.length.clamp(0, 24))}-'
        '${digest.substring(0, 10)}';
  }

  /// ØªÙˆØ­ÙŠØ¯ Ù…Ø¹Ø±Ù‘Ù Ø§Ù„Ù…Ø·Ø¹Ù… Ù„Ù„Ù…Ù‚Ø§Ø±Ù†Ø© ÙˆØ§Ù„ØªØ®Ø²ÙŠÙ† (Ø­Ø±ÙˆÙ ÙƒØ¨ÙŠØ±Ø© Ø¨Ø¯ÙˆÙ† Ù…Ø³Ø§ÙØ§Øª).
  static String normalizeRestaurantId(String raw) =>
      raw.trim().replaceAll(RegExp(r'\s+'), '').toUpperCase();

  static int _readInt(Object? value) {
    if (value is int) return value;
    return int.tryParse('$value') ?? 0;
  }

  static bool _safeEquals(String left, String right) {
    if (left.length != right.length) return false;
    var difference = 0;
    for (var index = 0; index < left.length; index++) {
      difference |= left.codeUnitAt(index) ^ right.codeUnitAt(index);
    }
    return difference == 0;
  }
}

