import 'dart:convert';

import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockStatusMain extends StatefulWidget {
  const StockStatusMain({Key? key}) : super(key: key);

  @override
  State<StockStatusMain> createState() => _StockStatusMainState();
}

class _StockStatusMainState extends State<StockStatusMain> {
  late final SharedPreferences _pref;
  late final Future _getHistoryData = getSharedPreferences();
  List _history = [];

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  Future getSharedPreferences() async {
    _pref = await SharedPreferences.getInstance();
    var jsonList = _pref.getStringList("warehousing");
    if (jsonList != null) {
      for (var item in jsonList) {
        var decodingData = jsonDecode(item);
        _history.add(decodingData);
      }
      print("재고 현황 >\n$_history");
      print("💎 재고 현황 길이 >\n${_history.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("재고 현황"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _getHistoryData,
        builder: (context, snapshot) => SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(title: "생두 재고", subTitle: "green bean stock"),
              // ExpansionTile(
              //   title: Text("케냐 AA 2,390kg"),
              //   expandedAlignment: Alignment.topLeft,
              //   children: [
              //   ],
              // ),
              // Divider(height: 0),
              // ExpansionTile(
              //   title: Text("케냐 AA 2,390kg"),
              //   expandedAlignment: Alignment.topLeft,
              // ),
              ListView.separated(
                itemBuilder: (context, index) => ExpansionTile(
                  title: Text("${_history[index]["nation"]}\t${_history[index]["beanName"]}\t${_history[index]["weight"]}kg"),
                  expandedAlignment: Alignment.topLeft,
                  children: [],
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: _history.length,
                shrinkWrap: true,
              ),
              const HeaderTitle(title: "원두 재고", subTitle: "coffee bean stock"),
              const EmptyWidget(content: "원두 재고가 없습니다."),
            ],
          ),
        ),
      ),
    );
  }
}
