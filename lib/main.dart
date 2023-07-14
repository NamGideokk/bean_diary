import 'package:bean_diary/screens/green_bean_management_main.dart';
import 'package:bean_diary/screens/roasting_management_main.dart';
import 'package:bean_diary/screens/sale_history_main.dart';
import 'package:bean_diary/screens/sale_management_main.dart';
import 'package:bean_diary/screens/stock_status_main.dart';
import 'package:flutter/material.dart';

void main() {
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff2f2722),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.brown[200]!,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.brown,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[900]!,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red[700]!,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            // backgroundColor: Color(0xffdaa86a),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            visualDensity: VisualDensity.comfortable,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            textStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.brown,
            visualDensity: VisualDensity.comfortable,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(
              color: Colors.brown,
              width: 3,
            ),
            textStyle: const TextStyle(
              fontSize: 15,
            ),
          ),
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
          // childrenPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          collapsedBackgroundColor: Colors.brown[50],
          backgroundColor: Colors.brown[100],
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.black26,
          indent: 10,
          endIndent: 10,
          space: 0.0,
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(),
            disabledBorder: OutlineInputBorder(),
          ),
          menuStyle: MenuStyle(),
        ),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange).copyWith(background: Color(0xffFFFDF8)),
      ),
      // localizationsDelegates: <LocalizationsDelegate<Object>>[
      //   DefaultMaterialLocalizations.delegate,
      //   DefaultWidgetsLocalizations.delegate,
      // ],
      // locale: Locale("ko", "KR"),
      // supportedLocales: const [
      //   Locale("ko", "KR"),
      //   Locale("en", "EN"),
      // ],
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("원두 다이어리"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockStatusMain(),
                  ),
                );
              },
              child: Text("재고 현황"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GreenBeanManagementMain(),
                  ),
                );
              },
              child: Text("생두 입고 관리"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoastingManagementMain(),
                  ),
                );
              },
              child: Text("로스팅 관리"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SaleManagementMain(),
                  ),
                );
              },
              child: Text("판매 관리"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SaleHistoryMain(),
                  ),
                );
              },
              child: Text("판매 내역"),
            ),
          ],
        ),
      ),
    );
  }
}
