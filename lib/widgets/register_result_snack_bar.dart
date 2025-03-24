import 'package:bean_diary/controllers/green_bean_entry_controller.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterResultSnackBar extends StatelessWidget {
  final SnackBarType? snackBarType;
  final String date, supplier, retailer, blendName, selectedBean, inputWeight, outputWeight, saleWeight, message;
  final List? inputList;
  const RegisterResultSnackBar({
    super.key,
    this.snackBarType,
    required this.date,
    this.supplier = "",
    this.retailer = "",
    this.blendName = "",
    this.selectedBean = "",
    this.inputWeight = "",
    this.outputWeight = "",
    this.saleWeight = "",
    this.inputList,
    required this.message,
  });

  factory RegisterResultSnackBar.stock({
    required SnackBarType snackBarType,
    required String date,
    required String supplier,
    required String selectedBean,
    required String inputWeight,
    required String message,
  }) {
    return RegisterResultSnackBar(
      snackBarType: snackBarType,
      date: date,
      supplier: supplier,
      selectedBean: selectedBean,
      inputWeight: inputWeight,
      message: message,
    );
  }

  factory RegisterResultSnackBar.singleOriginRoasting({
    required SnackBarType snackBarType,
    required String date,
    required String selectedBean,
    required String inputWeight,
    required String outputWeight,
    required String message,
  }) {
    return RegisterResultSnackBar(
      snackBarType: snackBarType,
      date: date,
      selectedBean: selectedBean,
      inputWeight: inputWeight,
      outputWeight: outputWeight,
      message: message,
    );
  }

  factory RegisterResultSnackBar.blendRoasting({
    required SnackBarType snackBarType,
    required String date,
    required String blendName,
    required List inputList,
    required String outputWeight,
    required String message,
  }) {
    return RegisterResultSnackBar(
      snackBarType: snackBarType,
      date: date,
      blendName: blendName,
      inputList: inputList,
      outputWeight: outputWeight,
      message: message,
    );
  }

  factory RegisterResultSnackBar.sale({
    required SnackBarType snackBarType,
    required String date,
    required String retailer,
    required String selectedBean,
    required String saleWeight,
    required String message,
  }) {
    return RegisterResultSnackBar(
      snackBarType: snackBarType,
      date: date,
      retailer: retailer,
      selectedBean: selectedBean,
      saleWeight: saleWeight,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return snackBarType == SnackBarType.stock
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SnackBarRow(title: "입고일자", content: date),
              _SnackBarRow(title: "공급처", content: supplier),
              _SnackBarRow(title: "생두명", content: selectedBean),
              _SnackBarRow(title: "입고량", content: inputWeight),
              const SizedBox(height: 15),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    textStyle: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  onPressed: () async {
                    final confirm = await CustomDialog().showAlertDialog(
                      context,
                      "생두 입고 등록 취소",
                      "최근 입고 등록을 취소하시겠습니까?",
                      acceptTitle: "취소하기",
                      cancelTitle: "닫기",
                    );
                    if (confirm == true && context.mounted) {
                      final greenBeanEntryCtrl = Get.find<GreenBeanEntryController>();
                      greenBeanEntryCtrl.revokeRecentInsert(context);
                    }
                  },
                  child: const Text("등록 취소"),
                ),
              ),
            ],
          )
        : snackBarType == SnackBarType.singleOriginRoasting
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SnackBarRow(title: "로스팅일자", content: date),
                  _SnackBarRow(title: "생두명", content: selectedBean),
                  _SnackBarRow(title: "투입량", content: inputWeight),
                  _SnackBarRow(title: "배출량", content: outputWeight),
                  const SizedBox(height: 15),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ],
              )
            : snackBarType == SnackBarType.blendRoasting
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SnackBarRow(title: "로스팅일자", content: date),
                      _SnackBarRow(title: "블렌드명", content: blendName),
                      for (int i = 0; i < inputList!.length; i++)
                        _SnackBarRow(
                          title: "투입생두 ${(i + 1).toString().padLeft(2, "0")}",
                          content: inputList![i],
                        ),
                      _SnackBarRow(title: "배출량", content: outputWeight),
                      const SizedBox(height: 15),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ],
                  )
                : snackBarType == SnackBarType.sale
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SnackBarRow(title: "판매일자", content: date),
                          _SnackBarRow(title: "판매처", content: retailer),
                          _SnackBarRow(title: "상품명", content: selectedBean),
                          _SnackBarRow(title: "판매량", content: saleWeight),
                          const SizedBox(height: 15),
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                          ),
                        ],
                      )
                    : Text(message);
  }
}

class _SnackBarRow extends StatelessWidget {
  final String title, content;
  const _SnackBarRow({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.brown[50],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
          ),
        ),
      ],
    );
  }
}
