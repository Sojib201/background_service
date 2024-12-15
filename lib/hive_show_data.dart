import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class hiveShowData extends StatefulWidget {
  const hiveShowData({super.key});

  @override
  State<hiveShowData> createState() => _HiveShowDataState();
}

class _HiveShowDataState extends State<hiveShowData> {
  final dataBox = Hive.box('myBox');
  List<dynamic> data = [];
  Future<void> getData() async {
    data = dataBox.values.toList();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Data'),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 2,
                  ),
                  color: Colors.grey,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Center(
                      child: Text(
                        data[index].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
