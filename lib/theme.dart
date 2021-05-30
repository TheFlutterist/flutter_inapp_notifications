import 'package:flutter/material.dart';

import 'src/inapp_notifications.dart';

class InAppNotificationsTheme {
  static Color get textColor => InAppNotifications.instance.textColor;

  static Color get backgroundColor =>
      InAppNotifications.instance.backgroundColor;

  static bool get shadow => InAppNotifications.instance.shadow;

  static double get titleFontSize => InAppNotifications.instance.titleFontSize;

  static double get descriptionFontSize =>
      InAppNotifications.instance.descriptionFontSize;
}
