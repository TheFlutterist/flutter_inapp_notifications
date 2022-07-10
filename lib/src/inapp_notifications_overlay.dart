import 'package:flutter/material.dart';

import 'inapp_notifications.dart';
import 'inapp_notifications_overlay_entry.dart';

class InAppNotificationsOverlay extends StatefulWidget {
  final Widget? child;

  const InAppNotificationsOverlay({Key? key, required this.child})
      : assert(child != null),
        super(key: key);

  @override
  InAppNotificationsOverlayState createState() =>
      InAppNotificationsOverlayState();
}

class InAppNotificationsOverlayState extends State<InAppNotificationsOverlay> {
  late InAppNotificationsOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = InAppNotificationsOverlayEntry(
      builder: (BuildContext context) =>
          InAppNotifications.instance.container ?? Container(),
    );

    InAppNotifications.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          InAppNotificationsOverlayEntry(
            builder: (BuildContext context) {
              if (widget.child != null) {
                return widget.child!;
              } else {
                return Container();
              }
            },
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}
