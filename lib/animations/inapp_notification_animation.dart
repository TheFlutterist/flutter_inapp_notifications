import 'package:flutter/material.dart';

abstract class InAppNotificationAnimation {
  InAppNotificationAnimation();

  Widget call(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return buildWidget(
      child,
      controller,
      alignment,
    );
  }

  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  );
}
