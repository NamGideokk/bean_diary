import 'package:bean_diary/controller/data_management_controller.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataManagementMain extends StatefulWidget {
  const DataManagementMain({Key? key}) : super(key: key);

  @override
  State<DataManagementMain> createState() => _DataManagementMainState();
}

class _DataManagementMainState extends State<DataManagementMain> {
  final _dataManagementCtrl = Get.put(DataManagementController());

  void dataRecovery(String? value) {}

  Future<void> getGreenBeansBackup(int type) async {
    List list;
    String title;
    switch (type) {
      case 0:
        await _dataManagementCtrl.getGreenBeans();
        list = _dataManagementCtrl.greenBeans;
        title = "생두 목록";
        break;
      case 1:
        await _dataManagementCtrl.getGreenBeanStock();
        list = _dataManagementCtrl.greenBeanStock;
        title = "생두 재고";
        break;
      case 2:
        await _dataManagementCtrl.getRoastingBeanStock();
        list = _dataManagementCtrl.roastingBeanStock;
        title = "원두 재고";
        break;
      case 3:
        await _dataManagementCtrl.getSalesHistory();
        list = _dataManagementCtrl.salesHistory;
        title = "판매 내역";
        break;
      default:
        return;
    }
    if (list.isEmpty) {
      if (!mounted) return;
      return CustomDialog().showFloatingSnackBar(context, "[$title]\n백업할 데이터가 없습니다.");
    } else {
      Clipboard.setData(ClipboardData(text: title + list.toString()));
      if (!mounted) return;
      return CustomDialog().showFloatingSnackBar(
        context,
        "[$title]\n데이터가 복사되었습니다.",
        bgColor: Colors.green,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<DataManagementController>();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("데이터 관리"),
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
                          onPressed: () => getGreenBeansBackup(0),
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "생두 재고 백업",
                          onPressed: () => getGreenBeansBackup(1),
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "원두 재고 백업",
                          onPressed: () => getGreenBeansBackup(2),
                        ),
                        const SizedBox(height: 10),
                        _BackupButton(
                          title: "판매 내역 백업",
                          onPressed: () => getGreenBeansBackup(3),
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
                      child: const Text("복구"),
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
