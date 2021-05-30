import 'package:flutter/material.dart';

import 'inapp_notification_animation.dart';

class OffsetAnimation extends InAppNotificationAnimation {
  OffsetAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    Offset _begin = alignment == AlignmentDirectional.topCenter
        ? Offset(0, -1)
        : alignment == AlignmentDirectional.bottomCenter
            ? Offset(0, 1)
            : Offset(0, 0);

    Animation<Offset> _animation = Tween(
      begin: _begin,
      end: Offset(0, 0),
    ).animate(controller);
    return SlideTransition(
      position: _animation,
      child: child,
    );
  }
}
