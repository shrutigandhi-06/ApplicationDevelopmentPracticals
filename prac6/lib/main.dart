import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationApp(),
    );
  }
}

class NotificationApp extends StatefulWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  _NotificationAppState createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  List<bool> _selections = [true, false];

  late FlutterLocalNotificationsPlugin localNotification;
  void initState() {
    super.initState();
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }

  Future _showNotification() async {
    var androidDetails = const AndroidNotificationDetails(
        "channelId", "Local Notification",
        channelDescription: "Notification Successfully Generated!!");
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    if (_selections[0] == true) {
      await localNotification.show(0, "Woohoo",
          "Notification arrived Successfully", generalNotificationDetails);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff13131B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Click the button to receive a Notification",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
              color: Color(0xffF6265A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20.0,
          ),
          ToggleButtons(
            fillColor: Colors.blueGrey,
            children: const [
              Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
              Icon(
                Icons.notifications_off,
                color: Colors.white,
              ),
            ],
            isSelected: _selections,
            onPressed: (int index) {
              int otherIndex = (index + 1) % 2;
              setState(() {
                _selections[index] = !_selections[index];
                _selections[otherIndex] = !_selections[otherIndex];
              });
            },
            borderWidth: 2.0,
            renderBorder: false,
            borderRadius: BorderRadius.circular(10.0),
            borderColor: Color(0xffF6265A),
            selectedBorderColor: Color(0xffF6265A),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF6265A),
        child: Icon(Icons.notifications),
        onPressed: _showNotification,
      ),
    );
  }
}
