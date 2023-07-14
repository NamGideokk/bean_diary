import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoastingManagementMain extends StatefulWidget {
  const RoastingManagementMain({Key? key}) : super(key: key);

  @override
  State<RoastingManagementMain> createState() => _RoastingManagementMainState();
}

class _RoastingManagementMainState extends State<RoastingManagementMain> {
  String _roastingTypeValue = "";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("로스팅 관리"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(title: "로스팅 일자", subTitle: "roasting day"),
                  const CustomDatePicker(),
                  const SizedBox(height: 20),
                  const HeaderTitle(title: "투입 생두 정보", subTitle: "input green bean information"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.brown[100]!,
                        width: 0.8,
                      ),
                      color: Colors.brown[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: const Text("생두 선택"),
                      items: const [
                        DropdownMenuItem(
                          value: "1",
                          child: Text("케냐 AA"),
                        ),
                        DropdownMenuItem(
                          value: "2",
                          child: Text("브라질 호나우딩요"),
                        ),
                      ],
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "투입량",
                            suffixText: "kg",
                          ),
                          style: TextStyle(
                            fontSize: height / 52,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "배출 비율 (1~100)",
                            suffixText: "%",
                          ),
                          style: TextStyle(
                            fontSize: height / 52,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline_sharp,
                        size: height / 40,
                      ),
                      label: const Text("생두 추가"),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 2,
                          color: Colors.brown[300]!,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const HeaderTitle(title: "로스팅 타입", subTitle: "roasting type"),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: "1",
                          groupValue: _roastingTypeValue,
                          selected: _roastingTypeValue == "1" ? true : false,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            print(value);
                            _roastingTypeValue = value!;
                            setState(() {});
                          },
                          title: Text("싱글빈"),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          value: "2",
                          groupValue: _roastingTypeValue,
                          selected: _roastingTypeValue == "2" ? true : false,
                          visualDensity: VisualDensity.compact,
                          onChanged: (value) {
                            print(value);
                            _roastingTypeValue = value!;
                            setState(() {});
                          },
                          title: Text("블렌드"),
                        ),
                      ),
                    ],
                  ),
                  if (_roastingTypeValue == "2")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const HeaderTitle(title: "블렌드명", subTitle: "blend name"),
                        SizedBox(
                          width: double.infinity,
                          child: TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "블렌드명",
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: ColorsList().bgColor,
                padding: const EdgeInsets.all(10),
                child: SafeArea(
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          print("초기화");
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: Text(
                          "초기화",
                          style: TextStyle(
                            fontSize: height / 46,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            print("로스팅");
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "로스팅",
                            style: TextStyle(
                              fontSize: height / 46,
                            ),
                          ),
                        ),
                      ),
                    ],
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
