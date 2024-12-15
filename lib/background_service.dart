import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'hive_show_data.dart';

class backgroundService extends StatefulWidget {
  const backgroundService({super.key});

  @override
  State<backgroundService> createState() => _backgroundServiceState();
}

class _backgroundServiceState extends State<backgroundService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().startService();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Start service command sent'),
                  ),
                );
                print("Start service command sent");
              },
              child: Text("Start service"),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("stopService");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stop service command sent'),
                  ),
                );
                print("Stop service command sent");
              },
              child: Text("Stop service"),
            ),
            SizedBox(
              height: 10,
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
