import 'package:bean_diary/sqflite/green_bean_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';

class RegistGreenBean extends StatefulWidget {
  const RegistGreenBean({Key? key}) : super(key: key);

  @override
  State<RegistGreenBean> createState() => _RegistGreenBeanState();
}

class _RegistGreenBeanState extends State<RegistGreenBean> {
  final _greenBeanNameTECtrl = TextEditingController();
  final _greenBeanNameFN = FocusNode();
  bool _showErrorText = false;

  @override
  void initState() {
    super.initState();
    print("🙌 REGIST GREEN BEAN INIT");
    GreenBeanSqfLite().openDB();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        color: Colors.brown[50],
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderTitle(
              title: "생두명",
              subTitle: "green bean name",
            ),
            TextField(
              controller: _greenBeanNameTECtrl,
              focusNode: _greenBeanNameFN,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "예) 케냐 AA",
                errorText: _showErrorText ? " 생두명을 입력해 주세요." : null,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  print("생두 등록");
                  if (_greenBeanNameTECtrl.text.trim() == "") {
                    _showErrorText = true;
                    setState(() {});
                    _greenBeanNameFN.requestFocus();
                  } else {
                    Map<String, String> value = {"name": _greenBeanNameTECtrl.text.trim()};
                    bool result = await GreenBeanSqfLite().insertGreenBean(value);
                    print("☕️ 생두 데이터 삽입 결과 ::: $result");
                    _showErrorText = false;
                    setState(() {});
                    final snackBar = CustomDialog().showCustomSnackBar(
                      context,
                      "${_greenBeanNameTECtrl.text.trim()}\n생두가 등록되었습니다.",
                      bgColor: Colors.lightGreen[700]!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    GreenBeanSqfLite().getGreenBeans();
                    return Navigator.pop(context);
                  }
                },
                child: Text(
                  "생두 등록",
                  style: TextStyle(
                    fontSize: height / 50,
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
