import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../flutter_inapp_notifications.dart';
import '../theme.dart';

class InAppNotificationsContainer extends StatefulWidget {
  final Widget? leading;
  final Widget? ending;
  final String? title;
  final String? description;
  final VoidCallback? onTap;
  final Completer<void>? completer;
  final bool animation;

  const InAppNotificationsContainer({
    Key? key,
    this.leading,
    this.ending,
    this.title,
    this.description,
    this.onTap,
    this.completer,
    this.animation = true,
  }) : super(key: key);

  @override
  InAppNotificationsContainerState createState() =>
      InAppNotificationsContainerState();
}

class InAppNotificationsContainerState
    extends State<InAppNotificationsContainer>
    with SingleTickerProviderStateMixin {
  String? _title;
  String? _description;
  late AnimationController _animationController;

  bool get isPersistentCallbacks =>
      SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _title = widget.title;
    _description = widget.description;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) {
        bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });

    show(widget.animation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show(bool animation) {
    if (isPersistentCallbacks) {
      Completer<TickerFuture> completer = Completer<TickerFuture>();
      SchedulerBinding.instance.addPostFrameCallback((_) => completer
          .complete(_animationController.forward(from: animation ? 0 : 1)));
      return completer.future;
    } else {
      return _animationController.forward(from: animation ? 0 : 1);
    }
  }

  Future<void> dismiss(bool animation) {
    if (isPersistentCallbacks) {
      Completer<TickerFuture> completer = Completer<TickerFuture>();
      SchedulerBinding.instance.addPostFrameCallback((_) => completer
          .complete(_animationController.reverse(from: animation ? 1 : 0)));
      return completer.future;
    } else {
      return _animationController.reverse(from: animation ? 1 : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40.0),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _animationController.value,
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animationController,
            builder: (BuildContext context, Widget? child) {
              return InAppNotificationsTheme.showAnimation.buildWidget(
                _Notification(
                  title: _title,
                  description: _description,
                  leading: widget.leading,
                  ending: widget.ending,
                  onTap: widget.onTap,
                ),
                _animationController,
                AlignmentDirectional.topCenter,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Notification extends StatelessWidget {
  final Widget? leading;
  final Widget? ending;
  final String? title;
  final String? description;
  final VoidCallback? onTap;

  const _Notification(
      {required this.leading,
      required this.ending,
      required this.title,
      required this.description,
      required this.onTap});

  Widget _buildNotification() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: InAppNotificationsTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: InAppNotificationsTheme.shadow
              ? const [
                  BoxShadow(blurRadius: 10.0, color: Colors.black26),
                ]
              : null),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (leading != null)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: leading,
            ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                        fontSize: InAppNotificationsTheme.titleFontSize,
                        color: InAppNotificationsTheme.textColor,
                        fontWeight: FontWeight.w600),
                  ),
                if (description != null)
                  Flexible(
                    child: Text(
                      description!,
                      style: TextStyle(
                        fontSize: InAppNotificationsTheme.descriptionFontSize,
                        color: InAppNotificationsTheme.textColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          if (ending != null)
            Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: ending,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return onTap == null
        ? _buildNotification()
        : GestureDetector(
            onTap: () {
              InAppNotifications.dismiss();

              onTap!();
            },
            child: _buildNotification(),
          );
  }
}
