import 'dart:convert';
import 'package:bean_diary/sqfLite/green_beans_sqf_lite.dart';
import 'package:bean_diary/sqfLite/roasting_bean_sales_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/green_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_history_sqf_lite.dart';
import 'package:bean_diary/sqflite/roasted_bean_inventory_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DataManagementController extends GetxController {
  final backupDataTECtrl = TextEditingController();
  final backupDataFN = FocusNode();

  final RxList _greenBeans = [].obs;
  final RxList _greenBeanInventory = [].obs;
  final RxList _roastedBeanInventory = [].obs;
  final RxList _salesHistory = [].obs;
  final RxList _hasDataOpacities = [0.0, 0.0, 0.0, 0.0].obs;
  final RxList _noDataOpacities = [0.0, 0.0, 0.0, 0.0].obs;

  get greenBeans => _greenBeans;
  get greenBeanInventory => _greenBeanInventory;
  get roastedBeanInventory => _roastedBeanInventory;
  get salesHistory => _salesHistory;
  get hasDataOpacities => _hasDataOpacities;
  get noDataOpacities => _noDataOpacities;

  /// 25-03-26
  ///
  /// 데이터 백업하기
  Future backupData(BuildContext context, int type) async {
    String title = type == 0
        ? "생두 목록"
        : type == 1
            ? "생두 재고"
            : type == 2
                ? "원두 재고"
                : "판매 내역";
    bool hasData = true;
    String jsonString = "";
    if (type == 0) {
      // 생두 목록
      final list = await GreenBeansSqfLite().getGreenBeans();
      _greenBeans(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
    } else if (type == 1) {
      // 생두 재고
      final list = await GreenBeanInventorySqfLite().getGreenBeanInventory();
      List copyList = [];
      if (list.isNotEmpty) {
        copyList = list.map((e) => Map.from(e)).toList();
        copyList = copyList;
        for (int i = 0; i < list.length; i++) {
          copyList[i]["history"] = await GreenBeanInventoryHistorySqfLite().getInventoryHistories(copyList[i]["id"]);
        }
        _greenBeanInventory(copyList);
        hasData = true;
        jsonString = jsonEncode({title: greenBeanInventory});
      } else {
        _greenBeanInventory(list);
        hasData = false;
      }
    } else if (type == 2) {
      // 원두 재고
      final list = await RoastedBeanInventorySqfLite().getRoastedBeanInventory();
      List copyList = [];
      if (list.isNotEmpty) {
        copyList = list.map((e) => Map.from(e)).toList();
        for (int i = 0; i < list.length; i++) {
          copyList[i]["history"] = await RoastedBeanInventoryHistorySqfLite().getInventoryHistories(copyList[i]["id"]);
        }
        _roastedBeanInventory(copyList);
        hasData = true;
        jsonString = jsonEncode({title: roastedBeanInventory});
      } else {
        _roastedBeanInventory(list);
        hasData = false;
      }
    } else {
      // 판매 내역
      final list = await RoastingBeanSalesSqfLite().getRoastingBeanSales();
      _salesHistory(list);
      if (list.isNotEmpty) {
        hasData = true;
        jsonString = jsonEncode({title: list});
      } else {
        hasData = false;
      }
    }
    if (hasData) {
      setHasDataOpacity(type);
      Clipboard.setData(ClipboardData(text: jsonString));
    } else {
      setNoDataOpacity(type);
    }
    if (context.mounted) {
      CustomDialog().showSnackBar(
        context,
        hasData ? "$title 데이터가 복사되었습니다.\n복사된 텍스트를 다른 곳에 붙여넣기 하여 보관해 주세요." : "$title 데이터가 없습니다.",
        isError: !hasData,
      );
    }
  }

  /// 25-03-26
  ///
  /// 백업 완료 아이콘 투명도 조절하기
  Future setHasDataOpacity(int i) async {
    _hasDataOpacities[i] = 1.0;
    Future.delayed(const Duration(seconds: 3), () {
      _hasDataOpacities[i] = 0.0;
    });
  }

  /// 25-03-26
  ///
  /// 백업 불가 아이콘 투명도 조절하기
  Future setNoDataOpacity(int i) async {
    _noDataOpacities[i] = 1.0;
    Future.delayed(const Duration(seconds: 3), () {
      _noDataOpacities[i] = 0.0;
    });
  }

  /// 25-03-27
  ///
  /// 데이터 삭제하기
  Future deleteData(BuildContext context, int type) async {
    backupDataFN.unfocus();
    String title = type == 0
        ? "생두 목록"
        : type == 1
            ? "생두 재고"
            : type == 2
                ? "원두 재고"
                : "판매 내역";
    final confirm = await CustomDialog().showAlertDialog(
      context,
      "$title 삭제",
      "$title 데이터 전체를 삭제하시겠습니까?\n삭제하신 데이터는 다시 복구할 수 없습니다.",
      acceptTitle: "삭제하기",
    );
    if (confirm == true) {
      int? resultValue;
      if (type == 0) {
        // 생두 목록 삭제
        final result = await GreenBeansSqfLite().deleteTable();
        resultValue = result;
      } else if (type == 1) {
        // 생두 재고 삭제
        final inventoryResult = await GreenBeanInventorySqfLite().deleteTable();
        final historyResult = await GreenBeanInventoryHistorySqfLite().deleteTable();
        inventoryResult == null ? resultValue = 0 : resultValue = inventoryResult;
        historyResult == null ? resultValue = resultValue! + 0 : resultValue = resultValue! + historyResult as int;
      } else if (type == 2) {
        // 원두 재고 삭제
        final inventoryResult = await RoastedBeanInventorySqfLite().deleteTable();
        final historyResult = await RoastedBeanInventoryHistorySqfLite().deleteTable();
        inventoryResult == null ? resultValue = 0 : resultValue = inventoryResult;
        historyResult == null ? resultValue = resultValue! + 0 : resultValue = resultValue! + historyResult as int;
      } else {
        // 판매 내역 삭제
        final result = await RoastingBeanSalesSqfLite().deleteTable();
        resultValue = result;
      }
      if (context.mounted) {
        CustomDialog().showSnackBar(
          context,
          resultValue == null
              ? "데이터 삭제에 실패했습니다.\n잠시 후 다시 시도해 주세요."
              : resultValue > 0
                  ? "$title 데이터 삭제가 완료되었습니다."
                  : "삭제할 데이터가 없습니다.",
          isError: resultValue == null || resultValue == 0 ? true : false,
        );
      }
    }
  }

  /// 25-03-27
  ///
  /// 데이터 복구하기
  Future recoverData(BuildContext context) async {
    backupDataFN.unfocus();
    if (backupDataTECtrl.text.trim().isEmpty) {
      CustomDialog().showSnackBar(context, "백업할 데이터를 넣어주세요.", isError: true);
      backupDataFN.requestFocus();
      return;
    }

    final jsonData = jsonDecode(backupDataTECtrl.text.trim());
    final key = jsonData.keys.toList();

    if (key[0] == "생두 목록") {
      // 생두 목록 복구
      List errorData = [];
      for (var e in jsonData["생두 목록"]) {
        try {
          List keys = e.keys.toList();
          if (keys[0] != "id" || keys[1] != "name") {
            if (context.mounted) {
              CustomDialog().showSnackBar(
                context,
                "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                isLongTime: true,
                isError: true,
              );
            }
            throw Error();
          }

          Map<String, String> value = {"name": e["name"]};
          int result = await GreenBeansSqfLite().insertGreenBean(value);

          if (result != 1) {
            errorData.add(e["name"] ?? "알수없음");
          }
        } catch (err) {
          errorData.add(e["name"] ?? "알수없음");
          debugPrint("GREEN BEANS DATA RECOVER ERROR: $err");
          if (context.mounted) {
            CustomDialog().showSnackBar(
              context,
              "[${e["name"] ?? "알수없음"}] 생두 목록 텍스트 데이터가 재가공되어 복구할 수 없습니다.",
              isLongTime: true,
              isError: true,
            );
          }
          return;
        }
      }
      if (errorData.isNotEmpty) {
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "${jsonData["생두 목록"].length - errorData.length} 건 성공 / ${errorData.length} 건 실패\n${errorData.toString()}\n${errorData.length} 건의 데이터를 복구하는데 실패했습니다.\n중복된 데이터인지 확인하시고, 가공하지 않은 원본 텍스트 데이터로 다시 시도해 주세요.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      } else {
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "${jsonData["생두 목록"].length} 건 성공\n[생두 목록] 데이터가 정상적으로 복구되었습니다.",
          );
        }
        backupDataTECtrl.clear();
        return;
      }
    } else if (key[0] == "생두 재고") {
      // 생두 재고 복구
      final jsonData = jsonDecode(backupDataTECtrl.text.trim());
      int greenBeanSuccessCnt = 0;
      int greenBeanFailureCnt = 0;
      int historySuccessCnt = 0;
      int historyFailureCnt = 0;
      for (var e in jsonData["생두 재고"]) {
        try {
          List keys1 = e.keys.toList();
          if (keys1[0] != "id" || keys1[1] != "name" || keys1[2] != "inventory_weight" || keys1[3] != "history") {
            if (context.mounted) {
              CustomDialog().showSnackBar(
                context,
                "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                isLongTime: true,
                isError: true,
              );
            }
            throw Error();
          }
          final insertResult = await GreenBeanInventorySqfLite().insertGreenBeanInventory({
            "name": e["name"],
            "inventory_weight": e["inventory_weight"],
          });
          insertResult == null ? greenBeanFailureCnt++ : greenBeanSuccessCnt++;

          for (var hisE in e["history"]) {
            List keys2 = hisE.keys.toList();
            if (keys2[0] != "id" || keys2[1] != "green_bean_id" || keys2[2] != "name" || keys2[3] != "date" || keys2[4] != "company" || keys2[5] != "weight") {
              if (context.mounted) {
                CustomDialog().showSnackBar(
                  context,
                  "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                  isLongTime: true,
                  isError: true,
                );
              }
              throw Error();
            }

            final insertHistoryResult = await GreenBeanInventoryHistorySqfLite().insertGreenBeanInventoryHistory(
              {
                "green_bean_id": hisE["green_bean_id"],
                "name": hisE["name"],
                "date": hisE["date"],
                "company": hisE["company"],
                "weight": hisE["weight"],
              },
            );
            insertHistoryResult == null ? historyFailureCnt++ : historySuccessCnt++;
          }
        } catch (err) {
          debugPrint("GREEN BEAN INVENTORY RECOVER ERROR: $err");
          if (context.mounted) {
            CustomDialog().showSnackBar(
              context,
              "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
              isLongTime: true,
              isError: true,
            );
          }
          return;
        }
      }

      if (greenBeanFailureCnt == 0 && historyFailureCnt == 0) {
        // 모두 성공
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "생두 재고 ${Utility().numberFormat(greenBeanSuccessCnt.toString(), isWeight: false)}건 성공\n입고 내역 ${Utility().numberFormat(historySuccessCnt.toString(), isWeight: false)}건 성공\n\n[생두 재고] 데이터가 정상적으로 복구되었습니다.",
            isLongTime: true,
          );
        }
        backupDataTECtrl.clear();
        return;
      } else if (greenBeanSuccessCnt == 0 && historySuccessCnt == 0) {
        // 모두 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "생두 재고 데이터 복구에 실패했습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      } else {
        // 일부 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "생두 재고 ${Utility().numberFormat(greenBeanSuccessCnt.toString(), isWeight: false)}건 성공 / ${Utility().numberFormat(greenBeanFailureCnt.toString(), isWeight: false)}건 실패\n입고 내역 ${Utility().numberFormat(historySuccessCnt.toString(), isWeight: false)}건 성공 / ${Utility().numberFormat(historyFailureCnt.toString(), isWeight: false)}건 실패\n\n[생두 재고] 데이터가 일부 복구되었습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      }
    } else if (key[0] == "원두 재고") {
      // 원두 재고 복구
      final jsonData = jsonDecode(backupDataTECtrl.text.trim());
      int roastedBeanSuccessCnt = 0;
      int roastedBeanFailureCnt = 0;
      int historySuccessCnt = 0;
      int historyFailureCnt = 0;
      for (var e in jsonData["원두 재고"]) {
        try {
          List keys1 = e.keys.toList();
          if (keys1[0] != "id" || keys1[1] != "type" || keys1[2] != "name" || keys1[3] != "inventory_weight" || keys1[4] != "history") {
            if (context.mounted) {
              CustomDialog().showSnackBar(
                context,
                "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                isLongTime: true,
                isError: true,
              );
            }
            throw Error();
          }
          final insertResult = await RoastedBeanInventorySqfLite().insertRoastedBeanInventory({
            "type": e["type"],
            "name": e["name"],
            "inventory_weight": e["inventory_weight"],
          });
          insertResult == null ? roastedBeanFailureCnt++ : roastedBeanSuccessCnt++;

          for (var hisE in e["history"]) {
            List keys2 = hisE.keys.toList();
            if (keys2[0] != "id" || keys2[1] != "roasted_bean_id" || keys2[2] != "name" || keys2[3] != "date" || keys2[4] != "weight") {
              if (context.mounted) {
                CustomDialog().showSnackBar(
                  context,
                  "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                  isLongTime: true,
                  isError: true,
                );
              }
              throw Error();
            }

            final historyInsertResult = await RoastedBeanInventoryHistorySqfLite().insertRoastedBeanInventoryHistory({
              "roasted_bean_id": hisE["roasted_bean_id"],
              "name": hisE["name"],
              "date": hisE["date"],
              "weight": hisE["weight"],
            });
            historyInsertResult == null ? historyFailureCnt++ : historySuccessCnt++;
          }
        } catch (err) {
          debugPrint("ROASTED BEAN INVENTORY HISTORY DATA RECOVER ERROR: $err");
          if (context.mounted) {
            CustomDialog().showSnackBar(
              context,
              "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
              isLongTime: true,
              isError: true,
            );
          }
          return;
        }
      }

      if (roastedBeanFailureCnt == 0 && historyFailureCnt == 0) {
        // 모두 성공
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "원두 재고 ${Utility().numberFormat(roastedBeanSuccessCnt.toString(), isWeight: false)}건 성공\n로스팅 내역 ${Utility().numberFormat(historySuccessCnt.toString(), isWeight: false)}건 성공\n\n[원두 재고] 데이터가 정상적으로 복구되었습니다.",
            isLongTime: true,
          );
        }
        backupDataTECtrl.clear();
        return;
      } else if (roastedBeanSuccessCnt == 0 && historySuccessCnt == 0) {
        // 모두 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "원두 재고 데이터 복구에 실패했습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      } else {
        // 일부 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "원두 재고 ${Utility().numberFormat(roastedBeanSuccessCnt.toString(), isWeight: false)}건 성공 / ${Utility().numberFormat(roastedBeanFailureCnt.toString(), isWeight: false)}건 실패\n로스팅 내역 ${Utility().numberFormat(historySuccessCnt.toString(), isWeight: false)}건 성공 / ${Utility().numberFormat(historyFailureCnt.toString(), isWeight: false)}건 실패\n\n[원두 재고] 데이터가 일부 복구되었습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      }
    } else {
      // 판매 내역 복구
      final jsonData = jsonDecode(backupDataTECtrl.text.trim());
      int successCnt = 0;
      int failureCnt = 0;
      for (var e in jsonData["판매 내역"]) {
        try {
          List keys = e.keys.toList();
          if (keys[0] != "id" || keys[1] != "type" || keys[2] != "name" || keys[3] != "sales_weight" || keys[4] != "company" || keys[5] != "date") {
            if (context.mounted) {
              CustomDialog().showSnackBar(
                context,
                "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
                isLongTime: true,
                isError: true,
              );
            }
            throw Error();
          }

          final insertResult = await RoastingBeanSalesSqfLite().insertRoastedBeanSales({
            "type": e["type"],
            "name": e["name"],
            "sales_weight": e["sales_weight"].toString(),
            "company": e["company"],
            "date": e["date"],
          });

          insertResult == null ? failureCnt++ : successCnt++;
        } catch (err) {
          debugPrint("SALES HISTORY DATA RECOVER ERROR: $err");
          if (context.mounted) {
            CustomDialog().showSnackBar(
              context,
              "텍스트 데이터가 재가공되어 복구에 실패했습니다.",
              isLongTime: true,
              isError: true,
            );
          }
          return;
        }
      }
      if (failureCnt == 0) {
        // 모두 성공
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "${Utility().numberFormat(successCnt.toString(), isWeight: false)}건 성공\n\n[판매 내역] 데이터가 정상적으로 복구되었습니다.",
            isLongTime: true,
          );
        }
        backupDataTECtrl.clear();
        return;
      } else if (successCnt == 0) {
        // 모두 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "판매 내역 데이터 복구에 실패했습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      } else {
        // 일부 실패
        if (context.mounted) {
          CustomDialog().showSnackBar(
            context,
            "${Utility().numberFormat(successCnt.toString(), isWeight: false)}건 성공 / ${Utility().numberFormat(failureCnt.toString(), isWeight: false)}건 실패\n\n[판매 내역] 데이터가 일부 복구되었습니다.",
            isLongTime: true,
            isError: true,
          );
        }
        return;
      }
    }
  }
}
