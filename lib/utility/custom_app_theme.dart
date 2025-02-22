import 'package:bean_diary/utility/colors_list.dart';
import 'package:flutter/material.dart';

class CustomAppTheme {
  /// 일반 테마
  ThemeData appTheme(double height) {
    return ThemeData(
      useMaterial3: true,
      // 다크테마 대비
      // colorScheme: ColorScheme.light(
      //   // background: ColorsList().bgColor,
      //   background: Colors.brown,
      //   primary: Colors.brown,
      //   onPrimary: Colors.white,
      // ),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown).copyWith(
        surface: ColorsList().bgColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff2f2722),
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: height / 46,
        ),
      ),
      textTheme: TextTheme(
        // TextField style
        bodyMedium: TextStyle(
          fontSize: height / 54,
          color: Colors.black,
          letterSpacing: 0,
        ),
        // Smalleast text
        bodySmall: TextStyle(
          fontSize: height / 70,
          color: Colors.black,
          letterSpacing: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        errorStyle: TextStyle(
          fontSize: height / 60,
        ),
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: height / 52,
        ),
        prefixStyle: TextStyle(
          fontSize: height / 60,
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
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          visualDensity: VisualDensity.compact,
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
    );
  }

  /// 다크 테마
  ThemeData appDarkTheme(double height) {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: Colors.black,
        primary: Colors.brown,
        onPrimary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xff322222),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: height / 40,
        ),
      ),
    );
  }
}
