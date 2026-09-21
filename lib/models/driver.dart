/// Ù†Ù…ÙˆØ°Ø¬ Ø¨ÙŠØ§Ù†Ø§Øª Ø¹Ø§Ù…Ù„ Ø§Ù„ØªÙˆØµÙŠÙ„ (Driver) Ù…Ø¹ Ø¯Ø¹Ù… Ø±Ù…Ø² Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø³Ø±ÙŠØ¹ (1001-1030).
///
/// ÙŠØ¬Ù…Ø¹ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù…ÙØ¯Ø®ÙŽÙ„Ø© Ù„ÙƒÙ„ Ø¹Ø§Ù…Ù„:
/// * [Driver.name] Ø§Ø³Ù… Ø§Ù„Ø¹Ø§Ù…Ù„.
/// * [Driver.pin] Ø±Ù…Ø² Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø³Ø±ÙŠØ¹ (Ù…Ù† 1001 Ø¥Ù„Ù‰ 1030 Ù„Ø¯Ø¹Ù… 30 Ø¹Ø§Ù…Ù„Ø§Ù‹).
/// * [Driver.orders] Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„Ø© Ø¨Ø§Ø³Ù…Ù‡ ÙˆÙ…Ø³Ø§Ø±Ø§ØªÙ‡Ø§.
///
/// ÙˆÙŠØ­Ø³Ø¨ Ø§Ù„Ù‚ÙŠÙ… Ø§Ù„Ù…Ø§Ù„ÙŠØ© ØªÙ„Ù‚Ø§Ø¦ÙŠØ§Ù‹ Ù…Ù† Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª:
/// * [Driver.ordersCount] Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª.
/// * [Driver.totalOrdersAmount] Ù…Ø¬Ù…ÙˆØ¹ Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª (Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø±).
/// * [Driver.wage] Ø£Ø¬Ø±Ø© Ø§Ù„Ø¹Ø§Ù…Ù„.
/// * [Driver.netAmountToRestaurant] ØµØ§ÙÙŠ Ù‚ÙŠÙ…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ù„Ù„Ù…Ø·Ø¹Ù….
library;

import 'package:orderly_worker_web/models/delivery_order.dart';
import 'package:orderly_worker_web/models/order_payment_type.dart';

class Driver {
  /// Ø¥Ù†Ø´Ø§Ø¡ Ø¹Ø§Ù…Ù„ Ø¬Ø¯ÙŠØ¯.
  const Driver({
    required this.name,
    this.pin = '',
    this.orders = const <DeliveryOrder>[],
    this.wagePerOrder = defaultWagePerOrder,
    this.legacyOrdersCount = 0,
    this.legacyOrdersAmount = 0,
  });

  /// Ø¥Ù†Ø´Ø§Ø¡ Ø¹Ø§Ù…Ù„ Ù…Ù† Ø®Ø±ÙŠØ·Ø© (JSON) Ù…Ø³ØªØ±Ø¬ÙŽØ¹Ø© Ù…Ù† Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ.
  factory Driver.fromJson(Map<String, dynamic> json) {
    final bool hasOrdersKey = json.containsKey(keyOrders);
    return Driver(
      name: (json[keyName] ?? '').toString(),
      pin: (json[keyPin] ?? '').toString().trim(),
      orders: _readOrders(json[keyOrders]),
      legacyOrdersCount: _readInt(
        hasOrdersKey ? json[keyLegacyOrdersCount] : json[keyOrdersCount],
      ),
      legacyOrdersAmount: _readDouble(
        hasOrdersKey ? json[keyLegacyOrdersAmount] : json[keyTotalOrdersAmount],
      ),
      wagePerOrder: _readInt(
        json[keyWagePerOrder],
        fallback: defaultWagePerOrder,
      ),
    );
  }

  /// Ø£Ø¬Ø±Ø© Ø§Ù„Ø¹Ø§Ù…Ù„ Ø¹Ù† Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆØ§Ø­Ø¯ Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø± (Ø§Ù„Ù‚ÙŠÙ…Ø© Ø§Ù„Ø§ÙØªØ±Ø§Ø¶ÙŠØ©).
  static const int defaultWagePerOrder = 1000;

  /// Ù†Ø·Ø§Ù‚ Ø±Ù…ÙˆØ² Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø®Ø§ØµØ© Ø¨Ø§Ù„Ø³Ø§Ø¦Ù‚ÙŠÙ† (1001 Ø¥Ù„Ù‰ 1030).
  static const int minPin = 1001;
  static const int maxPin = 1030;
  static const int maxDrivers = 30;

  /// Ù…ÙØ§ØªÙŠØ­ Ø§Ù„ØªØ®Ø²ÙŠÙ†/JSON.
  static const String keyName = 'name';
  static const String keyPin = 'pin';
  static const String keyOrders = 'orders';
  static const String keyLegacyOrdersCount = 'legacyOrdersCount';
  static const String keyLegacyOrdersAmount = 'legacyOrdersAmount';
  static const String keyOrdersCount = 'ordersCount';
  static const String keyTotalOrdersAmount = 'totalOrdersAmount';
  static const String keyWagePerOrder = 'wagePerOrder';

  /// Ø§Ø³Ù… Ø§Ù„Ø¹Ø§Ù…Ù„.
  final String name;

  /// Ø±Ù…Ø² Ø§Ù„Ø¯Ø®ÙˆÙ„ Ø§Ù„Ø®Ø§Øµ Ø¨Ø§Ù„Ø³Ø§Ø¦Ù‚ (1001 Ø¥Ù„Ù‰ 1030).
  final String pin;

  /// Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„Ø© Ø¨Ø§Ø³Ù… Ø§Ù„Ø¹Ø§Ù…Ù„ (Ù…Ø±ØªÙ‘Ø¨Ø© Ø¨ØªØ±ØªÙŠØ¨ Ø§Ù„Ø¥Ø¶Ø§ÙØ©).
  final List<DeliveryOrder> orders;

  /// Ø£Ø¬Ø±Ø© Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆØ§Ø­Ø¯ Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø±.
  final int wagePerOrder;

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ÙØ±Ø­ÙŽÙ‘Ù„Ø© Ù…Ù† Ø¥ØµØ¯Ø§Ø± Ø³Ø§Ø¨Ù‚ (Ø¨Ø¯ÙˆÙ† ØªÙØ§ØµÙŠÙ„ Ù„ÙƒÙ„ Ø·Ù„Ø¨).
  final int legacyOrdersCount;

  /// Ø¥Ø¬Ù…Ø§Ù„ÙŠ Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…ÙØ±Ø­ÙŽÙ‘Ù„Ø© Ù…Ù† Ø¥ØµØ¯Ø§Ø± Ø³Ø§Ø¨Ù‚.
  final double legacyOrdersAmount;

  /// Ø±Ù…Ø² Ø§Ù„Ø¹Ø±Ø¶ (Ø£Ùˆ Ø§Ù„Ø±Ù…Ø² Ø§Ù„Ù…Ù‚ØªØ±Ø­ Ø¥Ø°Ø§ Ù„Ù… ÙŠÙƒÙ† Ù…Ø®ØµØµØ§Ù‹).
  String get displayPin => pin.isNotEmpty ? pin : 'Ø¨Ø¯ÙˆÙ† Ø±Ù…Ø²';

  /// Ø¥ÙŠØ¬Ø§Ø¯ Ø£ÙˆÙ„ Ø±Ù…Ø² Ù…ØªØ§Ø­ ÙˆØºÙŠØ± Ù…Ø³ØªØ®Ø¯Ù… Ø¨ÙŠÙ† 1001 Ùˆ 1030 Ù„Ø¯Ø¹Ù… Ø§Ù„ØªØ®ØµÙŠØµ Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ.
  static String findNextAvailablePin(Iterable<Driver> drivers) {
    final Set<String> usedPins = drivers
        .map((Driver d) => d.pin.trim())
        .where((String p) => p.isNotEmpty)
        .toSet();

    for (int i = minPin; i <= maxPin; i++) {
      final String candidate = i.toString();
      if (!usedPins.contains(candidate)) {
        return candidate;
      }
    }
    return minPin.toString();
  }

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª = Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„Ø© + Ø§Ù„Ø£Ø±Ù‚Ø§Ù… Ø§Ù„Ù…ÙØ±Ø­ÙŽÙ‘Ù„Ø©.
  int get ordersCount => orders.length + legacyOrdersCount;

  /// Ù…Ø¬Ù…ÙˆØ¹ Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø¨Ø§Ù„Ø¯ÙŠÙ†Ø§Ø± = Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø³Ø¬ÙŽÙ‘Ù„Ø© + Ø§Ù„Ù…ÙØ±Ø­ÙŽÙ‘Ù„Ø©.
  double get totalOrdersAmount =>
      legacyOrdersAmount +
      orders.fold<double>(0, (double sum, DeliveryOrder order) {
        return sum + order.amount;
      });

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„ØªÙŠ ØªÙØ­ØªØ³Ø¨ Ù„Ù‡Ø§ Ø£Ø¬Ø±Ø© ØªÙˆØµÙŠÙ„ (Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù†Ù‚Ø¯ÙŠØ© ÙÙ‚Ø·).
  int get wageEligibleOrdersCount =>
      legacyOrdersCount +
      orders
          .where((DeliveryOrder order) => order.countsWage)
          .length;

  /// Ø¹Ø¯Ø¯ Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø®Ø§ØµØ© Ø¨Ø£Ø¬Ø±Ø© ØµÙØ± (Ù…Ø§Ø³ØªØ± ÙƒØ§Ø±Ø¯ Ø£Ùˆ Ø§Ø³ØªÙ„Ø§Ù… Ù…Ø¨Ø§Ø´Ø±).
  int get zeroWageOrdersCount =>
      orders.where((DeliveryOrder order) => order.hasZeroWage).length;

  /// Ù…Ø¬Ù…ÙˆØ¹ Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ø®Ø§ØµØ© Ø¨Ø£Ø¬Ø±Ø© ØµÙØ±.
  double get zeroWageOrdersAmount => orders
      .where((DeliveryOrder order) => order.hasZeroWage)
      .fold<double>(0, (double sum, DeliveryOrder order) => sum + order.amount);

  /// Ù…Ø¬Ù…ÙˆØ¹ Ù…Ø¨Ø§Ù„Øº Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù†Ù‚Ø¯ÙŠØ© (Ø§Ù„Ù…Ø¨Ø§Ù„Øº Ø§Ù„ØªÙŠ ÙŠØ­Ù…Ù„Ù‡Ø§ Ø§Ù„Ø¹Ø§Ù…Ù„ Ù†Ù‚Ø¯Ø§Ù‹).
  double get cashOrdersAmount =>
      legacyOrdersAmount +
      orders
          .where((DeliveryOrder order) => order.collectsCash)
          .fold<double>(0, (double sum, DeliveryOrder order) => sum + order.amount);

  /// Ù‡Ù„ ÙŠÙˆØ¬Ø¯ Ø·Ù„Ø¨Ø§Øª Ø¨Ø­Ø§Ù„Ø© Ø®Ø§ØµØ© Ø¨Ø£Ø¬Ø±Ø© ØµÙØ±ØŸ
  bool get hasZeroWageOrders => zeroWageOrdersCount > 0;

  /// Ù‡Ù„ Ø£Ø¬Ø±Ø© Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆØ§Ø­Ø¯ Ù„Ù‡Ø°Ø§ Ø§Ù„Ø¹Ø§Ù…Ù„ ØµÙØ±ØŸ
  bool get hasZeroWageRate => wagePerOrder == 0;

  /// Ø£Ø¬Ø±Ø© Ø§Ù„Ø¹Ø§Ù…Ù„ Ø§Ù„Ù…Ø³ØªØ­Ù‚Ø©.
  double get wage => wageEligibleOrdersCount * wagePerOrder.toDouble();

  /// ØµØ§ÙÙŠ Ù‚ÙŠÙ…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ù„Ù„Ù…Ø·Ø¹Ù….
  double get netAmountToRestaurant => totalOrdersAmount;

  /// Ù‡Ù„ ÙŠÙˆØ¬Ø¯ Ø¹Ø¯Ø¯/Ù…Ø¨Ù„Øº Ø·Ù„Ø¨Ø§Øª Ù…ÙØ±Ø­ÙŽÙ‘Ù„ Ù…Ù† Ø¥ØµØ¯Ø§Ø± Ø³Ø§Ø¨Ù‚ØŸ
  bool get hasLegacyOrders =>
      legacyOrdersCount > 0 || legacyOrdersAmount > 0;

  /// Ø±Ù‚Ù… Ù…Ù‚ØªØ±Ø­ Ù„Ù„Ø·Ù„Ø¨ Ø§Ù„Ø¬Ø¯ÙŠØ¯.
  String get suggestedOrderNumber {
    int highest = 0;
    for (final DeliveryOrder order in orders) {
      final int? number = int.tryParse(order.orderNumber.trim());
      if (number != null && number > highest) {
        highest = number;
      }
    }
    return '${(highest > 0 ? highest : ordersCount) + 1}';
  }

  /// Ù†Ø³Ø®Ø© Ø¬Ø¯ÙŠØ¯Ø© Ù…Ù† Ø§Ù„Ø¹Ø§Ù…Ù„ Ù…Ø¹ ØªØ¹Ø¯ÙŠÙ„ Ø¨Ø¹Ø¶ Ø§Ù„Ù‚ÙŠÙ….
  Driver copyWith({
    String? name,
    String? pin,
    List<DeliveryOrder>? orders,
    int? wagePerOrder,
    int? legacyOrdersCount,
    double? legacyOrdersAmount,
  }) => Driver(
    name: name ?? this.name,
    pin: pin ?? this.pin,
    orders: orders ?? this.orders,
    wagePerOrder: wagePerOrder ?? this.wagePerOrder,
    legacyOrdersCount: legacyOrdersCount ?? this.legacyOrdersCount,
    legacyOrdersAmount: legacyOrdersAmount ?? this.legacyOrdersAmount,
  );

  /// Ø¥Ø¶Ø§ÙØ© Ø·Ù„Ø¨ Ø¬Ø¯ÙŠØ¯ Ø¨Ù‚ÙŠÙ…Ø© [amount] Ø¯ÙŠÙ†Ø§Ø± Ø¥Ù„Ù‰ Ù‡Ø°Ø§ Ø§Ù„Ø¹Ø§Ù…Ù„.
  Driver addOrder(
    double amount, {
    String orderNumber = '',
    OrderPaymentType paymentType = OrderPaymentType.cash,
    DateTime? addedAt,
  }) => addDeliveryOrder(
    DeliveryOrder(
      orderNumber: orderNumber.trim(),
      amount: amount,
      paymentType: paymentType,
      addedAt: addedAt,
      driverPin: pin,
      driverName: name,
    ),
  );

  /// Ø¥Ø¶Ø§ÙØ© Ø·Ù„Ø¨ Ø¬Ø§Ù‡Ø² (Ø¨ÙƒÙ„ ØªÙØ§ØµÙŠÙ„Ù‡) Ø¥Ù„Ù‰ Ø­Ø³Ø§Ø¨ Ø§Ù„Ø¹Ø§Ù…Ù„ Ù…Ø¹ Ø±Ø¨Ø·Ù‡ Ø¨Ø§Ù„Ø±Ù…Ø² ÙˆØ§Ù„Ø§Ø³Ù….
  Driver addDeliveryOrder(DeliveryOrder order) {
    final DeliveryOrder linked = (order.driverPin == null || order.driverPin!.isEmpty)
        ? order.copyWith(driverPin: pin, driverName: name)
        : order;
    return copyWith(
      orders: <DeliveryOrder>[...orders, linked],
    );
  }

  /// Ø­Ø°Ù Ø§Ù„Ø·Ù„Ø¨ Ø§Ù„ÙˆØ§Ù‚Ø¹ ÙÙŠ Ø§Ù„ØªØ±ØªÙŠØ¨ [index] Ù…Ù† Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª.
  Driver removeOrderAt(int index) {
    if (index < 0 || index >= orders.length) {
      return this;
    }
    return copyWith(
      orders: <DeliveryOrder>[
        for (int i = 0; i < orders.length; i++)
          if (i != index) orders[i],
      ],
    );
  }

  /// Ø­Ø°Ù Ø£ÙˆÙ„ Ø·Ù„Ø¨ Ù…Ø·Ø§Ø¨Ù‚ Ù„Ù„Ø·Ù„Ø¨ [order].
  Driver removeOrder(DeliveryOrder order) => removeOrderAt(orders.indexOf(order));

  /// ØªØµÙÙŠØ± Ø­Ø³Ø§Ø¨Ø§Øª Ø§Ù„ÙŠÙˆÙ… Ù…Ø¹ Ø§Ù„Ø§Ø­ØªÙØ§Ø¸ Ø¨Ø§Ø³Ù… Ø§Ù„Ø¹Ø§Ù…Ù„ ÙˆØ±Ù…Ø²Ù‡ Ø§Ù„Ø®Ø§Øµ ÙˆØ£Ø¬Ø±Ø© Ø§Ù„Ø·Ù„Ø¨.
  Driver resetDay() => copyWith(
    orders: const <DeliveryOrder>[],
    legacyOrdersCount: 0,
    legacyOrdersAmount: 0,
  );

  /// ØªØ­ÙˆÙŠÙ„ Ø§Ù„Ø¹Ø§Ù…Ù„ Ø¥Ù„Ù‰ Ø®Ø±ÙŠØ·Ø© Ù‚Ø§Ø¨Ù„Ø© Ù„Ù„ØªØ®Ø²ÙŠÙ† Ø¨ØµÙŠØºØ© JSON Ø£Ùˆ Firebase.
  Map<String, dynamic> toJson() => <String, dynamic>{
    keyName: name,
    keyPin: pin,
    keyOrders: orders.map((DeliveryOrder order) => order.toJson()).toList(),
    keyLegacyOrdersCount: legacyOrdersCount,
    keyLegacyOrdersAmount: legacyOrdersAmount,
    keyWagePerOrder: wagePerOrder,
  };

  /// Ù‚Ø±Ø§Ø¡Ø© Ù‚Ø§Ø¦Ù…Ø© Ø§Ù„Ø·Ù„Ø¨Ø§Øª Ø§Ù„Ù…Ø­ÙÙˆØ¸Ø© Ø¨Ø£Ù…Ø§Ù†.
  static List<DeliveryOrder> _readOrders(Object? value) {
    if (value is! List) {
      return const <DeliveryOrder>[];
    }
    return value
        .whereType<Map<Object?, Object?>>()
        .map(
          (Map<Object?, Object?> item) =>
              DeliveryOrder.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  /// Ù‚Ø±Ø§Ø¡Ø© Ù‚ÙŠÙ…Ø© ØµØ­ÙŠØ­Ø© Ù…Ù† JSON Ø¨Ø£Ù…Ø§Ù†.
  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value == null) return fallback;
    return int.tryParse(value.toString().replaceAll(',', '').trim()) ??
        fallback;
  }

  /// Ù‚Ø±Ø§Ø¡Ø© Ù‚ÙŠÙ…Ø© Ø¹Ø´Ø±ÙŠØ© Ù…Ù† JSON Ø¨Ø£Ù…Ø§Ù†.
  static double _readDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value == null) return 0;
    return double.tryParse(value.toString().replaceAll(',', '').trim()) ?? 0;
  }

  @override
  String toString() =>
      'Driver(name: $name, pin: $pin, ordersCount: $ordersCount, '
      'wageEligibleOrdersCount: $wageEligibleOrdersCount, '
      'zeroWageOrdersCount: $zeroWageOrdersCount, '
      'totalOrdersAmount: $totalOrdersAmount, wage: $wage, '
      'netAmountToRestaurant: $netAmountToRestaurant, '
      'orders: ${orders.length})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          other.name == name &&
          other.wagePerOrder == wagePerOrder &&
          other.legacyOrdersCount == legacyOrdersCount &&
          other.legacyOrdersAmount == legacyOrdersAmount &&
          _sameOrders(other.orders, orders);

  /// Ù…Ù‚Ø§Ø±Ù†Ø© Ù‚Ø§Ø¦Ù…ØªÙŠ Ø·Ù„Ø¨Ø§Øª Ø¹Ù†ØµØ±Ø§Ù‹ Ø¨Ø¹Ù†ØµØ±.
  static bool _sameOrders(List<DeliveryOrder> a, List<DeliveryOrder> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    name,
    wagePerOrder,
    legacyOrdersCount,
    legacyOrdersAmount,
    Object.hashAll(orders),
  );
}
