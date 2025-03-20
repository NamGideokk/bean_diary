import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/screens/sale_history/sale_history_information_chart.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:bean_diary/widgets/label_content_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleHistoryInformationMain extends StatefulWidget {
  const SaleHistoryInformationMain({super.key});

  @override
  State<SaleHistoryInformationMain> createState() => _SaleHistoryInformationMainState();
}

class _SaleHistoryInformationMainState extends State<SaleHistoryInformationMain> {
  final _saleHistoryCtrl = Get.find<SaleHistoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _saleHistoryCtrl.calcSalesStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    String sortYr = _saleHistoryCtrl.sortByYear;
    String sortRt = _saleHistoryCtrl.sortByRoastingType;
    String sortPrd = _saleHistoryCtrl.sortByProduct;
    String sortSel = _saleHistoryCtrl.sortBySeller;

    return Obx(
      () => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "판매 내역 통계",
                      style: TextStyle(
                        fontSize: height / 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.clear,
                      size: height / 40,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: sortYr != "" || sortRt != "" || sortPrd != "" || sortSel != "",
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 5,
                  children: [
                    Visibility(
                      visible: sortYr != "",
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.brown[50],
                        shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                        label: Text(
                          sortYr,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: sortRt != "",
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.brown[50],
                        shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                        label: Text(
                          sortRt,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: sortPrd != "",
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.brown[50],
                        shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                        label: Text(
                          sortPrd,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: sortSel != "",
                      child: Chip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: Colors.brown[50],
                        shape: StadiumBorder(side: BorderSide(color: Colors.brown[50]!)),
                        label: Text(
                          sortSel,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                SaleHistoryInformationChart(),
                AnimatedOpacity(
                  opacity: _saleHistoryCtrl.isGettingChart ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: ColoredBox(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        Text(
                          "차트 계산중...\n🤖 삡삡삡... 삑!",
                          textAlign: TextAlign.center,
                          textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                          child: Center(
                            child: SizedBox(
                              height: height / 5,
                              width: height / 5,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.brown[100],
                                color: Colors.brown[900],
                                strokeCap: StrokeCap.round,
                                strokeWidth: 40,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _saleHistoryCtrl.chartSwitch ? "상품별 판매량 보기" : "판매처별 판매량 보기",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.brown),
                  ),
                  Transform.scale(
                    scale: 0.65,
                    child: Switch.adaptive(
                      inactiveTrackColor: Colors.brown[400],
                      inactiveThumbColor: Colors.brown[50],
                      value: _saleHistoryCtrl.chartSwitch,
                      onChanged: (value) => _saleHistoryCtrl.onChangedChartSwitch(value),
                    ),
                  ),
                ],
              ),
            ),
            LabelContentRow(
              label: "판매기간",
              content: _saleHistoryCtrl.salesPeriod,
            ),
            LabelContentRow(
              label: "판매건수",
              content: "${Utility().numberFormat(_saleHistoryCtrl.showList.length.toString(), isWeight: false)}건",
            ),
            LabelContentRow.list(
              label: "판매처수",
              content: _saleHistoryCtrl.showSellerList.join("\n"),
              length: _saleHistoryCtrl.chartBySeller.length,
            ),
            LabelContentRow(
              label: "총판매량",
              content: "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.totalSalesInShowList))}kg",
            ),
            LabelContentRow(
              label: "최소판매량",
              content: "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.minSales))}kg",
            ),
            LabelContentRow(
              label: "최대판매량",
              content: "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.maxSales))}kg",
            ),
            LabelContentRow(
              label: "평균판매량",
              content: "${Utility().numberFormat(Utility().parseToDoubleWeight((_saleHistoryCtrl.totalSalesInShowList / _saleHistoryCtrl.showList.length).round()))}kg",
            ),
            LabelContentRow.chip(
              label: "월별판매량",
              chips: _saleHistoryCtrl.monthlySales.map((e) => e["date"]).toList(),
              contents: _saleHistoryCtrl.monthlySales.map((e) => "${Utility().numberFormat(Utility().parseToDoubleWeight(e["sales"]))}kg").toList(),
            ),
            LabelContentRow.chip(
              label: "상품별판매량",
              chips: _saleHistoryCtrl.productSales.map((e) => e["product"]).toList(),
              contents: _saleHistoryCtrl.productSales.map((e) => "${Utility().numberFormat(Utility().parseToDoubleWeight(e["sales"]))}kg").toList(),
            ),
          ],
        ),
      ),
    );
  }
}
