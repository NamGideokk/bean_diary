import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/screens/sale_history/sale_history_information_chart.dart';
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
              visible: sortYr != "" || sortRt != "" || sortSel != "",
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
            SaleHistoryInformationChart(),
            LabelContentRow(label: "판매기간", content: _saleHistoryCtrl.salesPeriod),
            LabelContentRow(label: "판매건수", content: "${Utility().numberFormat(_saleHistoryCtrl.showList.length.toString(), isWeight: false)}건"),
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
            LabelContentRow(
              label: "월별판매량",
              content: "${_saleHistoryCtrl.monthlySales.map((d) => "${d["date"]} - ${Utility().numberFormat(Utility().parseToDoubleWeight(d["sales"]))}kg").join('\n')}",
            ),
          ],
        ),
      ),
    );
  }
}
