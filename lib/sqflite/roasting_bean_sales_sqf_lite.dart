import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RoastingBeanSalesSqfLite {
  final int version = 1;
  static const String tableName = "roasting_bean_sales";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL, sales_weight INTEGER, company TEXT NOT NULL, date TEXT NOT NULL)',
          ),
          version: version,
        );
        // print("$tableName DB 생성 >>> $db");
        // print("===========================\n\n\n$tableName DB PATH >>> ${getDatabasesPath()}");
      } else {
        return null;
      }
      return db;
    } catch (e) {
      debugPrint("😑 OPEN $tableName DB ERROR: $e");
      return null;
    }
  }

  Future getRoastingBeanSales() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("😑 GET ROASTING BEAN SALES ERROR: $e");
      return [];
    }
  }

  /// 원두 판매 등록
  /// * type
  /// * name
  /// * sales_weight
  /// * company
  /// * date
  Future<int?> insertRoastedBeanSales(Map<String, String> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.insert(tableName, values);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 INSERT ROASTING BEAN SALES ERROR: $e");
      return null;
    }
  }

  /// 25-03-25
  ///
  /// 판매 내역 삭제하기
  Future deleteHistory(int id) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.delete(
          tableName,
          where: "id = ?",
          whereArgs: [id],
        );
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 DELETE HISTORY ERROR: $e");
      return null;
    }
  }
}
