/// Ù†Ù…ÙˆØ°Ø¬ Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆØ§Ø­Ø¯ Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„ Ù„Ø¹Ø§Ù…Ù„ Ø§Ù„ØªÙˆØµÙŠÙ„ Ù…Ø¹ Ø§Ù„ØªØªØ¨Ø¹ Ø§Ù„Ù„Ø­Ø¸ÙŠ.
///
/// ÙŠØ­ØªÙˆÙŠ ÙƒÙ„ Ø·Ù„Ø¨ Ø¹Ù„Ù‰:
/// * [DeliveryOrder.id] Ù…Ø¹Ø±Ù ÙØ±ÙŠØ¯ Ù„Ù„Ø·Ù„Ø¨ Ù„Ù…Ø²Ø§Ù…Ù†ØªÙ‡ Ù„Ø­Ø¸ÙŠØ§Ù‹ Ø³Ø­Ø§Ø¨ÙŠØ§Ù‹.
/// * [DeliveryOrder.orderNumber] Ø±Ù‚Ù… Ø§Ù„Ø·Ù„Ø¨ (Ù†Øµ Ø­Ø± Ù„ØªÙ†Ø¸ÙŠÙ… Ø§Ù„Ø£ÙˆØ±Ø¯Ø±Ø§Øª).
/// * [DeliveryOrder.amount] Ø³Ø¹Ø± Ø§Ù„Ø·Ù„Ø¨ Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø±.
/// * [DeliveryOrder.paymentType] Ù†ÙˆØ¹ Ø§Ù„Ø¯ÙØ¹ (ÙƒØ§Ø´ / Ù…Ø§Ø³ØªØ± ÙƒØ§Ø±Ø¯ / Ø§Ø³ØªÙ„Ø§Ù… Ù…Ø¨Ø§Ø´Ø±).
/// * [DeliveryOrder.addedAt] ÙˆÙ‚Øª Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø·Ù„Ø¨.
/// * [DeliveryOrder.status] Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨ (Ù‚ÙŠØ¯ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯ âž¡ï¸ Ù…Ø¹ Ø§Ù„Ø³Ø§Ø¦Ù‚ âž¡ï¸ ØªÙ… Ø§Ù„ØªØ³Ù„ÙŠÙ…).
/// * [DeliveryOrder.driverPin] Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ù…Ø³Ù†Ø¯ Ø¥Ù„ÙŠÙ‡ Ø§Ù„Ø·Ù„Ø¨ (1001 - 1030).
/// * [DeliveryOrder.driverName] Ø§Ø³Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ù…Ø³Ù†Ø¯ Ø¥Ù„ÙŠÙ‡ Ø§Ù„Ø·Ù„Ø¨.
/// * [DeliveryOrder.pickedUpAt] ÙˆÙ‚Øª Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù… Ø§Ù„ÙØ¹Ù„ÙŠ Ù…Ù† Ø§Ù„Ù…Ø·Ø¹Ù… ÙˆØ¨Ø¯Ø¡ Ø§Ù„Ø·Ø±ÙŠÙ‚.
/// * [DeliveryOrder.deliveredAt] ÙˆÙ‚Øª ØªØ³Ù„ÙŠÙ… Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ø²Ø¨ÙˆÙ† Ø¨Ø§Ù„ÙƒØ§Ù…Ù„.
/// * [DeliveryOrder.expectedDurationMinutes] Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ø·Ø¨ÙŠØ¹ÙŠ Ù„Ù„Ø±Ø­Ù„Ø© Ù„ÙƒØ´Ù Ø§Ù„ØªØ£Ø®ÙŠØ±.
library;

import 'package:orderly_worker_web/models/order_payment_type.dart';
import 'package:orderly_worker_web/models/order_status.dart';

class DeliveryOrder {
  /// Ø¥Ù†Ø´Ø§Ø¡ Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯.
  DeliveryOrder({
    String? id,
    this.orderNumber = '',
    required this.amount,
    this.paymentType = OrderPaymentType.cash,
    DateTime? addedAt,
    this.status = OrderStatus.preparing,
    this.driverPin,
    this.driverName,
    this.pickedUpAt,
    this.deliveredAt,
    this.expectedDurationMinutes = 25,
    this.proofImageData,
  })  : id = (id != null && id.isNotEmpty)
            ? id
            : 'ord_${(addedAt ?? DateTime.now()).microsecondsSinceEpoch}_${orderNumber.replaceAll(RegExp(r'\s+'), '')}',
        addedAt = addedAt ?? DateTime.now();

  /// Ø¥Ù†Ø´Ø§Ø¡ Ø·Ù„Ø¨ Ù…Ù† Ø®Ø±ÙŠØ·Ø© (JSON) Ù…Ø³ØªØ±Ø¬ÙŽØ¹Ø© Ù…Ù† Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ Ø£Ùˆ Firebase.
  factory DeliveryOrder.fromJson(Map<String, dynamic> json) {
    final DateTime addedDate = _readDate(json[keyAddedAt]);
    final String ordNum = (json[keyOrderNumber] ?? '').toString().trim();
    final String rawId = (json[keyId] ?? '').toString().trim();

    return DeliveryOrder(
      id: rawId.isNotEmpty
          ? rawId
          : 'ord_${addedDate.microsecondsSinceEpoch}_$ordNum',
      orderNumber: ordNum,
      amount: _readDouble(json[keyAmount]),
      paymentType: OrderPaymentType.fromName(json[keyPaymentType]),
      addedAt: addedDate,
      status: json.containsKey(keyStatus)
          ? OrderStatus.fromName(json[keyStatus])
          : OrderStatus.delivered,
      driverPin: json[keyDriverPin]?.toString(),
      driverName: json[keyDriverName]?.toString(),
      pickedUpAt: json[keyPickedUpAt] != null ? _readDate(json[keyPickedUpAt]) : null,
      deliveredAt: json[keyDeliveredAt] != null ? _readDate(json[keyDeliveredAt]) : null,
      expectedDurationMinutes: _readInt(json[keyExpectedDurationMinutes], fallback: 25),
      proofImageData: json[keyProofImageData]?.toString(),
    );
  }

  /// Ù…ÙØ§ØªÙŠØ­ Ø§Ù„ØªØ®Ø²ÙŠÙ†/JSON.
  static const String keyId = 'id';
  static const String keyOrderNumber = 'orderNumber';
  static const String keyAmount = 'amount';
  static const String keyAddedAt = 'addedAt';
  static const String keyPaymentType = 'paymentType';
  static const String keyStatus = 'status';
  static const String keyDriverPin = 'driverPin';
  static const String keyDriverName = 'driverName';
  static const String keyPickedUpAt = 'pickedUpAt';
  static const String keyDeliveredAt = 'deliveredAt';
  static const String keyExpectedDurationMinutes = 'expectedDurationMinutes';
  static const String keyProofImageData = 'proofImageData';

  /// Ø§Ù„Ù…Ø¹Ø±Ù Ø§Ù„ÙØ±ÙŠØ¯ Ù„Ù„Ø·Ù„Ø¨.
  final String id;

  /// Ø±Ù‚Ù… Ø§Ù„Ø·Ù„Ø¨ (Ù†Øµ Ø­Ø±: Ù‚Ø¯ ÙŠÙƒÙˆÙ† Ø±Ù‚Ù…Ø§Ù‹ Ø£Ùˆ Ø±Ù…Ø²Ø§Ù‹ Ù…Ø«Ù„ `#A12`).
  final String orderNumber;

  /// Ø³Ø¹Ø± Ø§Ù„Ø·Ù„Ø¨ Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø±.
  final double amount;

  /// Ù†ÙˆØ¹ Ø¯ÙØ¹ Ø§Ù„Ø·Ù„Ø¨ (Ø§ÙØªØ±Ø§Ø¶ÙŠØ§Ù‹ ÙƒØ§Ø´).
  final OrderPaymentType paymentType;

  /// ÙˆÙ‚Øª Ø¥Ø¶Ø§ÙØ© Ø§Ù„Ø·Ù„Ø¨ Ø¥Ù„Ù‰ Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¹Ø§Ù…Ù„ Ø£Ùˆ Ø§Ù„Ù†Ø¸Ø§Ù….
  final DateTime addedAt;

  /// Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„Ø­Ø§Ù„ÙŠØ© ÙÙŠ Ù…Ø³Ø§Ø± Ø§Ù„ØªÙˆØµÙŠÙ„.
  final OrderStatus status;

  /// Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ù…Ø³Ù†Ø¯ Ø¥Ù„ÙŠÙ‡ Ø§Ù„Ø·Ù„Ø¨ (1001 Ø¥Ù„Ù‰ 1030).
  final String? driverPin;

  /// Ø§Ø³Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ù…Ø³Ù†Ø¯ Ø¥Ù„ÙŠÙ‡ Ø§Ù„Ø·Ù„Ø¨.
  final String? driverName;

  /// ÙˆÙ‚Øª Ø®Ø±ÙˆØ¬ Ø§Ù„Ø·Ù„Ø¨ ÙˆØ§Ø³ØªÙ„Ø§Ù…Ù‡ Ù…Ù† Ø§Ù„Ù…Ø·Ø¹Ù….
  final DateTime? pickedUpAt;

  /// ÙˆÙ‚Øª ØªØ³Ù„ÙŠÙ… Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ø²Ø¨ÙˆÙ†.
  final DateTime? deliveredAt;

  /// ÙˆÙ‚Øª Ø§Ù„Ø±Ø­Ù„Ø© Ø§Ù„Ø·Ø¨ÙŠØ¹ÙŠ Ø§Ù„Ù…ØªÙˆÙ‚Ø¹ Ø¨Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚ (Ø§ÙØªØ±Ø§Ø¶ÙŠØ§Ù‹ 25 Ø¯Ù‚ÙŠÙ‚Ø©).
  final int expectedDurationMinutes;

  /// ØµÙˆØ±Ø© Ø¥Ø«Ø¨Ø§Øª Ø§Ù„Ø·Ù„Ø¨ Ø¨ØµÙŠØºØ© Data URL Ù…Ø¶ØºÙˆØ·Ø© (Ø§Ø®ØªÙŠØ§Ø±ÙŠØ©ØŒ Ù„Ù„ÙˆÙŠØ¨ ÙˆØ§Ù„Ù‡Ø§ØªÙ).
  final String? proofImageData;

  /// Ø±Ù‚Ù… Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ø¹Ø±Ø¶ ÙÙŠ Ø§Ù„ÙˆØ§Ø¬Ù‡Ø© (Ø£Ùˆ Â«Ø¨Ø¯ÙˆÙ† Ø±Ù‚Ù…Â» Ø¥Ø°Ø§ ØªÙØ±Ùƒ Ø§Ù„Ø­Ù‚Ù„ ÙØ§Ø±ØºØ§Ù‹).
  String get displayNumber => orderNumber.isEmpty ? 'Ø¨Ø¯ÙˆÙ† Ø±Ù‚Ù…' : orderNumber;

  /// Ù†Øµ Ù†ÙˆØ¹ Ø§Ù„Ø¯ÙØ¹ Ù„Ù„Ø¹Ø±Ø¶ ÙÙŠ Ø§Ù„Ø³Ø¬Ù„ ÙˆØ§Ù„Ø´Ø§Ø±Ø§Øª.
  String get displayPayment => paymentType.label;

  /// Ù‡Ù„ ØªÙØ­ØªØ³Ø¨ Ø£Ø¬Ø±Ø© ØªÙˆØµÙŠÙ„ Ø¹Ù† Ù‡Ø°Ø§ Ø§Ù„Ø·Ù„Ø¨ØŸ
  bool get countsWage => paymentType.countsWage;

  /// Ù‡Ù„ ÙŠÙØ¹Ø¯Ù‘ Ø§Ù„Ø·Ù„Ø¨ Ø­Ø§Ù„Ø© Ø®Ø§ØµØ© Ø¨Ø£Ø¬Ø±Ø© ØµÙØ±ØŸ
  bool get hasZeroWage => paymentType.isSpecialCase;

  /// Ù‡Ù„ ÙŠØ­Ù…Ù„ Ø§Ù„Ø¹Ø§Ù…Ù„ Ù…Ø¨Ù„Øº Ù‡Ø°Ø§ Ø§Ù„Ø·Ù„Ø¨ Ù†Ù‚Ø¯Ø§Ù‹ (ÙƒØ§Ø´)ØŸ
  bool get collectsCash => paymentType.collectsCash;

  /// Ù…Ø¯Ø© Ø§Ù„Ø±Ø­Ù„Ø© Ø¹Ù„Ù‰ Ø§Ù„Ø·Ø±ÙŠÙ‚ (Ù…Ù†Ø° Ù„Ø­Ø¸Ø© Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù… Ù…Ù† Ø§Ù„Ù…Ø·Ø¹Ù…).
  Duration? get duration {
    if (pickedUpAt == null) return null;
    final DateTime end = deliveredAt ?? DateTime.now();
    return end.difference(pickedUpAt!);
  }

  /// Ù…Ø¯Ø© Ø§Ù„Ø±Ø­Ù„Ø© Ø¨Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚ (Ø£Ùˆ 0 Ø¥Ø°Ø§ Ù„Ù… ÙŠÙØ³ØªÙ„Ù… Ø¨Ø¹Ø¯).
  int get durationMinutes => duration?.inMinutes ?? 0;

  /// Ù†Øµ Ù…Ù†Ø³Ù‚ Ù„Ù…Ø¯Ø© Ø§Ù„Ø±Ø­Ù„Ø© Ø¨Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©: Ù…Ø«Ø§Ù„ Â«18 Ø¯Ù‚ÙŠÙ‚Ø©Â».
  String get durationFormatted {
    final Duration? d = duration;
    if (d == null) return 'Ø¨Ø§Ù†ØªØ¸Ø§Ø± Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù…';
    final int mins = d.inMinutes;
    final int secs = d.inSeconds % 60;
    if (mins == 0) return '$secs Ø«Ø§Ù†ÙŠØ©';
    return '$mins Ø¯Ù‚ÙŠÙ‚Ø©';
  }

  /// Ù‡Ù„ ØªØ¬Ø§ÙˆØ² Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ø·Ø¨ÙŠØ¹ÙŠ Ù„Ù„Ø·Ø±ÙŠÙ‚ (Ù…ØªØ£Ø®Ø±)ØŸ
  bool get isDelayed {
    if (pickedUpAt == null) return false;
    return durationMinutes > expectedDurationMinutes;
  }

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚ Ø§Ù„Ø¥Ø¶Ø§ÙÙŠØ© Ø§Ù„Ù…ØªØ£Ø®Ø±Ø© Ø¹Ù† Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ù…Ø¹ØªØ§Ø¯ Ù„Ù„Ø·Ø±ÙŠÙ‚.
  int get delayMinutes {
    if (!isDelayed) return 0;
    return durationMinutes - expectedDurationMinutes;
  }

  /// Ù†Ø³Ø®Ø© Ø¬Ø¯ÙŠØ¯Ø© Ù…Ù† Ø§Ù„Ø·Ù„Ø¨ Ù…Ø¹ ØªØ¹Ø¯ÙŠÙ„ Ø¨Ø¹Ø¶ Ø§Ù„Ù‚ÙŠÙ….
  DeliveryOrder copyWith({
    String? id,
    String? orderNumber,
    double? amount,
    OrderPaymentType? paymentType,
    DateTime? addedAt,
    OrderStatus? status,
    String? driverPin,
    String? driverName,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    int? expectedDurationMinutes,
    String? proofImageData,
  }) =>
      DeliveryOrder(
        id: id ?? this.id,
        orderNumber: orderNumber ?? this.orderNumber,
        amount: amount ?? this.amount,
        paymentType: paymentType ?? this.paymentType,
        addedAt: addedAt ?? this.addedAt,
        status: status ?? this.status,
        driverPin: driverPin ?? this.driverPin,
        driverName: driverName ?? this.driverName,
        pickedUpAt: pickedUpAt ?? this.pickedUpAt,
        deliveredAt: deliveredAt ?? this.deliveredAt,
        expectedDurationMinutes:
            expectedDurationMinutes ?? this.expectedDurationMinutes,
        proofImageData: proofImageData ?? this.proofImageData,
      );

  /// ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø·Ù„Ø¨ Ø¥Ù„Ù‰ Ø®Ø±ÙŠØ·Ø© Ù‚Ø§Ø¨Ù„Ø© Ù„Ù„ØªØ®Ø²ÙŠÙ† Ø¨ØµÙŠØºØ© JSON Ø£Ùˆ Ø§Ù„Ø¥Ø±Ø³Ø§Ù„ Ø¥Ù„Ù‰ Firebase.
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyId: id,
        keyOrderNumber: orderNumber,
        keyAmount: amount,
        keyPaymentType: paymentType.storageKey,
        keyAddedAt: addedAt.toIso8601String(),
        keyStatus: status.storageKey,
        if (driverPin != null) keyDriverPin: driverPin,
        if (driverName != null) keyDriverName: driverName,
        if (pickedUpAt != null) keyPickedUpAt: pickedUpAt!.toIso8601String(),
        if (deliveredAt != null) keyDeliveredAt: deliveredAt!.toIso8601String(),
        keyExpectedDurationMinutes: expectedDurationMinutes,
        if (proofImageData != null && proofImageData!.isNotEmpty)
          keyProofImageData: proofImageData,
      };

  /// Ù‚Ø±Ø§Ø¡Ø© Ù‚ÙŠÙ…Ø© Ø¹Ø´Ø±ÙŠØ© Ù…Ù† JSON Ø¨Ø£Ù…Ø§Ù†.
  static double _readDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value == null) return 0;
    return double.tryParse(value.toString().replaceAll(',', '').trim()) ?? 0;
  }

  /// Ù‚Ø±Ø§Ø¡Ø© Ù‚ÙŠÙ…Ø© ØµØ­ÙŠØ­Ø© Ù…Ù† JSON Ø¨Ø£Ù…Ø§Ù†.
  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value == null) return fallback;
    return int.tryParse(value.toString().replaceAll(',', '').trim()) ?? fallback;
  }

  /// Ù‚Ø±Ø§Ø¡Ø© ÙˆÙ‚Øª Ø§Ù„Ø¥Ø¶Ø§ÙØ© Ù…Ù† JSON Ø¨Ø£Ù…Ø§Ù† (Ù†Øµ ISO Ø£Ùˆ Ø¹Ø¯Ø¯ Ù…ÙŠÙ„ÙŠ Ø«Ø§Ù†ÙŠØ©).
  static DateTime _readDate(Object? value) {
    if (value is DateTime) return value;
    if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.round());
    final DateTime? parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed?.toLocal() ?? DateTime.now();
  }

  @override
  String toString() =>
      'DeliveryOrder(id: $id, orderNumber: $orderNumber, amount: $amount, '
      'status: ${status.name}, driverPin: $driverPin, '
      'paymentType: ${paymentType.storageKey}, '
      'addedAt: ${addedAt.toIso8601String()})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryOrder &&
          other.orderNumber == orderNumber &&
          other.amount == amount &&
          other.paymentType == paymentType &&
          other.addedAt == addedAt;

  @override
  int get hashCode => Object.hash(orderNumber, amount, paymentType, addedAt);
}
