import 'package:flutter/material.dart';

/// Abstract animation wrapper used to build new Animations set to show In-App notifications
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
