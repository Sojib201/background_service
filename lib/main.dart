import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'background_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel(
        "coding is life foreground", "coding is life foreground service",
        description: "This is channel des....", importance: Importance.high);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initservice();
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

Future<void> initservice() async {
  var service = FlutterBackgroundService();

  if (Platform.isIOS) {
    await flutterLocalPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  // Properly configure the notification channel
  const AndroidNotificationChannel notificationChannel =
      AndroidNotificationChannel(
    "coding_is_life_foreground", // Use consistent channel ID
    "Coding is Life Foreground Service",
    description: "This is the foreground service channel",
    importance: Importance.high,
  );

  await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  // Configure the background service
  await service.configure(
    iosConfiguration: IosConfiguration(
      onBackground: iosBackground,
      onForeground: onStart,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: notificationChannel.id, // Use the channel ID here
      initialNotificationTitle: "Coding is Life",
      initialNotificationContent: "Awesome Content",
      foregroundServiceNotificationId: 90,
    ),
  );

  service.startService();
}

@pragma("vm:enry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await Hive.initFlutter();
  var box = await Hive.openBox('myBox');

  service.on("setAsForeground").listen((event) {
    print("foreground ===============");
  });

  service.on("setAsBackground").listen((event) {
    print("background ===============");
  });

  service.on("stopService").listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 60), (timer) async {
    print("Background service ${DateTime.now()}");
    await box.add(DateTime.now().toString()); // Use the opened box here
    print('Successfully added to Hive');
    //print("jsdf:${box.values}");
    // flutterLocalPlugin.show(
    //   90,
    //   "Cool Service",
    //   "Awesome ${DateTime.now()}",
    //   const NotificationDetails(
    //     android: AndroidNotificationDetails(
    //       "coding_is_life_foreground", // Must match the notification channel ID
    //       "Coding is Life Service",
    //       channelDescription: "Foreground service notifications",
    //       ongoing: true,
    //       importance: Importance.high,
    //       priority: Priority.high,
    //       icon:
    //           'assets/home.png', // Ensure this icon exists in your Android res/drawable directory
    //     ),
    //   ),
    // );
  });
}

// Future<void> saveDateTimeToHive() async {
//   final _todoBox = Hive.box('myBox');
//
//   _todoBox.add(DateTime.now().toString());
//   print(_todoBox);
//   print('successfully added');
// }

//iosbackground
@pragma("vm:enry-point")
Future<bool> iosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: backgroundService(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             //layout
//             SizedBox(
//               height: 200,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   FlutterBackgroundService().invoke("stopService");
//                 },
//                 child: Text("stop service")),
//             ElevatedButton(
//                 onPressed: () {
//                   FlutterBackgroundService().startService();
//                 },
//                 child: Text("start service")),
//           ],
//         ),
//       ),
//     );
//   }
// }
