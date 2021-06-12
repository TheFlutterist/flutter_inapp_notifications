import 'package:flutter/material.dart';

import 'animations/inapp_notification_animation.dart';
import 'animations/offset_animation.dart';
import 'animations/opacity_animation.dart';
import 'animations/scale_animation.dart';
import 'src/inapp_notifications.dart';

class InAppNotificationsTheme {
  static Color get textColor => InAppNotifications.instance.textColor;

  static Color get backgroundColor =>
      InAppNotifications.instance.backgroundColor;

  static bool get shadow => InAppNotifications.instance.shadow;

  static double get titleFontSize => InAppNotifications.instance.titleFontSize;

  static double get descriptionFontSize =>
      InAppNotifications.instance.descriptionFontSize;

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
