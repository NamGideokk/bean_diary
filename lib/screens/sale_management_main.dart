import 'package:bean_diary/widgets/custom_date_picker.dart';
import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';

class SaleManagementMain extends StatefulWidget {
  const SaleManagementMain({Key? key}) : super(key: key);

  @override
  State<SaleManagementMain> createState() => _SaleManagementMainState();
}

class _SaleManagementMainState extends State<SaleManagementMain> {
  @override
  void initState() {
    super.initState();
    print("🙌 SALE MANAGEMENT MAIN INIT");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("판매 관리"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeaderTitle(title: "판매 일자", subTitle: "sale day"),
              CustomDatePicker(),
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
                    flex: 3,
                    child: DropdownButton(
                      hint: Text("원두 선택"),
                      isExpanded: true,
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
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 1,
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
