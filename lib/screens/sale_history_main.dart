import 'package:bean_diary/widgets/header_title.dart';
import 'package:flutter/material.dart';

class SaleHistoryMain extends StatefulWidget {
  const SaleHistoryMain({Key? key}) : super(key: key);

  @override
  State<SaleHistoryMain> createState() => _SaleHistoryMainState();
}

class _SaleHistoryMainState extends State<SaleHistoryMain> {
  String _selectValue = "전체";

  void _setFilter(String title) {
    _selectValue = title;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("판매 내역"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderTitle(title: "판매 내역", subTitle: "sale history"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                TextButton(
                  onPressed: () {
                    _setFilter("전체");
                  },
                  child: _FilterText(title: "전체", selectValue: _selectValue),
                ),
                TextButton(
                  onPressed: () {
                    _setFilter("싱글빈");
                  },
                  child: _FilterText(title: "싱글빈", selectValue: _selectValue),
                ),
                TextButton(
                  onPressed: () {
                    _setFilter("블렌드");
                  },
                  child: _FilterText(title: "블렌드", selectValue: _selectValue),
                ),
              ],
            ),
            const Divider(
              height: 10,
              color: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterText extends StatelessWidget {
  final String title, selectValue;
  const _FilterText({
    Key? key,
    required this.title,
    required this.selectValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Text(
      title,
      style: TextStyle(
        fontWeight: selectValue == title ? FontWeight.bold : FontWeight.normal,
        fontSize: selectValue == title ? height / 56 : height / 60,
      ),
    );
  }
}
