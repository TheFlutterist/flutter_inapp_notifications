# Flutter In-App Notifications

A simple Flutter package to generate instant in-app notifications.

![license](https://img.shields.io/github/license/pintalubaf/flutter_inapp_notifications?style=flat)

![flutter_inapp_notifications_demo](https://user-images.githubusercontent.com/36412259/120113731-32e0bb80-c152-11eb-8b73-26cdc1e3163d.gif)

## Installing

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_inapp_notifications: ^0.0.4
```

## Import

```dart
import 'package:flutter_inapp_notifications/flutter_inapp_notifications.dart';
```

## How to use

First, initialize `InAppNotifications` in your `MaterialApp`/`CupertinoApp`:

```dart
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter InAppNotifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter InAppNotifications'),
      builder: InAppNotifications.init(),
    );
  }
}
```

Then:

```dart
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
        'This is a very simple notification with leading and ending widget.',
    onTap: () {
      // Do whatever you need!
    });
```

<em>You can play around with leading and ending widgets, as well as not sending any of them.</em>

<strong>Add loading status callback</strong>

```dart
InAppNotifications.addStatusCallback((status) {
  print('InAppNotifications Status $status');
});
```

<strong>Remove loading status callback(s)</strong>

```dart
InAppNotifications.removeCallback(statusCallback);

InAppNotifications.removeAllCallbacks();
```

## Customize

Customization is pretty straighforward, I'm actually working on more attributes to customize. Feel free to request new customizations.

Customize it anywhere:

```dart
InAppNotifications.instance
  ..titleFontSize = 14.0
  ..descriptionFontSize = 14.0
  ..textColor = Colors.black
  ..backgroundColor = Colors.white
  ..shadow = true
  ..animationStyle = InAppNotificationsAnimationStyle.scale;

// Custom animation
InAppNotifications.instance
  ..titleFontSize = 14.0
  ..descriptionFontSize = 14.0
  ..textColor = Colors.black
  ..backgroundColor = Colors.white
  ..shadow = true
  ..customAnimation = MyCustomAnimation()
  ..animationStyle = InAppNotificationsAnimationStyle.custom;
```

## Changelog

[CHANGELOG](./CHANGELOG.md)

## License

[MIT License](./LICENSE)

## This was possible thanks to

[easy_loading](https://github.com/kokohuang/flutter_easyloading) ❤️
<em>This package was an inspiration, as well as a great reference to create this kind of packages.</em>
