import 'package:bean_diary/controllers/sale_history_controller.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleHistoryInformationChart extends StatefulWidget {
  const SaleHistoryInformationChart({super.key});

  @override
  State<SaleHistoryInformationChart> createState() => _SaleHistoryInformationChartState();
}

class _SaleHistoryInformationChartState extends State<SaleHistoryInformationChart> {
  final _saleHistoryCtrl = Get.find<SaleHistoryController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _saleHistoryCtrl.calcChartBySeller();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _saleHistoryCtrl.resetShowChartInfo();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaler.scale(1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              width: height / 5,
              height: height / 5,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    for (int i = _saleHistoryCtrl.chartBySeller.length - 1; i >= 0; i--)
                      SizedBox(
                        height: height / 5,
                        width: height / 5,
                        child: CircularProgressIndicator(
                          strokeWidth: 40,
                          color: _saleHistoryCtrl.showChartInfo != 0 && (_saleHistoryCtrl.showChartInfo - 1) == i
                              ? Colors.orange
                              : _saleHistoryCtrl.getDynamicBrownColor(i, _saleHistoryCtrl.chartBySeller.length),
                          value: _saleHistoryCtrl.chartBySeller[i]["chartValue"],
                        ),
                      ),
                    GestureDetector(
                      onTap: () => _saleHistoryCtrl.showChartInfo == 0 ? {} : _saleHistoryCtrl.resetShowChartInfo(),
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 400),
                        opacity: _saleHistoryCtrl.showChartInfoOpacity,
                        curve: Curves.easeInCirc,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: RichText(
                            textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                            text: TextSpan(
                              text: _saleHistoryCtrl.showChartInfo != 0 ? _saleHistoryCtrl.chartBySeller[_saleHistoryCtrl.showChartInfo - 1]["seller"] : null,
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text:
                                      _saleHistoryCtrl.showChartInfo != 0 ? "\n${Utility().parseToDoubleWeight(_saleHistoryCtrl.chartBySeller[_saleHistoryCtrl.showChartInfo - 1]["sales"])}kg" : null,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        height: 1,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _saleHistoryCtrl.chartBySeller.length,
              itemBuilder: (context, index) => TextButton.icon(
                style: TextButton.styleFrom(),
                onPressed: () => _saleHistoryCtrl.onTapShowChartInfo(index),
                icon: Container(
                  margin: EdgeInsets.only(right: 1 * textScale),
                  width: (height / 50) * textScale,
                  height: (height / 50) * textScale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _saleHistoryCtrl.showChartInfo != 0 && (_saleHistoryCtrl.showChartInfo - 1) == index
                        ? Colors.orange
                        : _saleHistoryCtrl.getDynamicBrownColor(index, _saleHistoryCtrl.chartBySeller.length),
                  ),
                ),
                label: RichText(
                  textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0),
                  text: TextSpan(
                    text: _saleHistoryCtrl.chartBySeller[index]["seller"],
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "  ${(_saleHistoryCtrl.chartBySeller[index]["ratio"] * 100).toStringAsFixed(1)}%",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
