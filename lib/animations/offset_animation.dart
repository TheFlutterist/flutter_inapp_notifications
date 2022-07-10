import 'package:flutter/material.dart';

import 'inapp_notification_animation.dart';

/// Offset [InAppNotificationAnimation] makes the In-App notification show up
/// from the outside-top of the screen, and hides going outside-top of the screen again.
class OffsetAnimation extends InAppNotificationAnimation {
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    Offset begin = alignment == AlignmentDirectional.topCenter
        ? const Offset(0, -1)
        : alignment == AlignmentDirectional.bottomCenter
            ? const Offset(0, 1)
            : const Offset(0, 0);

    Animation<Offset> animation = Tween(
      begin: begin,
      end: const Offset(0, 0),
    ).animate(controller);
    return SlideTransition(
      position: animation,
      child: child,
    );
  }
}
