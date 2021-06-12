import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/animations/inapp_notification_animation.dart';
import 'package:flutter_inapp_notifications/animations/offset_animation.dart';
import 'package:flutter_inapp_notifications/animations/opacity_animation.dart';
import 'package:flutter_inapp_notifications/animations/scale_animation.dart';

import 'inapp_notifications_container.dart';
import 'inapp_notifications_overlay.dart';
import 'inapp_notifications_overlay_entry.dart';

/// Status for In-App Notification callbacks.
///
/// [show] when the status is currently showing.
/// [dismiss] when the status is dismissed.
enum InAppNotificationsStatus {
  show,
  dismiss,
}

/// Animation style used to show/hide In-App notification.
///
/// [opacity] uses [OpacityAnimation]
/// [offset] uses [OffsetAnimation]
/// [scale] uses [ScaleAnimation]
/// [custom] uses a custom [InAppNotificationAnimation] set to customAnimation value
enum InAppNotificationsAnimationStyle {
  opacity,
  offset,
  scale,
  custom,
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
    animationStyle = InAppNotificationsAnimationStyle.offset;
  }

  final List<InAppNotificationsStatusCallback> _statusCallbacks =
      <InAppNotificationsStatusCallback>[];

  InAppNotificationsOverlayEntry? overlayEntry;
  GlobalKey<InAppNotificationsContainerState>? _key;
  Widget? _container;
  Timer? _timer;

  Widget? get container => _container;

  GlobalKey<InAppNotificationsContainerState>? get key => _key;

  /// Title font size, default: 14.0.
  late double titleFontSize;

  /// Description font size, default: 14.0.
  late double descriptionFontSize;

  /// Background color, default: [Colors.white]
  late Color backgroundColor;

  /// Text color, default: [Colors.black]
  late Color textColor;

  /// Set if notification should show shadow, default: true
  late bool shadow;

  /// Animation style, default: [InAppNotificationsAnimationStyle.offset].
  late InAppNotificationsAnimationStyle animationStyle;

  /// Custom animation, default: null.
  ///
  /// Set a custom animation only when [animationStyle] is [InAppNotificationsAnimationStyle.custom]
  late InAppNotificationAnimation? customAnimation;

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

  /// Shows the In-App notification.
  ///
  /// [title] Title of the notification
  /// [description] Description of the notification
  /// [leading] Widget show leading the content
  /// [ending] Widget show ending the content
  /// [onTap] Function to be called when gesture onTap is detected
  /// [duration] Duration which the notification will be shown
  /// [persistent] Persistent mode will keep the notification visible until dismissed
  static Future<void> show(
      {String? title,
      String? description,
      Widget? leading,
      Widget? ending,
      VoidCallback? onTap,
      Duration? duration,
      bool persistent = false}) {
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
        persistent: persistent,
        duration: duration ?? Duration(seconds: 5));
  }

  /// Add status callback
  static void addStatusCallback(InAppNotificationsStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// Remove single status callback
  static void removeCallback(InAppNotificationsStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// Remove all status callback
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
    bool persistent = false,
  }) async {
    assert(
      overlayEntry != null,
      'you should call InAppNotifications.init() in your MaterialApp',
    );

    if (animationStyle == InAppNotificationsAnimationStyle.custom) {
      assert(
        customAnimation != null,
        'while animationStyle is custom, customAnimation should not be null',
      );
    }

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

      if (duration != null && !persistent) {
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
