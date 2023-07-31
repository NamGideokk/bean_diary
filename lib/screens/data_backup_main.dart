import 'package:flutter/material.dart';

class DataBackupMain extends StatefulWidget {
  const DataBackupMain({Key? key}) : super(key: key);

  @override
  State<DataBackupMain> createState() => _DataBackupMainState();
}

class _DataBackupMainState extends State<DataBackupMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("데이터 백업"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
