import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive/hive.dart';

import 'hive_show_data.dart';

class backgroundService extends StatefulWidget {
  const backgroundService({super.key});

  @override
  State<backgroundService> createState() => _backgroundServiceState();
}

class _backgroundServiceState extends State<backgroundService> {
  // final _todoBox = Hive.box('myBox');
  //
  // Future<void> saveDateTimeToHive() async {
  //   _todoBox.add(
  //       DateTime.now().toString()); // Converts DateTime to string for storage
  // }
  // List<dynamic> data = [];
  // final dataBox = Hive.box('myBox');
  // Future<void> getData() async {
  //   data = dataBox.get('timeData');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //layout
            SizedBox(
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("StopService");
              },
              child: Text("Stop service"),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().startService();
              },
              child: Text("Start service"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => hiveShowData(),
                  ),
                );
              },
              child: Text('Show Data'),
            ),
          ],
        ),
      ),
    );
  }
}
