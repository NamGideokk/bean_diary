import 'package:bean_diary/screens/data_backup_main.dart';
import 'package:bean_diary/screens/green_bean_warehousing_main.dart';
import 'package:bean_diary/screens/roasting_management_main.dart';
import 'package:bean_diary/screens/sale_history_main.dart';
import 'package:bean_diary/screens/sale_management_main.dart';
import 'package:bean_diary/screens/stock_status_main.dart';
import 'package:bean_diary/utility/colors_list.dart';
import 'package:bean_diary/utility/custom_dialog.dart';
import 'package:bean_diary/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Future.delayed(const Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xff2f2722),
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: height / 40,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.all(10),
          errorStyle: TextStyle(
            fontSize: height / 60,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: height / 52,
          ),
          suffixStyle: TextStyle(
            fontSize: height / 60,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.brown[200]!,
              width: 1,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.brown,
              width: 2,
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[900]!,
              width: 1,
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[700]!,
              width: 2,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            visualDensity: VisualDensity.comfortable,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            elevation: 3,
            shadowColor: Colors.brown[900],
            textStyle: TextStyle(
              fontSize: height / 56,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: Colors.brown,
              visualDensity: VisualDensity.comfortable,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              elevation: 3,
              shadowColor: Colors.brown[900],
              backgroundColor: ColorsList().bgColor,
              side: const BorderSide(
                color: Colors.brown,
                width: 3,
              ),
              textStyle: TextStyle(
                fontSize: height / 56,
              )),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            minimumSize: const Size(0, 0),
            visualDensity: VisualDensity.comfortable,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.comfortable,
          ),
        ),
        expansionTileTheme: ExpansionTileThemeData(
          tilePadding: const EdgeInsets.fromLTRB(15, 0, 5, 0),
          collapsedBackgroundColor: Colors.brown[50],
          backgroundColor: Colors.brown[100]!.withOpacity(0.5),
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.brown,
          space: 0.0,
          thickness: 0.3,
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(),
            disabledBorder: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
        radioTheme: const RadioThemeData(
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        cardTheme: CardTheme(
          color: Colors.brown[50],
          shape: const RoundedRectangleBorder(),
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
        listTileTheme: const ListTileThemeData(
          visualDensity: VisualDensity.comfortable,
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown).copyWith(background: ColorsList().bgColor),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PackageInfo? packageInfo;
  final List<Map<String, dynamic>> _menus = [
    {"title": "재고 현황", "img": "assets/images/stock.png", "screen": const StockStatusMain()},
    {"title": "생두 입고 관리", "img": "assets/images/delivery.png", "screen": const GreenBeanWarehousingMain()},
    {"title": "로스팅 관리", "img": "assets/images/roaster.png", "screen": const RoastingManagementMain()},
    {"title": "판매 관리", "img": "assets/images/production.png", "screen": const SaleManagementMain()},
    {"title": "판매 내역", "img": "assets/images/coffee_bag.png", "screen": const SaleHistoryMain()},
    {"title": "데이터 백업", "img": "assets/images/backup.png", "screen": const DataBackupMain()},
  ];

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  Future getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        bool confirm = await CustomDialog().showAlertDialog(context, "앱 종료", "앱을 종료하시겠습니까?");
        if (confirm) {
          SystemNavigator.pop();
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("원두 다이어리"),
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
        body: Container(
          padding: const EdgeInsets.all(15.0),
          height: height,
          color: Colors.brown[700],
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: _menus.length,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width < 700 ? 2 : 3,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) => _MenuButton(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final List menus;
  final int index;
  final Function() onPressed;
  const _MenuButton({
    Key? key,
    required this.menus,
    required this.index,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      clipBehavior: Clip.hardEdge,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(15),
        elevation: 5,
        shadowColor: Colors.brown[900],
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.brown,
      ),
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            menus[index]["title"],
            style: TextStyle(
              color: Colors.brown[900],
              fontSize: height / 40,
              fontWeight: FontWeight.w500,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              menus[index]["img"],
              width: height / 14,
            ),
          ),
        ],
      ),
    );
  }
}
