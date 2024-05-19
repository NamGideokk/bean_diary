import 'dart:convert';

import 'package:bean_diary/controllers/data_management_controller.dart';
import 'package:bean_diary/sqfLite/green_bean_stock_sqf_lite.dart';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_stock_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:bean_diary/widgets/keyboard_dismiss.dart';
import 'package:bean_diary/widgets/usage_alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataManagementMain extends StatefulWidget {
  const DataManagementMain({Key? key}) : super(key: key);

  @override
  State<DataManagementMain> createState() => _DataManagementMainState();
}

class _DataManagementMainState extends State<DataManagementMain> {
  final _dataManagementCtrl = Get.put(DataManagementController());

  void getBackupData(int type) async {
    final Map<String, dynamic> result = await _dataManagementCtrl.getBackupData(type);

    if (result["bool"]) {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "[${result["title"]}]\n데이터가 복사되었습니다.",
      );
      return;
    } else {
      if (!mounted) return;
      CustomDialog().showSnackBar(context, "[${result["title"]}]\n백업할 데이터가 없습니다.");
      return;
    }
  }

  void dataRecovery(String? value) async {
    String backupData = _dataManagementCtrl.backupDataTECtrl.text;

    if (backupData.trim().isEmpty) {
      if (!mounted) return;
      CustomDialog().showSnackBar(context, "백업할 데이터를 넣어주세요.");
      _dataManagementCtrl.backupDataFN.requestFocus();
      return;
    }

    try {
      final jsonData = jsonDecode(backupData);
      var key = jsonData.keys.toList();

      if (key[0] == "생두 목록") {
        recoveryGreenBean(jsonData);
        return;
      } else if (key[0] == "생두 재고") {
        recoveryGreenBeanStock(jsonData);
        return;
      } else if (key[0] == "원두 재고") {
        recoveryRoastingBeanStock(jsonData);
        return;
      } else if (key[0] == "판매 내역") {
        recoverySalesHistory(jsonData);
        return;
      } else {
        if (!mounted) return;
        CustomDialog().showSnackBar(context, "백업 데이터가 올바르지 않습니다.\n복구가 불가능합니다.");
        return;
      }
    } catch (err) {
      print("data recovery ERROR: $err");
      if (!mounted) return;
      CustomDialog().showSnackBar(context, "백업 데이터가 올바르지 않습니다.\n복구가 불가능합니다.");
      return;
    }
  }

  recoveryGreenBean(Map<String, dynamic> jsonData) async {
    List errorData = [];
    for (var e in jsonData["생두 목록"]) {
      try {
        List keys = e.keys.toList();
        if (keys[0] != "id" || keys[1] != "name") throw Error();
        Map<String, String> value = {"name": e["name"]};
        int result = await GreenBeansSqfLite().insertGreenBean(value);

        if (result != 1) {
          errorData.add(e["name"] ?? "알수없음");
        }
      } catch (err) {
        errorData.add(e["name"] ?? "알수없음");
        print("green bean data recovery ERROR: $err");
        if (!mounted) return;
        CustomDialog().showSnackBar(
          context,
          "[${e["name"] ?? "알수없음"}] 생두의 텍스트 데이터가 재가공되어 복구에 실패했습니다.",
          isLongTime: true,
        );
      }
    }
    if (errorData.isNotEmpty) {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${jsonData["생두 목록"].length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n${errorData.toString()}\n" +
            "${errorData.length} 건의 데이터를 복구하는데 실패했습니다." +
            "중복 데이터인지 확인하시거나, 재가공하지 않은 텍스트 데이터로 다시 시도해 주세요.",
        isLongTime: true,
      );
    } else {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${jsonData["생두 목록"].length} 건 성공\n[생두 목록] 데이터가 정상적으로 복구되었습니다.",
      );
      _dataManagementCtrl.backupDataTECtrl.clear();
    }
    return;
  }

  recoveryGreenBeanStock(Map<String, dynamic> jsonData) async {
    List errorData = [];
    List<bool> totalCount = [];
    for (var e in jsonData["생두 재고"]) {
      try {
        List keys1 = e.keys.toList();
        if (keys1[0] != "id" || keys1[1] != "name" || keys1[2] != "weight" || keys1[3] != "history") throw Error();
        List history = jsonDecode(e["history"]);
        for (var hisE in history) {
          String jsonHistory = "";
          List keys2 = hisE.keys.toList();
          if (keys2[0] != "date" || keys2[1] != "company" || keys2[2] != "weight") throw Error();
          jsonHistory = jsonEncode([
            {
              "date": hisE["date"],
              "company": hisE["company"],
              "weight": hisE["weight"],
            },
          ]);
          Map<String, String> value = {
            "name": e["name"],
            "weight": hisE["weight"],
            "history": jsonHistory,
          };
          var insertResult = await GreenBeanStockSqfLite().insertGreenBeanStock(value);
          totalCount.add(insertResult);
          if (!insertResult) errorData.add(e["name"] ?? "알수 없음");
        }
      } catch (err) {
        errorData.add(e["name"] ?? "알수없음");
        print("green bean stock data recovery ERROR: $err");
        if (!mounted) return;
        CustomDialog().showSnackBar(
          context,
          "[${e["name"] ?? "알수없음"}] 생두의 텍스트 데이터가 재가공되어 복구에 실패했습니다.",
          isLongTime: true,
        );
      }
    }
    if (errorData.isNotEmpty) {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${totalCount.length - errorData.length < 0 ? 0 : totalCount.length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n" +
            "${errorData.length} 건의 데이터를 복구하는데 실패했습니다." +
            "재가공하지 않은 텍스트 데이터로 다시 시도해 주세요.",
        isLongTime: true,
      );
    } else {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${totalCount.length} 건 성공\n[생두 재고] 데이터가 정상적으로 복구되었습니다.",
      );
      _dataManagementCtrl.backupDataTECtrl.clear();
    }
    return;
  }

  recoveryRoastingBeanStock(Map<String, dynamic> jsonData) async {
    List errorData = [];
    List totalCount = [];
    for (var e in jsonData["원두 재고"]) {
      try {
        List keys1 = e.keys.toList();
        if (keys1[0] != "id" || keys1[1] != "type" || keys1[2] != "name" || keys1[3] != "roasting_weight" || keys1[4] != "history") throw Error();
        List history = jsonDecode(e["history"]);
        for (var hisE in history) {
          String jsonHistory = "";
          List keys2 = hisE.keys.toList();
          if (keys2[0] != "date" || keys2[1] != "roasting_weight") throw Error();
          Map<String, String> value = {};
          if (e["type"] == "1") {
            jsonHistory = jsonEncode([
              {
                "date": hisE["date"],
                "roasting_weight": hisE["roasting_weight"],
              },
            ]);
            value = {
              "type": e["type"],
              "name": e["name"],
              "roasting_weight": hisE["roasting_weight"],
              "history": jsonHistory,
            };
          } else {
            jsonHistory = jsonEncode([
              {
                "date": hisE["date"],
                "roasting_weight": hisE["roasting_weight"],
              },
            ]);
            value = {
              "type": e["type"],
              "name": e["name"],
              "roasting_weight": hisE["roasting_weight"],
              "history": jsonHistory,
            };
          }
          bool insertResult = await RoastingBeanStockSqfLite().insertRoastingBeanStock(value);
          totalCount.add(insertResult);
          if (!insertResult) {
            errorData.add(e["name"] ?? "알수없음");
          }
        }
      } catch (err) {
        totalCount.add(false);
        errorData.add(e["name"] ?? "알수없음");
        print("roasting bean stock data recovery ERROR: $err");
        if (!mounted) return;
        CustomDialog().showSnackBar(
          context,
          "[${e["name"] ?? "알수없음"}] 원두의 텍스트 데이터가 재가공되어 복구에 실패했습니다.",
          isLongTime: true,
        );
      }
    }
    if (errorData.isNotEmpty) {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${totalCount.length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n" + "${errorData.length} 건의 데이터를 복구하는데 실패했습니다." + "재가공하지 않은 텍스트 데이터로 다시 시도해 주세요.",
        isLongTime: true,
      );
    } else {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${totalCount.length} 건 성공\n[원두 재고] 데이터가 정상적으로 복구되었습니다.",
      );
      _dataManagementCtrl.backupDataTECtrl.clear();
    }
  }

  recoverySalesHistory(Map<String, dynamic> jsonData) async {
    List errorData = [];
    for (var e in jsonData["판매 내역"]) {
      try {
        List keys = e.keys.toList();
        if (keys[0] != "id" || keys[1] != "type" || keys[2] != "name" || keys[3] != "sales_weight" || keys[4] != "company" || keys[5] != "date") throw Error();
        Map<String, String> value = {
          "name": e["name"],
          "type": e["type"],
          "sales_weight": e["sales_weight"].toString(),
          "company": e["company"],
          "date": e["date"],
        };
        bool result = await RoastingBeanSalesSqfLite().insertRoastingBeanSales(value);

        if (!result) {
          errorData.add("${e["name"] ?? "알수없음"}");
        }
      } catch (err) {
        errorData.add("${e["name"] ?? "알수없음"}");
        print("sales history data recovery ERROR: $err");
        if (!mounted) return;
        CustomDialog().showSnackBar(
          context,
          "[${e["name"] ?? "알수없음"}] 판매 내역의 텍스트 데이터가 재가공되어 복구에 실패했습니다.",
          isLongTime: true,
        );
      }
    }
    if (errorData.isNotEmpty) {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${jsonData["판매 내역"].length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n" + "${errorData.length} 건의 데이터를 복구하는데 실패했습니다." + "재가공하지 않은 텍스트 데이터로 다시 시도해 주세요.",
        isLongTime: true,
      );
    } else {
      if (!mounted) return;
      CustomDialog().showSnackBar(
        context,
        "${jsonData["판매 내역"].length} 건 성공\n[판매 내역] 데이터가 정상적으로 복구되었습니다.",
      );
      _dataManagementCtrl.backupDataTECtrl.clear();
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
    return Scaffold(
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
                        onPressed: () => getBackupData(0),
                      ),
                      const SizedBox(height: 10),
                      _BackupButton(
                        title: "생두 재고 백업",
                        onPressed: () => getBackupData(1),
                      ),
                      const SizedBox(height: 10),
                      _BackupButton(
                        title: "원두 재고 백업",
                        onPressed: () => getBackupData(2),
                      ),
                      const SizedBox(height: 10),
                      _BackupButton(
                        title: "판매 내역 백업",
                        onPressed: () => getBackupData(3),
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
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: "복사한 백업 데이터",
                        helperText: "복사된 텍스트 데이터를 그대로 붙여넣기 하시고, 한 번에 하나의 데이터만 넣어주세요.",
                        helperStyle: TextStyle(
                          fontSize: height / 60,
                        ),
                        helperMaxLines: 3,
                        suffixIcon: IconButton(
                          style: IconButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: clearBackupDataText,
                          icon: Icon(
                            Icons.clear_rounded,
                            size: height / 50,
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(),
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
