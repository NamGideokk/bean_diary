import 'package:bean_diary/controllers/app_info_controller.dart';
import 'package:bean_diary/screens/home.dart';
import 'package:bean_diary/utility/custom_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  Get.put(AppInfoController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'bean diary',
      debugShowCheckedModeBanner: false,
      theme: CustomAppTheme().appTheme(height),
      // darkTheme: CustomAppTheme().appDarkTheme(height),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ko', ''),
      ],
      home: const Home(),
    );
  }
}
