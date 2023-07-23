import 'package:bean_diary/controller/custom_date_picker_controller.dart';
import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SaleManagementMain extends StatefulWidget {
  const SaleManagementMain({Key? key}) : super(key: key);

  @override
  State<SaleManagementMain> createState() => _SaleManagementMainState();
}

class _SaleManagementMainState extends State<SaleManagementMain> {
  final CustomDatePickerController _customDatePickerCtrl = Get.put(CustomDatePickerController());
  @override
  void initState() {
    super.initState();
    print("🙌 SALE MANAGEMENT MAIN INIT");
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<CustomDatePickerController>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("판매 관리"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(title: "판매 일자", subTitle: "sale day"),
              const CustomDatePicker(),
              const SizedBox(height: 20),
              const HeaderTitle(title: "판매처", subTitle: "company name"),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "업체명",
                ),
              ),
              const SizedBox(height: 20),
              const HeaderTitle(title: "판매 원두", subTitle: "sale coffee bean"),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
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
                        hint: Text("원두 선택"),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: [
                          DropdownMenuItem(
                            child: Text("케냐 AA"),
                          ),
                        ],
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 2,
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "판매량",
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
