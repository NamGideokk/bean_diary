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

  late Future _getGreenBeansToDBFuture;

  @override
  void initState() {
    super.initState();
    _getGreenBeansToDBFuture = getGreenBeansToDB();
    GreenBeansSqfLite().openDB();
  }

  Future getGreenBeansToDB() async {
    _greenBeans = await GreenBeansSqfLite().getGreenBeans();
    if (_greenBeans.length > 1) sortingName();
    return _greenBeans;
  }

  sortingName() {
    var copyGreenBeans = [..._greenBeans];
    copyGreenBeans.sort((a, b) {
      return a["name"]!.compareTo(b["name"]!);
    });
    _greenBeans = copyGreenBeans;
    setState(() {});
  }

  void onTapInsertGreenBean() async {
    if (_greenBeanNameTECtrl.text.trim() == "") {
      _showErrorText = true;
      setState(() {});
      _greenBeanNameFN.requestFocus();
    } else {
      Map<String, String> value = {"name": _greenBeanNameTECtrl.text.trim()};
      int result = await GreenBeansSqfLite().insertGreenBean(value);
      _showErrorText = false;
      setState(() {});
      if (!mounted) return;
      final snackBar = CustomDialog().showCustomSnackBar(
        context,
        result == 0
            ? "생두 등록에 실패했습니다.\n잠시 후 다시 시도해 주세요."
            : result == 1
                ? "[${_greenBeanNameTECtrl.text.trim()}]\n생두가 등록되었습니다."
                : "이미 등록된 생두명입니다.\n생두는 중복으로 등록할 수 없습니다.",
        bgColor: result == 1 ? Colors.green : Colors.red,
      );
      if (result == 0) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else if (result == 1) {
        _greenBeanNameTECtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await getGreenBeansToDB();
        setState(() {});
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _greenBeanNameFN.requestFocus();
        return;
      }
    }
  }

  void onTapDeleteGreenBean(int index) async {
    bool confirm = await CustomDialog().showAlertDialog(
      context,
      "생두 삭제",
      "[${_greenBeans[index]["name"]}]\n생두를 삭제하시겠습니까?",
      acceptTitle: "삭제",
    );
    if (confirm) {
      bool result = await GreenBeansSqfLite().deleteGreenBean(_greenBeans[index]["name"]);

      if (!mounted) return;
      final snackBar = CustomDialog().showCustomSnackBar(
        context,
        result ? "[${_greenBeans[index]["name"]}]\n생두가 삭제되었습니다." : "생두 삭제 중 오류가 발생했습니다.\n잠시 후 다시 시도해 주세요.",
        bgColor: result ? Colors.green : Colors.red,
      );
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await getGreenBeansToDB();
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("생두 등록 / 관리"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                textInputAction: TextInputAction.go,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "예) 케냐 AA",
                  errorText: _showErrorText ? " 생두명을 입력해 주세요." : null,
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onSubmitted: (value) => onTapInsertGreenBean(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTapInsertGreenBean,
                  child: Text(
                    "생두 등록",
                    style: TextStyle(
                      fontSize: height / 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  const HeaderTitle(title: "생두 목록", subTitle: "green bean list"),
                  if (_greenBeans.isNotEmpty)
                    Text(
                      "${_greenBeans.length}건",
                      style: TextStyle(
                        fontSize: height / 60,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FutureBuilder(
                    future: _getGreenBeansToDBFuture,
                    builder: (context, snapshot) => snapshot.hasData && snapshot.data.length > 0
                        ? ListView.separated(
                            itemCount: _greenBeans.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 10),
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => const Divider(height: 8),
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _greenBeans[index]["name"],
                                      style: TextStyle(
                                        fontSize: height / 52,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () => onTapDeleteGreenBean(index),
                                    icon: Icon(
                                      CupertinoIcons.delete_simple,
                                      size: height / 70,
                                    ),
                                    label: Text(
                                      "삭제",
                                      style: TextStyle(
                                        fontSize: height / 60,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : const EmptyWidget(content: "등록된 생두가 없습니다."),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
