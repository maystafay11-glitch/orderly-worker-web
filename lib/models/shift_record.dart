/// Ù†Ù…ÙˆØ°Ø¬ Ø¨ÙŠØ§Ù†Ø§Øª Ø³Ø¬Ù„ Ø§Ù„ÙˆØ±Ø¯ÙŠØ© Ø§Ù„ÙŠÙˆÙ…ÙŠ (Shift History) Ù„Ø¹Ø§Ù…Ù„ Ø§Ù„ØªÙˆØµÙŠÙ„.
///
/// ÙŠÙˆØ«Ù‘Ù‚ Ø£Ø¯Ø§Ø¡ Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø®Ù„Ø§Ù„ Ø§Ù„ÙŠÙˆÙ…:
/// * Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³ØªÙ„Ù…Ø© ÙˆØ§Ù„Ù…Ù†Ø¬Ø²Ø©.
/// * Ø£ÙˆÙ‚Ø§Øª Ø§Ù„Ø§Ø³ØªÙ„Ø§Ù… ÙˆØ£ÙˆÙ‚Ø§Øª Ø§Ù„ØªØ³Ù„ÙŠÙ… Ø¨Ø¯Ù‚Ø©.
/// * Ù…Ø¯Ø© ÙƒÙ„ Ø±Ø­Ù„Ø©ØŒ ÙˆÙ…ØªÙˆØ³Ø· ÙˆÙ‚Øª Ø§Ù„ØªÙˆØµÙŠÙ„.
/// * Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ØªØ£Ø®Ø±Ø© Ø¹Ù† ÙˆÙ‚Øª Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø§Ù„Ù…Ø¹ØªØ§Ø¯ Ù„ÙƒØ´Ù "Ø§Ù„ØªØ³Ø®ÙŠØª".
/// * Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ù…Ø¨Ø§Ù„Øº Ø§Ù„ÙƒØ§Ø´ Ø§Ù„Ù…Ù‚Ø¨ÙˆØ¶Ø© ÙˆØ§Ù„Ø£Ø¬ÙˆØ± Ø§Ù„Ù…Ø³ØªØ­Ù‚Ø©.
library;

import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/order_status.dart';

class ShiftRecord {
  const ShiftRecord({
    required this.driverPin,
    required this.driverName,
    required this.date,
    this.orders = const <DeliveryOrder>[],
  });

  /// Ø¥Ù†Ø´Ø§Ø¡ Ø³Ø¬Ù„ ÙˆØ±Ø¯ÙŠØ© Ù…Ù† Ø®Ø±ÙŠØ·Ø© JSON.
  factory ShiftRecord.fromJson(Map<String, dynamic> json) {
    return ShiftRecord(
      driverPin: (json['driverPin'] ?? '').toString(),
      driverName: (json['driverName'] ?? '').toString(),
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      orders: (json['orders'] is List)
          ? (json['orders'] as List)
              .whereType<Map<Object?, Object?>>()
              .map((Map<Object?, Object?> item) =>
                  DeliveryOrder.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const <DeliveryOrder>[],
    );
  }

  /// Ø±Ù…Ø² Ø§Ù„Ø³Ø§Ø¦Ù‚ (1001-1030).
  final String driverPin;

  /// Ø§Ø³Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚.
  final String driverName;

  /// ØªØ§Ø±ÙŠØ® Ø§Ù„ÙˆØ±Ø¯ÙŠØ©.
  final DateTime date;

  /// Ù‚Ø§Ø¦Ù…Ø© Ø·Ù„Ø¨Ø§Øª Ø§Ù„ÙˆØ±Ø¯ÙŠØ©.
  final List<DeliveryOrder> orders;

  /// Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ø·Ù„Ø¨Ø§Øª ÙÙŠ Ø§Ù„ÙˆØ±Ø¯ÙŠØ©.
  int get totalOrdersCount => orders.length;

  /// Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³Ù„Ù‘Ù…Ø© ÙØ¹Ù„ÙŠØ§Ù‹ Ø¨Ù†Ø¬Ø§Ø­.
  List<DeliveryOrder> get deliveredOrders =>
      orders.where((DeliveryOrder o) => o.status == OrderStatus.delivered).toList();

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ÙƒØªÙ…Ù„Ø©.
  int get completedOrdersCount => deliveredOrders.length;

  /// Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ØªØ£Ø®Ø±Ø© Ø¹Ù† ÙˆÙ‚Øª Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø§Ù„Ù…Ø¹ØªØ§Ø¯.
  List<DeliveryOrder> get delayedOrders =>
      orders.where((DeliveryOrder o) => o.isDelayed).toList();

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ØªØ£Ø®Ø±Ø©.
  int get delayedOrdersCount => delayedOrders.length;

  /// Ù…ØªÙˆØ³Ø· ÙˆÙ‚Øª Ø§Ù„ØªÙˆØµÙŠÙ„ Ù„Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ù†Ø¬Ø²Ø© Ø¨Ø§Ù„Ø¯Ù‚Ø§Ø¦Ù‚.
  double get averageDeliveryMinutes {
    final List<DeliveryOrder> withDuration =
        deliveredOrders.where((DeliveryOrder o) => o.duration != null).toList();
    if (withDuration.isEmpty) return 0;
    final int totalMins = withDuration.fold<int>(
      0,
      (int sum, DeliveryOrder o) => sum + o.durationMinutes,
    );
    return totalMins / withDuration.length;
  }

  /// Ù†Ø³Ø¨Ø© Ø§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø¨Ø§Ù„ÙˆÙ‚Øª Ø§Ù„Ù…Ø¹ØªØ§Ø¯ (0 .. 100%).
  int get onTimeRatePercent {
    if (completedOrdersCount == 0) return 100;
    final int onTimeCount = completedOrdersCount - delayedOrdersCount;
    return ((onTimeCount / completedOrdersCount) * 100).round().clamp(0, 100);
  }

  /// Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ù†Ù‚Ø¯ÙŠØ© Ø§Ù„Ù…Ù‚Ø¨ÙˆØ¶Ø© Ø§Ù„ØªÙŠ ÙŠØ­Ù…Ù„Ù‡Ø§ Ø§Ù„Ø³Ø§Ø¦Ù‚.
  double get totalCollectedCash => orders
      .where((DeliveryOrder o) => o.collectsCash)
      .fold<double>(0, (double sum, DeliveryOrder o) => sum + o.amount);

  /// Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ø£Ø¬ÙˆØ± Ø§Ù„Ù…Ø³ØªØ­Ù‚Ø© Ù„Ù„Ø³Ø§Ø¦Ù‚ Ø¹Ù† Ù‡Ø°Ù‡ Ø§Ù„ÙˆØ±Ø¯ÙŠØ© (1000 Ù„ÙƒÙ„ Ø·Ù„Ø¨ Ù…Ø³ØªØ­Ù‚).
  double get totalWagesEarned => orders
      .where((DeliveryOrder o) => o.countsWage)
      .fold<double>(0, (double sum, DeliveryOrder o) => sum + 1000);

  /// ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø³Ø¬Ù„ Ø¥Ù„Ù‰ Ø®Ø±ÙŠØ·Ø© Ù‚Ø§Ø¨Ù„Ø© Ù„Ù„Ø­ÙØ¸ ÙÙŠ JSON Ø£Ùˆ Firebase.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'driverPin': driverPin,
        'driverName': driverName,
        'date': date.toIso8601String(),
        'orders': orders.map((DeliveryOrder o) => o.toJson()).toList(),
      };
}
