/*
GLOBAL UTILITY LAYER
- DO NOT assume schema structure or feature type
- only provide pure transformations, formatting, UI helpers, and
stateless logic

Works for:
1. chat messages
2. posts
3. future reactions system
4. group features
*/

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

/// ----------------------------
/// COUNTERS (GENERIC)
/// ----------------------------

int countItems(List<dynamic>? list) {
  return list?.length ?? 0;
}

bool listContains(List<dynamic>? list, dynamic value) {
  return list?.contains(value) ?? false;
}

/// ----------------------------
/// MEDIA HELPERS (SCHEMA AGNOSTIC)
/// ----------------------------

bool hasMedia(String? url) {
  return (url ?? '').trim().isNotEmpty;
}

bool hasMediaList(List<String>? list) {
  return list != null && list.isNotEmpty;
}

/// ----------------------------
/// TIME HELPERS
/// ----------------------------

String formatTimeAgo(DateTime? date) {
  if (date == null) return '';
  return timeago.format(date);
}

String formatDate(DateTime? date) {
  if (date == null) return '';
  return DateFormat('MMM d, y').format(date);
}

/// ----------------------------
/// TEXT HELPERS
/// ----------------------------

bool isEmptyText(String? text) {
  return (text ?? '').trim().isEmpty;
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength)}...';
}

/// ----------------------------
/// UI / MATH HELPERS
/// ----------------------------

double clampDouble(double value, double min, double max) {
  return math.max(min, math.min(max, value));
}