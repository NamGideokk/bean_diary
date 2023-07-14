import 'package:bean_diary/sqflite/green_beans_sqf_lite.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/empty_widget.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/cupertino.dart';
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
  List _greenBeans = [];

  @override
  void initState() {
    super.initState();
    print("🙌 REGIST GREEN BEAN INIT");
    GreenBeansSqfLite().openDB();
    getGreenBeansToDB();
  }

  Future getGreenBeansToDB() async {
    _greenBeans = await GreenBeansSqfLite().getGreenBeans();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("생두 등록 / 관리"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
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
                      bool result = await GreenBeansSqfLite().insertGreenBean(value);
                      print("☕️ 생두 데이터 삽입 결과 ::: $result");
                      _showErrorText = false;
                      _greenBeanNameTECtrl.clear();
                      final snackBar = CustomDialog().showCustomSnackBar(
                        context,
                        "${_greenBeanNameTECtrl.text.trim()}\n생두가 등록되었습니다.",
                        bgColor: Colors.lightGreen[700]!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      GreenBeansSqfLite().getGreenBeans();
                      setState(() {});
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
              const SizedBox(height: 20),
              const HeaderTitle(title: "생두 목록", subTitle: "green bean list"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: _greenBeans.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print("");
                    if (_greenBeans.isEmpty) {
                      return const Center(
                        child: EmptyWidget(content: "등록된 생두가 없습니다."),
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _greenBeans[index]["name"],
                          style: TextStyle(
                            fontSize: height / 54,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            print("원두 삭제");
                          },
                          icon: Icon(
                            CupertinoIcons.delete_simple,
                            size: height / 60,
                          ),
                          label: Text(
                            "삭제",
                            style: TextStyle(
                              fontSize: height / 70,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  bool result = await GreenBeansSqfLite().deleteGreenBean("케냐 AA");

                  final snackBar = CustomDialog().showCustomSnackBar(
                    context,
                    result ? "[생두]가 삭제되었습니다." : "오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
                    bgColor: result ? Colors.green : Colors.red,
                  );
                  // 모달바텀시트에 가려져 보이지 않음 수정 필요
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("삭제"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
