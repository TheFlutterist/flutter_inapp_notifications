import 'package:flutter/widgets.dart';

import 'inapp_notification_animation.dart';

/// Scale [InAppNotificationAnimation] makes the In-App notification show up
/// scaling from 0 to 1 (original size), hides scaling from 1 to 0.
class ScaleAnimation extends InAppNotificationAnimation {
  ScaleAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: ScaleTransition(
        scale: controller,
        child: child,
      ),
    );
  }
}
