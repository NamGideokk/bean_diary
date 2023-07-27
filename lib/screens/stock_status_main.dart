import 'dart:convert';

import 'package:bean_diary/controller/stock_controller.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/roasting_type_widget.dart';
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
  final _stockCtrl = Get.put(StockController());
  List _history = [];

  @override
  void initState() {
    super.initState();
    print("⭕️ 재 고 현 황 INIT");
  }

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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  _stockCtrl.greenBeanStockList[index]["name"],
                                  style: TextStyle(
                                    fontSize: height / 52,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${Utility().parseToDoubleWeight(_stockCtrl.greenBeanStockList[index]["weight"])}kg",
                                style: TextStyle(
                                  fontSize: height / 52,
                                ),
                              ),
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
                              RoastingTypeWidget(type: _stockCtrl.roastingBeanStockList[index]["type"].toString()),
                            ],
                          ),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
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
