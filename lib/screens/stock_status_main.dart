import 'dart:convert';

import 'package:bean_diary/controller/stock_controller.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/roasting_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockStatusMain extends StatefulWidget {
  const StockStatusMain({Key? key}) : super(key: key);

  @override
  State<StockStatusMain> createState() => _StockStatusMainState();
}

class _StockStatusMainState extends State<StockStatusMain> {
  final _stockCtrl = Get.put(StockController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<StockController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
                if (_stockCtrl.greenBeanStockList.isEmpty)
                  const EmptyWidget(content: "생두 재고가 없습니다.")
                else
                  Column(
                    children: [
                      ListView.separated(
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
                                    fontSize: height / 54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${Utility().parseToDoubleWeight(_stockCtrl.greenBeanStockList[index]["weight"])}kg",
                                style: TextStyle(
                                  fontSize: height / 54,
                                ),
                              ),
                            ],
                          ),
                          children: [
                            jsonDecode(_stockCtrl.greenBeanStockList[index]["history"]).length > 0
                                ? ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    itemCount: jsonDecode(_stockCtrl.greenBeanStockList[index]["history"]).length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      final history = Utility().sortingDate(jsonDecode(_stockCtrl.greenBeanStockList[index]["history"]));
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width / 4,
                                            child: Text(
                                              Utility().dateFormattingYYMMDD(history[i]["date"]),
                                              style: TextStyle(
                                                fontSize: height / 56,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                              child: Text(
                                                history[i]["company"],
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: height / 56,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "${Utility().parseToDoubleWeight(int.parse(history[i]["weight"]))}kg",
                                            style: TextStyle(
                                              fontSize: height / 56,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const _GuideText(text: "입고"),
                    ],
                  ),
                const SizedBox(height: 30),
                const HeaderTitle(title: "원두 재고", subTitle: "roasting bean stock"),
                _stockCtrl.roastingBeanStockList.isEmpty
                    ? const EmptyWidget(content: "원두 재고가 없습니다.")
                    : Column(
                        children: [
                          ListView.separated(
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
                                        fontSize: height / 54,
                                        height: 1.2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${Utility().parseToDoubleWeight(_stockCtrl.roastingBeanStockList[index]["roasting_weight"])}kg",
                                    style: TextStyle(
                                      fontSize: height / 54,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                jsonDecode(_stockCtrl.roastingBeanStockList[index]["history"]).length > 0
                                    ? ListView.builder(
                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        itemCount: jsonDecode(_stockCtrl.roastingBeanStockList[index]["history"]).length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) {
                                          final history = Utility().sortingDate(jsonDecode(_stockCtrl.roastingBeanStockList[index]["history"]));
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: width / 4,
                                                child: Text(
                                                  Utility().dateFormattingYYMMDD(history[i]["date"]),
                                                  style: TextStyle(
                                                    fontSize: height / 56,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${Utility().parseToDoubleWeight(int.parse(history[i]["roasting_weight"]))}kg",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    fontSize: height / 56,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const _GuideText(text: "로스팅"),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideText extends StatelessWidget {
  final String text;
  const _GuideText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Text(
      "항목을 선택하면 $text 내역을 확인할 수 있습니다.",
      style: TextStyle(
        fontSize: height / 70,
        color: Colors.black54,
      ),
    );
  }
}
