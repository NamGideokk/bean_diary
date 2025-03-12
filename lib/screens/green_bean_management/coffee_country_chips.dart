import 'package:bean_diary/controllers/register_green_bean_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoffeeCountryChips extends StatelessWidget {
  const CoffeeCountryChips({super.key});

  @override
  Widget build(BuildContext context) {
    final registerGreenBeanCtrl = Get.find<RegisterGreenBeanController>();
    return Obx(
      () => ExpansionTile(
        dense: true,
        backgroundColor: Colors.white,
        visualDensity: VisualDensity.compact,
        collapsedBackgroundColor: Colors.white,
        collapsedShape: InputBorder.none,
        shape: InputBorder.none,
        tilePadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        title: Text(
          "🌎 국가",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        children: [
          Column(
            children: registerGreenBeanCtrl.coffeeProducingCountries.map(
              (e) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          e["region"]["kor"],
                          textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.4),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.brown[400],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(left: 10),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: e["countries"].map<Widget>((country) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 3),
                                child: ActionChip(
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: Colors.grey[100],
                                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                  shape: const StadiumBorder(
                                    side: BorderSide(
                                      width: 0.5,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  onPressed: () => registerGreenBeanCtrl.onCountrySelected(country[registerGreenBeanCtrl.isKoreanDisplay ? "kor" : "eng"]),
                                  label: Text(country[registerGreenBeanCtrl.isKoreanDisplay ? "kor" : "eng"]),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Divider(height: 0, thickness: 0.5),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  registerGreenBeanCtrl.isKoreanDisplay ? "한글" : "ENG",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Transform.scale(
                  scale: 0.7,
                  child: Switch.adaptive(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeTrackColor: Colors.brown[400],
                    inactiveTrackColor: Colors.grey[200],
                    value: registerGreenBeanCtrl.isKoreanDisplay,
                    onChanged: (value) => registerGreenBeanCtrl.setIsKoreanDisplay(value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
