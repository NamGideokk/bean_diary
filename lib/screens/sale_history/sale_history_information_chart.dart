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
            const SizedBox(height: 15),
            Text(
              "판매처별 판매량 비율",
              textAlign: TextAlign.center,
              textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ColoredBox(
                  color: Colors.orange.withOpacity(0.9),
                  child: SizedBox(
                    height: 9,
                    width: _saleHistoryCtrl.markerWidth * 1.15,
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _saleHistoryCtrl.getMarkerWidth(context.size?.width);
                    });
                    return Text(
                      "${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.totalSalesInShowList))}kg",
                      textAlign: TextAlign.center,
                      textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.5),
                      style: Theme.of(context).textTheme.bodyLarge,
                    );
                  },
                ),
              ],
            ),
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
                        child: TweenAnimationBuilder<Color?>(
                          duration: const Duration(milliseconds: 200),
                          tween: ColorTween(
                            begin: _saleHistoryCtrl.showChartInfo != 0 && (_saleHistoryCtrl.showChartInfo - 1) == i
                                ? Colors.orange
                                : Utility().getDynamicBrownColor(i, _saleHistoryCtrl.chartBySeller.length),
                            end: _saleHistoryCtrl.showChartInfo != 0 && (_saleHistoryCtrl.showChartInfo - 1) == i
                                ? Colors.orange
                                : Utility().getDynamicBrownColor(i, _saleHistoryCtrl.chartBySeller.length),
                          ),
                          builder: (context, color, child) {
                            return CircularProgressIndicator(
                              strokeWidth: 40,
                              color: color,
                              value: _saleHistoryCtrl.chartBySeller[i]["chartValue"],
                            );
                          },
                        ),
                      ),
                    GestureDetector(
                      onTap: () => _saleHistoryCtrl.showChartInfo == 0 ? {} : _saleHistoryCtrl.resetShowChartInfo(),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _saleHistoryCtrl.showChartInfoOpacity,
                        curve: Curves.easeInOut,
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
                                  text: _saleHistoryCtrl.showChartInfo != 0
                                      ? "\n${Utility().numberFormat(Utility().parseToDoubleWeight(_saleHistoryCtrl.chartBySeller[_saleHistoryCtrl.showChartInfo - 1]["sales"]))}kg"
                                      : null,
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
                        : Utility().getDynamicBrownColor(index, _saleHistoryCtrl.chartBySeller.length),
                  ),
                ),
                label: RichText(
                  textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 2.0),
                  text: TextSpan(
                    text: _saleHistoryCtrl.chartBySeller[index]["seller"],
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: "  ${(_saleHistoryCtrl.chartBySeller[index]["ratio"] * 100).toStringAsFixed(2)}%",
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
