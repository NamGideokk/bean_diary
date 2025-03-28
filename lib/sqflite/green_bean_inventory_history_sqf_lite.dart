import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GreenBeanInventoryHistorySqfLite {
  final int version = 1;
  static const String tableName = "green_bean_inventory_history";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, green_bean_id INTEGER NOT NULL, name TEXT NOT NULL, date TEXT NOT NULL, company TEXT NOT NULL, weight INTEGER NOT NULL)',
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

  /// 25-03-21
  ///
  /// 생두 재고 히스토리 등록
  /// * return int = 해당 히스토리의 id 값
  Future insertGreenBeanInventoryHistory(Map<String, dynamic> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.insert(tableName, values);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 INSERT GREEN BEAN INVENTORY HISTORY ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 재고 모든 히스토리 가져오기
  Future getAllInventoryHistories() async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName");
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 GET ALL INVENTORY HISTORIES ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 재고 히스토리 가져오기
  /// * 생두 id로 가져옴.
  Future getInventoryHistories(int id) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName WHERE green_bean_id = $id");
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 GET INVENTORY HISTORIES ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 재고 히스토리 삭제하기
  Future deleteHistory(int id) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.delete(
          tableName,
          where: "id = ?",
          whereArgs: [id],
        );
        return result > 0 ? result : null;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 DELETE HISTORY ERROR: $e");
      return null;
    }
  }

  /// 25-03-27
  ///
  /// 테이블 삭제하기
  Future deleteTable() async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.delete(tableName);
        return result;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 DELETE TABLE ERROR: $e");
      return null;
    }
  }
}
