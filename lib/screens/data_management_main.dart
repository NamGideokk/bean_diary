import 'dart:convert';

import 'package:bean_diary/controller/data_management_controller.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
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
      final jsonString = jsonEncode({title: list});
      Clipboard.setData(ClipboardData(text: jsonString));
      if (!mounted) return;
      return CustomDialog().showFloatingSnackBar(
        context,
        "[$title]\n데이터가 복사되었습니다.",
        bgColor: Colors.green,
      );
    }
  }

  void dataRecovery(String? value) async {
    String backupData = _dataManagementCtrl.backupDataTECtrl.text;

    if (backupData.trim().isEmpty) {
      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(context, "백업할 데이터를 넣어주세요.");
      _dataManagementCtrl.backupDataFN.requestFocus();
      return;
    }

    final jsonData = jsonDecode(backupData);
    var key = jsonData.keys.toList();

    if (key[0] == "생두 목록") {
      List errorData = [];
      for (var e in jsonData["생두 목록"]) {
        Map<String, String> value = {"name": e["name"]};
        int result = await GreenBeansSqfLite().insertGreenBean(value);

        if (result != 1) {
          errorData.add(e["name"]);
        }
      }
      if (errorData.isNotEmpty) {
        if (!mounted) return;
        CustomDialog().showFloatingSnackBar(
          context,
          "${jsonData["생두 목록"].length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n${errorData.toString()}\n" +
              "${errorData.length} 건의 데이터를 복구하는데 실패했습니다." +
              "중복 데이터인지 확인하시거나, 재가공하지 않은 텍스트 데이터로 다시 시도해 주세요.",
          isLongTime: true,
        );
      } else {
        if (!mounted) return;
        CustomDialog().showFloatingSnackBar(
          context,
          "${jsonData["생두 목록"].length} 건 성공\n[생두 목록] 데이터가 정상적으로 복구되었습니다.",
          bgColor: Colors.green,
        );
      }
      _dataManagementCtrl.backupDataTECtrl.clear();
      return;
    } else if (key[0] == "생두 재고") {
      print("생두 재고 이야!");
      return;
    } else if (key[0] == "원두 재고") {
      print("원두 재고 이야!");
      return;
    } else if (key[0] == "판매 내역") {
      print("판매 내역 이야!");
      return;
    } else {
      if (!mounted) return;
      CustomDialog().showFloatingSnackBar(context, "백업 데이터가 올바르지 않습니다.\n복구가 불가능합니다.");
      return;
    }
  }

  void clearBackupDataText() {
    _dataManagementCtrl.backupDataTECtrl.clear();
    _dataManagementCtrl.backupDataFN.requestFocus();
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
                        controller: _dataManagementCtrl.backupDataTECtrl,
                        focusNode: _dataManagementCtrl.backupDataFN,
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
                          suffixIcon: IconButton(
                            onPressed: clearBackupDataText,
                            icon: const Icon(Icons.clear_rounded),
                          ),
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
