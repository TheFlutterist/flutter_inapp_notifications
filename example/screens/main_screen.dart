import 'package:flutter/material.dart';
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

_resetStyle() {
  InAppNotifications.instance
    ..titleFontSize = 14.0
    ..descriptionFontSize = 14.0
    ..textColor = Colors.black
    ..backgroundColor = Colors.white
    ..shadow = true
    ..animationStyle = InAppNotificationsAnimationStyle.scale;
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter In-App Notifications'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                _resetStyle();

                InAppNotifications.show(
                    title: 'Welcome to InAppNotifications',
                    description:
                        'This is a very simple notification without any leading or ending widgets.',
                    onTap: () {
                      print('Tapped on: Simple Notification');
                    },
                    persistent: true);
              },
              child: Text("Show Simple Notification"),
            ),
            TextButton(
              onPressed: () {
                _resetStyle();

                InAppNotifications.show(
                    title: 'Welcome to InAppNotifications',
                    leading: Icon(
                      Icons.fact_check,
                      size: 50,
                    ),
                    description:
                        'This is a very simple notification with leading widget.',
                    onTap: () {
                      print('Tapped on: Notification with Leading widget');
                    });
              },
              child: Text("Show Notification with Leading widget"),
            ),
            TextButton(
              onPressed: () {
                _resetStyle();

                InAppNotifications.show(
                  title: 'Welcome to InAppNotifications',
                  leading: Icon(
                    Icons.fact_check,
                    size: 50,
                  ),
                  ending: Icon(Icons.arrow_right_alt),
                  description:
                      'This is a very simple notification with leading and ending widget.',
                  onTap: () {
                    print(
                        'Tapped on: Notification with Leading and Ending widget');
                  },
                );
              },
              child: Text("Show Notification with Leading and Ending widget"),
            ),
            TextButton(
              onPressed: () {
                InAppNotifications.instance
                  ..backgroundColor = Colors.orange
                  ..textColor = Colors.purple;

                InAppNotifications.show(
                  title: 'Welcome to InAppNotifications',
                  leading: Icon(
                    Icons.fact_check,
                    color: Colors.green,
                    size: 50,
                  ),
                  ending: Icon(
                    Icons.arrow_right_alt,
                    color: Colors.red,
                  ),
                  description:
                      'This is a very simple notification with leading widget.',
                  onTap: () {
                    print('Tapped on: Customized Notification');

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                );
              },
              child: Text("Show Customized Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
