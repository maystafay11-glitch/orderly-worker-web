/// Ø­Ø§Ù„Ø§Øª Ø§Ù„Ø·Ù„Ø¨ ÙˆÙ…Ø±Ø§Ø­Ù„ Ø§Ù„ØªÙˆØµÙŠÙ„ ÙÙŠ Ù†Ø¸Ø§Ù… Orderly ÙˆØ§Ù„ØªØªØ¨Ø¹ Ø§Ù„Ù„Ø­Ø¸ÙŠ.
library;

import 'package:flutter/material.dart';
import 'package:orderly_worker_web/theme/app_theme.dart';

/// Ø­Ø§Ù„Ø© Ù…Ø³Ø§Ø± Ø§Ù„Ø·Ù„Ø¨ Ù…Ù† Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯ Ø¥Ù„Ù‰ Ø§Ù„ØªØ³Ù„ÙŠÙ….
enum OrderStatus {
  /// Ù‚ÙŠØ¯ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯ Ø¨Ø§Ù„Ù…Ø·Ø¹Ù… (Ø¨Ø§Ù†ØªØ¸Ø§Ø± Ø§Ø³ØªÙ„Ø§Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚).
  preparing(
    label: 'Ù‚ÙŠØ¯ Ø§Ù„Ø¥Ø¹Ø¯Ø§Ø¯',
    description: 'Ø§Ù„Ø·Ù„Ø¨ Ù‚ÙŠØ¯ Ø§Ù„ØªØ­Ø¶ÙŠØ± Ø¨Ø§Ù„Ù…Ø·Ø¹Ù… ÙˆØ¬Ø§Ù‡Ø² Ù„Ù„Ø§Ø³ØªÙ„Ø§Ù… Ù…Ù† Ø§Ù„Ø³Ø§Ø¦Ù‚.',
    stepIndex: 0,
    color: Color(0xFFF59E0B), // Ø£ØµÙØ± ÙƒÙ‡Ø±Ù…Ø§Ù†ÙŠ
    icon: Icons.outdoor_grill_outlined,
  ),

  /// Ù…Ø¹ Ø§Ù„Ø³Ø§Ø¦Ù‚ (Ø¨Ø§Ù„Ø·Ø±ÙŠÙ‚ Ø¥Ù„Ù‰ Ø§Ù„Ø²Ø¨ÙˆÙ†).
  pickedUp(
    label: 'Ù…Ø¹ Ø§Ù„Ø³Ø§Ø¦Ù‚ (Ø¨Ø§Ù„Ø·Ø±ÙŠÙ‚)',
    description: 'Ø§Ø³ØªÙ„Ù… Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø§Ù„Ø·Ù„Ø¨ ÙˆÙ‡Ùˆ Ø§Ù„Ø¢Ù† ÙÙŠ Ø·Ø±ÙŠÙ‚Ù‡ Ø¥Ù„Ù‰ Ø§Ù„Ø²Ø¨ÙˆÙ†.',
    stepIndex: 1,
    color: Color(0xFF2563EB), // Ø£Ø²Ø±Ù‚ Ù†Ø´Ø·
    icon: Icons.two_wheeler_rounded,
  ),

  /// ØªÙ… Ø§Ù„ØªØ³Ù„ÙŠÙ… Ù„Ù„Ø²Ø¨ÙˆÙ† Ø¨Ù†Ø¬Ø§Ø­.
  delivered(
    label: 'ØªÙ… Ø§Ù„ØªØ³Ù„ÙŠÙ…',
    description: 'ØªÙ… ØªØ³Ù„ÙŠÙ… Ø§Ù„Ø·Ù„Ø¨ Ù„Ù„Ø²Ø¨ÙˆÙ† ÙˆØ§Ø­ØªØ³Ø§Ø¨ Ø§Ù„Ø£Ø¬Ø±Ø© ÙˆØ§Ù„Ù…Ø¯Ø©.',
    stepIndex: 2,
    color: AppColors.success, // Ø£Ø®Ø¶Ø±
    icon: Icons.check_circle_rounded,
  ),

  /// ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø·Ù„Ø¨.
  cancelled(
    label: 'Ù…Ù„ØºÙŠ',
    description: 'ØªÙ… Ø¥Ù„ØºØ§Ø¡ Ø§Ù„Ø·Ù„Ø¨.',
    stepIndex: -1,
    color: AppColors.danger, // Ø£Ø­Ù…Ø±
    icon: Icons.cancel_outlined,
  );

  const OrderStatus({
    required this.label,
    required this.description,
    required this.stepIndex,
    required this.color,
    required this.icon,
  });

  /// Ø§Ù„Ù†Øµ Ø§Ù„Ø¹Ø±Ø¨ÙŠ Ù„Ø­Ø§Ù„Ø© Ø§Ù„Ø·Ù„Ø¨.
  final String label;

  /// Ø§Ù„Ø´Ø±Ø­ Ø§Ù„ØªÙˆØ¶ÙŠØ­ÙŠ Ù„Ù„Ø­Ø§Ù„Ø©.
  final String description;

  /// Ø±Ù‚Ù… Ù…Ø±Ø­Ù„Ø© Ø§Ù„ØªÙ‚Ø¯Ù… (0: Ø¥Ø¹Ø¯Ø§Ø¯ØŒ 1: Ø·Ø±ÙŠÙ‚ØŒ 2: ØªØ³Ù„ÙŠÙ…).
  final int stepIndex;

  /// Ø§Ù„Ù„ÙˆÙ† Ø§Ù„Ù…Ø®ØµØµ Ù„Ù„Ø­Ø§Ù„Ø©.
  final Color color;

  /// Ø£ÙŠÙ‚ÙˆÙ†Ø© Ø§Ù„Ø­Ø§Ù„Ø©.
  final IconData icon;

  /// Ù‡Ù„ Ø§Ù„Ø·Ù„Ø¨ Ù„Ø§ ÙŠØ²Ø§Ù„ Ø¬Ø§Ø±ÙŠØ§Ù‹ ÙˆÙ†Ø´Ø·Ø§Ù‹ØŸ
  bool get isActive => this == OrderStatus.preparing || this == OrderStatus.pickedUp;

  /// Ù‡Ù„ Ø§Ù„Ø·Ù„Ø¨ ÙÙŠ Ø§Ù„Ø·Ø±ÙŠÙ‚ Ù…Ø¹ Ø§Ù„Ø³Ø§Ø¦Ù‚ Ø­Ø§Ù„ÙŠØ§Ù‹ØŸ
  bool get isOnTheRoad => this == OrderStatus.pickedUp;

  /// Ù‡Ù„ Ø§ÙƒØªÙ…Ù„ ØªØ³Ù„ÙŠÙ… Ø§Ù„Ø·Ù„Ø¨ØŸ
  bool get isCompleted => this == OrderStatus.delivered;

  /// Ù…ÙØªØ§Ø­ Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø¨ØµÙŠØºØ© JSON.
  String get storageKey => name;

  /// Ù‚Ø±Ø§Ø¡Ø© Ø§Ù„Ø­Ø§Ù„Ø© Ù…Ù† Ù‚ÙŠÙ…Ø© Ù…Ø®Ø²Ù†Ø© Ø¨Ø£Ù…Ø§Ù†.
  static OrderStatus fromName(Object? value) {
    final String key = value?.toString().trim() ?? '';
    for (final OrderStatus status in OrderStatus.values) {
      if (status.name == key) {
        return status;
      }
    }
    // Ù„Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© Ø§Ù„ØªÙŠ Ù„ÙŠØ³ Ù„Ù‡Ø§ Ø­Ø§Ù„Ø© Ù…Ø­Ø¯Ø¯Ø©ØŒ Ù†Ø¹ØªØ¨Ø±Ù‡Ø§ Ø¬Ø§Ù‡Ø²Ø© ÙˆÙ…ÙƒØªÙ…Ù„Ø©
    return OrderStatus.delivered;
  }
}
