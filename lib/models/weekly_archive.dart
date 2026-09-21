/// Ù†Ù…ÙˆØ°Ø¬ Ù…Ù„Ø®Øµ Ø£Ø³Ø¨ÙˆØ¹ÙŠ ÙŠÙØ¤Ø±Ø´Ù Ø¹Ù†Ø¯ ØªØµÙÙŠØ± Ø§Ù„Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠØ©.
///
/// ÙŠØ­ØªÙˆÙŠ Ø¹Ù„Ù‰ Ø¥Ø¬Ù…Ø§Ù„ÙŠØ§Øª Ø§Ù„ÙØªØ±Ø© Ù„ØªØªØ¨Ø¹Ù‡Ø§ Ù„Ø§Ø­Ù‚Ø§Ù‹ ÙÙŠ Â«Ø§Ù„Ù…Ù„Ø®Øµ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹ÙŠÂ»:
/// * [WeeklyArchive.totalOrders] Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„ÙƒÙ„ÙŠ Ø®Ù„Ø§Ù„ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹.
/// * [WeeklyArchive.totalAmount] Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ø§Ù„Ù…Ø¨Ø§Ù„Øº Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø±.
/// * [WeeklyArchive.totalWage] Ø£Ø¬ÙˆØ± Ø§Ù„Ø¹Ù…Ø§Ù„ Ø®Ù„Ø§Ù„ Ø§Ù„Ø£Ø³Ø¨ÙˆØ¹.
/// * [WeeklyArchive.netAmount] ØµØ§ÙÙŠ Ø£Ø±Ø¨Ø§Ø­ Ø§Ù„Ù…Ø·Ø¹Ù….
/// * [WeeklyArchive.periodStart]/[WeeklyArchive.periodEnd] ØªÙˆØ§Ø±ÙŠØ® Ø§Ù„ÙØªØ±Ø©.
/// * [WeeklyArchive.createdAt] ÙˆÙ‚Øª Ø§Ù„Ø£Ø±Ø´ÙØ©.
library;

class WeeklyArchive {
  WeeklyArchive({
    required this.totalOrders,
    required this.totalAmount,
    required this.totalWage,
    required this.netAmount,
    required this.periodStart,
    required this.periodEnd,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory WeeklyArchive.fromJson(Map<String, dynamic> json) => WeeklyArchive(
    totalOrders: _readInt(json['totalOrders']),
    totalAmount: _readDouble(json['totalAmount']),
    totalWage: _readDouble(json['totalWage']),
    netAmount: _readDouble(json['netAmount']),
    periodStart: _readDate(json['periodStart']),
    periodEnd: _readDate(json['periodEnd']),
    createdAt: _readDate(json['createdAt']),
  );

  final int totalOrders;
  final double totalAmount;
  final double totalWage;
  final double netAmount;
  final DateTime periodStart;
  final DateTime periodEnd;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'totalOrders': totalOrders,
    'totalAmount': totalAmount,
    'totalWage': totalWage,
    'netAmount': netAmount,
    'periodStart': periodStart.toIso8601String(),
    'periodEnd': periodEnd.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  static int _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value == null) return 0;
    return int.tryParse(value.toString().trim()) ?? 0;
  }

  static double _readDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value == null) return 0;
    return double.tryParse(value.toString().replaceAll(',', '').trim()) ?? 0;
  }

  static DateTime _readDate(Object? value) {
    if (value is DateTime) return value;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.round());
    }
    final DateTime? parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed ?? DateTime.now();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyArchive &&
          other.totalOrders == totalOrders &&
          other.totalAmount == totalAmount &&
          other.totalWage == totalWage &&
          other.netAmount == netAmount &&
          other.periodStart == periodStart &&
          other.periodEnd == periodEnd;

  @override
  int get hashCode =>
      Object.hash(totalOrders, totalAmount, totalWage, netAmount, periodStart, periodEnd);
}
