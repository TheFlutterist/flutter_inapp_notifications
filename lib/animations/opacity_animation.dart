import 'package:flutter/widgets.dart';

import 'inapp_notification_animation.dart';

/// Opacity [InAppNotificationAnimation] makes the In-App notification show up
/// fading in and hide fading out.
class OpacityAnimation extends InAppNotificationAnimation {
  OpacityAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: child,
    );
  }
}
