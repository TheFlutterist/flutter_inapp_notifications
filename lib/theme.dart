import 'package:flutter/material.dart';

import 'animations/inapp_notification_animation.dart';
import 'animations/offset_animation.dart';
import 'animations/opacity_animation.dart';
import 'animations/scale_animation.dart';
import 'src/inapp_notifications.dart';

class InAppNotificationsTheme {
  /// Text color set to [InAppNotifications] instance
  static Color get textColor => InAppNotifications.instance.textColor;

  /// Background color set to [InAppNotifications] instance
  static Color get backgroundColor =>
      InAppNotifications.instance.backgroundColor;

  /// Shadow boolean set to [InAppNotifications] instance
  static bool get shadow => InAppNotifications.instance.shadow;

  /// Title font size set to [InAppNotifications] instance
  static double get titleFontSize => InAppNotifications.instance.titleFontSize;

  /// Description font size set to [InAppNotifications] instance
  static double get descriptionFontSize =>
      InAppNotifications.instance.descriptionFontSize;

  /// [InAppNotificationAnimation] used to show In-App Notification based on set animationStyle to [InAppNotifications] instance
  static InAppNotificationAnimation get showAnimation {
    InAppNotificationAnimation _animation;

    switch (InAppNotifications.instance.animationStyle) {
      case InAppNotificationsAnimationStyle.custom:
        _animation = InAppNotifications.instance.customAnimation!;
        break;
      case InAppNotificationsAnimationStyle.scale:
        _animation = ScaleAnimation();
        break;
      case InAppNotificationsAnimationStyle.opacity:
        _animation = OpacityAnimation();
        break;
      default:
        _animation = OffsetAnimation();
        break;
    }
    return _animation;
  }
}
