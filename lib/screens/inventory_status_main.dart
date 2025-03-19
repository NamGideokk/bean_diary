import 'dart:convert';

import 'package:bean_diary/controllers/stock_controller.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/roasting_type_widget.dart';
import 'package:bean_diary/widgets/ui_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InventoryStatusMain extends StatefulWidget {
  const InventoryStatusMain({Key? key}) : super(key: key);

  @override
  State<InventoryStatusMain> createState() => _InventoryStatusMainState();
}

class _InventoryStatusMainState extends State<InventoryStatusMain> {
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
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderTitle(title: "생두 재고", subTitle: "Green coffee beans inventory"),
                _stockCtrl.greenBeanStockList.isEmpty
                    ? DecoratedBox(
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
                const UiSpacing(),
                const HeaderTitle(title: "원두 재고", subTitle: "Roasted coffee beans inventory"),
                _stockCtrl.roastingBeanStockList.isEmpty
                    ? DecoratedBox(
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
    final stockCtrl = Get.find<StockController>();
    final height = MediaQuery.of(context).size.height;

    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
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
        side: BorderSide(color: Colors.brown[100]!, width: 2),
      ),
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
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
          const SizedBox(width: 10),
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
            ? Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    shrinkWrap: true,
                    itemCount: jsonDecode(stockList[index]["history"]).length,
                    separatorBuilder: (context, index) => const Divider(height: 10, thickness: 0.2, color: Colors.black54),
                    itemBuilder: (context, i) {
                      final history = Utility().sortingDate(jsonDecode(stockList[index]["history"]));
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            Utility().dateFormattingYYMMDD(history[i]["date"]),
                            style: TextStyle(
                              fontSize: height / 56,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Expanded(
                                child: Text(
                                  history[i]["company"],
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${Utility().numberFormat(Utility().parseToDoubleWeight(int.parse(history[i]["weight"])))}kg",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: height / 56,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => stockCtrl.setChangeIsConvert(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "누적",
                              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.brown),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Divider(
                                        color: Colors.brown,
                                        thickness: 0.2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    stockCtrl.getHistoryTotal(jsonDecode(stockList[index]["history"])),
                                    textAlign: TextAlign.right,
                                    textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.6),
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
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
    final stockCtrl = Get.find<StockController>();
    final height = MediaQuery.of(context).size.height;

    return ExpansionTile(
      tilePadding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
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
        side: BorderSide(color: Colors.brown[100]!, width: 2),
      ),
      backgroundColor: Colors.white,
      title: Wrap(children: [RoastingTypeWidget(type: stockList[index]["type"].toString())]),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              " ${stockList[index]["name"]}",
              style: TextStyle(
                fontSize: height / 54,
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
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
            ? Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    shrinkWrap: true,
                    itemCount: jsonDecode(stockList[index]["history"]).length,
                    separatorBuilder: (context, index) => const Divider(height: 10, thickness: 0.2, color: Colors.black54),
                    itemBuilder: (context, i) {
                      final history = Utility().sortingDate(jsonDecode(stockList[index]["history"]));
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utility().dateFormattingYYMMDD(history[i]["date"]),
                            style: TextStyle(
                              fontSize: height / 56,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(width: 10),
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
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 20),
                    child: Obx(
                      () => GestureDetector(
                        onTap: () => stockCtrl.setChangeIsConvert(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "누적",
                              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.brown),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      child: Divider(
                                        color: Colors.brown,
                                        thickness: 0.2,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    stockCtrl.getHistoryTotal(jsonDecode(stockList[index]["history"])),
                                    textAlign: TextAlign.right,
                                    textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.6),
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
