import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class InAppNotificationsOverlayEntry extends OverlayEntry {
  InAppNotificationsOverlayEntry({
    required builder,
  }) : super(builder: builder);

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });
    } else {
      super.markNeedsBuild();
    }
  }
}
