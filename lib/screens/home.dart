import 'package:bean_diary/screens/data_management_main.dart';
import 'package:bean_diary/screens/green_bean_warehousing_main.dart';
import 'package:bean_diary/screens/roasting_management_main.dart';
import 'package:bean_diary/screens/sale_history/sale_history_main.dart';
import 'package:bean_diary/screens/sale_management_main.dart';
import 'package:bean_diary/screens/stock_status_main.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/utility/custom_upgrade_message.dart';
import 'package:bean_diary/widgets/drawer_widget.dart';
import 'package:bean_diary/widgets/home_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PackageInfo? packageInfo;
  final List<Map<String, dynamic>> _menus = [
    {
      "title": "재고 현황",
      "subTitle": "생두와 원두 재고를 확인하세요",
      "img": "assets/images/stock.png",
      "screen": const StockStatusMain(),
    },
    {
      "title": "생두 입고 관리",
      "subTitle": "생두를 등록하고 입고를 관리하세요",
      "img": "assets/images/delivery.png",
      "screen": const GreenBeanWarehousingMain(),
    },
    {
      "title": "로스팅 관리",
      "subTitle": "입고한 생두를 로스팅하고 등록하세요",
      "img": "assets/images/roaster.png",
      "screen": const RoastingManagementMain(),
    },
    {
      "title": "판매 관리",
      "subTitle": "판매한 원두를 등록하세요",
      "img": "assets/images/production.png",
      "screen": const SaleManagementMain(),
    },
    {
      "title": "판매 내역",
      "subTitle": "판매했던 원두 내역을 확인하세요",
      "img": "assets/images/coffee_bag.png",
      "screen": const SaleHistoryMain(),
    },
    {
      "title": "데이터 관리",
      "subTitle": "소중한 데이터는 백업하고 복구하세요",
      "img": "assets/images/backup.png",
      "screen": const DataManagementMain(),
    },
  ];

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  /// 패키지 정보 가져오기
  Future getPackageInfo() async => packageInfo = await PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) CustomDialog().appTerminationAlert(context);
      },
      child: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        upgrader: Upgrader(
          messages: CustomUpgradeMessages(),
          durationUntilAlertAgain: const Duration(minutes: 30),
        ),
        child: Scaffold(
          backgroundColor: Colors.brown[700],
          appBar: AppBar(
            title: const Text("원두 다이어리"),
            centerTitle: false,
            leading: Builder(
              builder: (context) => GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
            ),
            leadingWidth: 44,
          ),
          drawer: const DrawerWidget(),
          body: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            itemCount: _menus.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => HomeMenuButton(
              menus: _menus,
              index: index,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _menus[index]["screen"],
                  ),
                );
              },
            ),
          ),
          // body: GridView.builder(
          //   padding: const EdgeInsets.all(15),
          //   physics: const BouncingScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: width < 700 ? 2 : 3,
          //     childAspectRatio: 1.1 / textScaleFactor,
          //     crossAxisSpacing: 20,
          //     mainAxisSpacing: 20,
          //   ),
          //   itemCount: _menus.length,
          //   itemBuilder: (context, index) => HomeMenuButton(
          //     menus: _menus,
          //     index: index,
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => _menus[index]["screen"],
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }
}
