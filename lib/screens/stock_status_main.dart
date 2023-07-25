import 'dart:convert';

import 'package:bean_diary/controller/stock_controller.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StockStatusMain extends StatefulWidget {
  const StockStatusMain({Key? key}) : super(key: key);

  @override
  State<StockStatusMain> createState() => _StockStatusMainState();
}

class _StockStatusMainState extends State<StockStatusMain> {
  late final SharedPreferences _pref;
  // late final Future _getHistoryData = getSharedPreferences();
  final _stockCtrl = Get.put(StockController());
  List _history = [];

  @override
  void initState() {
    super.initState();
    print("⭕️ 재 고 현 황 INIT");
    // getSharedPreferences();
  }

  // Future getSharedPreferences() async {
  //   _pref = await SharedPreferences.getInstance();
  //   var jsonList = _pref.getStringList("warehousing");
  //   if (jsonList != null) {
  //     for (var item in jsonList) {
  //       var decodingData = jsonDecode(item);
  //       _history.add(decodingData);
  //     }
  //     print("재고 현황 >\n$_history");
  //     print("💎 재고 현황 길이 >\n${_history.length}");
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    print("❌ 재 고 현 황 DELETE");
    Get.delete<StockController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("재고 현황"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderTitle(title: "생두 재고", subTitle: "green bean stock"),
                _stockCtrl.greenBeanStockList.isEmpty
                    ? const EmptyWidget(content: "생두 재고가 없습니다.")
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stockCtrl.greenBeanStockList.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  _stockCtrl.greenBeanStockList[index]["name"],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text("${Utility().parseToDoubleWeight(_stockCtrl.greenBeanStockList[index]["weight"])}kg"),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                const HeaderTitle(title: "원두 재고", subTitle: "roasting bean stock"),
                _stockCtrl.roastingBeanStockList.isEmpty
                    ? const EmptyWidget(content: "원두 재고가 없습니다.")
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _stockCtrl.roastingBeanStockList.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => ExpansionTile(
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.brown,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "${_stockCtrl.roastingBeanStockList[index]["type"] == "1" ? "싱글오리진" : "블렌드"}",
                                  style: TextStyle(
                                    color: Colors.brown,
                                    fontSize: height / 65,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "${_stockCtrl.roastingBeanStockList[index]["name"]}",
                                  style: TextStyle(
                                    fontSize: height / 52,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${Utility().parseToDoubleWeight(_stockCtrl.roastingBeanStockList[index]["roasting_weight"])}kg",
                                style: TextStyle(
                                  fontSize: height / 52,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
