import 'package:flutter/material.dart';

class WeightInputGuide extends StatelessWidget {
  const WeightInputGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*
            100g 단위로 입력 시,\n소수점 첫째 자리까지 입력해 주세요.
            (300g → 0.3, 100.5kg → 100.5)

            *10g 이하 단위는 지원하지 않습니다.
            *소수점 없이 입력 완료하면 소수점이 자동으로 추가됩니다.
             */
            Text(
              "중량 입력 안내",
              style: TextStyle(
                fontSize: height / 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  "- ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    "100g 단위 입력 시, 소수점 첫째 자리까지 입력해 주세요.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "예시",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    "300g → 0.3 입력\n100.5kg → 100.5 입력",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  "- ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    "소수점 없이 입력할 경우, 자동으로 소수점이 추가됩니다.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "예시",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    "100 입력 → 100.0kg\n95 입력 → 95.0kg",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Text(
                  "- ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    "10g 이하 단위는 지원하지 않습니다.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
