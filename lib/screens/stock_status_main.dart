import 'dart:convert';

import 'package:bean_diary/controllers/stock_controller.dart';
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
  void dispose() {
    super.dispose();
    Get.delete<StockController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("재고 현황"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderTitle(title: "생두 재고", subTitle: "Green coffee beans inventory"),
                _stockCtrl.greenBeanStockList.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const EmptyWidget(content: "생두 재고가 없습니다."),
                      )
                    : Column(
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _stockCtrl.greenBeanStockList.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) => _GreenBeanTile(stockList: _stockCtrl.greenBeanStockList, index: index),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "항목을 누르면 상세 내역을 확인할 수 있습니다.",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                const SizedBox(height: 50),
                const HeaderTitle(title: "원두 재고", subTitle: "Roasted coffee beans inventory"),
                _stockCtrl.roastingBeanStockList.isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const EmptyWidget(content: "원두 재고가 없습니다."),
                      )
                    : Column(
                        children: [
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _stockCtrl.roastingBeanStockList.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) => _RoastingBeanTile(stockList: _stockCtrl.roastingBeanStockList, index: index),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "항목을 누르면 상세 내역을 확인할 수 있습니다.",
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black54),
                          ),
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

class _GreenBeanTile extends StatelessWidget {
  final List stockList;
  final int index;
  const _GreenBeanTile({
    Key? key,
    required this.stockList,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == stockList.length - 1 ? 8 : 0),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == stockList.length - 1 ? 8 : 0),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              stockList[index]["name"],
              style: TextStyle(
                fontSize: height / 54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "${Utility().numberFormat(Utility().parseToDoubleWeight(stockList[index]["weight"]))}kg",
            style: TextStyle(
              fontSize: height / 54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      children: [
        jsonDecode(stockList[index]["history"]).length > 0
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                shrinkWrap: true,
                itemCount: jsonDecode(stockList[index]["history"]).length,
                itemBuilder: (context, i) {
                  final history = Utility().sortingDate(jsonDecode(stockList[index]["history"]));
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
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
                          "${Utility().numberFormat(Utility().parseToDoubleWeight(int.parse(history[i]["weight"])))}kg",
                          style: TextStyle(
                            fontSize: height / 56,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const SizedBox(),
        //ngd 총 누적량 추가중
        // Divider(
        //   indent: 10,
        //   endIndent: 10,
        //   color: Colors.brown[200],
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: RichText(
        //       text: TextSpan(
        //         text: "총\t\t",
        //         style: TextStyle(
        //           fontSize: height / 70,
        //           color: Colors.black54,
        //         ),
        //         children: [
        //           TextSpan(
        //             text: "1,200.0kg",
        //             style: TextStyle(
        //               fontSize: height / 54,
        //               color: Colors.black87,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class _RoastingBeanTile extends StatelessWidget {
  final List stockList;
  final int index;
  const _RoastingBeanTile({Key? key, required this.stockList, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == stockList.length - 1 ? 8 : 0),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == stockList.length - 1 ? 8 : 0),
        ),
      ),
      title: Row(
        children: [
          RoastingTypeWidget(type: stockList[index]["type"].toString()),
        ],
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              "${stockList[index]["name"]}",
              style: TextStyle(
                fontSize: height / 54,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            "${Utility().numberFormat(Utility().parseToDoubleWeight(stockList[index]["roasting_weight"]))}kg",
            style: TextStyle(
              fontSize: height / 54,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
      children: [
        jsonDecode(stockList[index]["history"]).length > 0
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                shrinkWrap: true,
                itemCount: jsonDecode(stockList[index]["history"]).length,
                itemBuilder: (context, i) {
                  final history = Utility().sortingDate(jsonDecode(stockList[index]["history"]));
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
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
                            "${Utility().numberFormat(Utility().parseToDoubleWeight(int.parse(history[i]["roasting_weight"])))}kg",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: height / 56,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
