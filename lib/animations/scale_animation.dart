import 'package:flutter/widgets.dart';

import 'inapp_notification_animation.dart';

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
