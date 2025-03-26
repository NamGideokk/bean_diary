import 'package:bean_diary/utility/colors_list.dart';
import 'package:flutter/material.dart';

class DataBackupGuide extends StatelessWidget {
  const DataBackupGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "데이터 백업 안내",
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
                    "원두 다이어리는 별도의 서버 없이 사용자의 휴대폰 저장 공간에 데이터를 저장합니다. 따라서 휴대폰 초기화나 기기 변경 시 데이터 보존 및 이동을 위한 백업/복구 기능을 제공합니다.",
                    style: Theme.of(context).textTheme.bodyMedium,
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
                    "백업/복구 방법",
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
                    "1",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    "백업 버튼을 누르면 해당 데이터가 텍스트 형태로 복사됩니다.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
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
                    "2",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    "복사된 텍스트를 메모장이나 다른 저장소에 붙여넣기 하여 보관해 주세요.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
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
                    "3",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Text(
                    "복구가 필요하면 저장해둔 텍스트를 그대로 복사하여 데이터 복구 입력란에 붙여넣기 한 후 복구 버튼을 눌러주세요.",
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
                  "* ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                ),
                Expanded(
                  child: Text(
                    "복사된 텍스트를 임의로 수정하여 발생하는 데이터 무결성 위반이나 복구가 불가능한 상황에 대한 책임은 사용자 본인에게 있습니다.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.red,
                        ),
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
