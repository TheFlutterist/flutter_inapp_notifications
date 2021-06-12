import 'package:flutter/widgets.dart';

import 'inapp_notification_animation.dart';

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
