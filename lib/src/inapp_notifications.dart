import 'dart:async';

import 'package:flutter/material.dart';

import 'inapp_notifications_container.dart';
import 'inapp_notifications_overlay.dart';
import 'inapp_notifications_overlay_entry.dart';

enum InAppNotificationsStatus {
  show,
  dismiss,
}

typedef InAppNotificationsStatusCallback = void Function(
    InAppNotificationsStatus status);

class InAppNotifications {
  static final InAppNotifications _instance = InAppNotifications._internal();

  static InAppNotifications get instance => _instance;

  InAppNotifications._internal() {
    titleFontSize = 14.0;
    descriptionFontSize = 14.0;
    textColor = Colors.black;
    backgroundColor = Colors.white;
    shadow = true;
  }

  final List<InAppNotificationsStatusCallback> _statusCallbacks =
      <InAppNotificationsStatusCallback>[];

  InAppNotificationsOverlayEntry? overlayEntry;
  GlobalKey<InAppNotificationsContainerState>? _key;
  Widget? _container;
  Timer? _timer;

  Widget? get container => _container;

  GlobalKey<InAppNotificationsContainerState>? get key => _key;

  /// titleFontSize, default 14.0.
  late double titleFontSize;

  /// descriptionFontSize, default 14.0.
  late double descriptionFontSize;

  // backgroundColor, default Colors.white
  late Color backgroundColor;

  // textColor, default Colors.black
  late Color textColor;

  // shadow, default true
  late bool shadow;

  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, InAppNotificationsOverlay(child: child));
      } else {
        return InAppNotificationsOverlay(child: child);
      }
    };
  }

  /// show loading with [status] [indicator] [maskType]
  static Future<void> show(
      {String? title,
      String? description,
      Widget? leading,
      Widget? ending,
      VoidCallback? onTap,
      Duration? duration}) {
    Widget? _leading = leading != null
        ? Container(
            height: 50,
            child: leading,
          )
        : null;

    Widget? _ending = ending != null
        ? Container(
            height: 50,
            child: ending,
          )
        : null;

    return _instance._show(
        title: title,
        description: description,
        leading: _leading,
        ending: _ending,
        onTap: onTap,
        duration: duration ?? Duration(seconds: 5));
  }

  /// add loading status callback
  static void addStatusCallback(InAppNotificationsStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// remove single loading status callback
  static void removeCallback(InAppNotificationsStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// remove all loading status callback
  static void removeAllCallbacks() {
    _instance._statusCallbacks.clear();
  }

  Future<void> _show({
    Widget? leading,
    Widget? ending,
    String? title,
    String? description,
    VoidCallback? onTap,
    Duration? duration,
  }) async {
    assert(
      overlayEntry != null,
      'You should call InAppNotifications.init() in your MaterialApp',
    );

    bool animation = leading == null;
    if (_key != null) await dismiss(animation: false);

    Completer<void> completer = Completer<void>();
    _key = GlobalKey<InAppNotificationsContainerState>();
    _container = InAppNotificationsContainer(
      key: _key,
      title: title,
      description: description,
      leading: leading,
      ending: ending,
      onTap: onTap,
      animation: animation,
      completer: completer,
    );

    completer.future.whenComplete(() {
      _callback(InAppNotificationsStatus.show);

      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () async {
          print("called dismiss");
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  static Future<void> dismiss({
    bool animation = true,
  }) {
    // cancel timer
    _instance._cancelTimer();
    return _instance._dismiss(animation);
  }

  Future<void> _dismiss(bool animation) async {
    if (key != null && key?.currentState == null) {
      _reset();
      return;
    }

    return key?.currentState?.dismiss(animation).whenComplete(() {
      _reset();
    });
  }

  void _reset() {
    _container = null;
    _key = null;
    _cancelTimer();
    _markNeedsBuild();
    _callback(InAppNotificationsStatus.dismiss);
  }

  void _callback(InAppNotificationsStatus status) {
    for (final InAppNotificationsStatusCallback callback in _statusCallbacks) {
      callback(status);
    }
  }

  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
