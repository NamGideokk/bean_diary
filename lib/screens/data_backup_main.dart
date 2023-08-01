import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataBackupMain extends StatefulWidget {
  const DataBackupMain({Key? key}) : super(key: key);

  @override
  State<DataBackupMain> createState() => _DataBackupMainState();
}

class _DataBackupMainState extends State<DataBackupMain> {
  void dataRecovery(String? value) {
    print("복구");
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("데이터 백업"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderTitle(title: "데이터 백업", subTitle: "data backup"),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        _BackupButton(
                          title: "생두 목록 백업",
                          onPressed: () async {
                            print("a");
                            await Clipboard.setData(ClipboardData(text: "야야야"));
                            print(Clipboard.hasStrings().then((value) => print("가져왔어요 ${value}를")));
                          },
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "생두 재고 백업",
                          onPressed: () {
                            print("b");
                          },
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "원두 재고 백업",
                          onPressed: () {
                            print("c");
                          },
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "판매 내역 백업",
                          onPressed: () {
                            print("d");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: UsageAlertWidget(isWeightGuide: false),
                ),
                const HeaderTitle(title: "데이터 복구", subTitle: "data recovery"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        textInputAction: TextInputAction.go,
                        onSubmitted: dataRecovery,
                        decoration: InputDecoration(
                          hintText: "복사한 백업 데이터",
                          helperText: "복사된 텍스트 데이터를 그대로 붙여넣기 하시고, 한 번에 하나의 데이터만 넣어주세요.",
                          helperStyle: TextStyle(
                            fontSize: height / 60,
                          ),
                          helperMaxLines: 3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => dataRecovery(""),
                      child: Text(
                        "복구",
                      ),
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

class _BackupButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const _BackupButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        title,
      ),
    );
  }
}
