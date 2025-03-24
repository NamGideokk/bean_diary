import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RoastedBeanInventorySqfLite {
  final int version = 1;
  static const String tableName = "roasted_bean_inventory";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL, inventory_weight INTEGER)',
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
      print("😑 OPEN $tableName DB ERROR: $e");
      return null;
    }
  }

  Future getRoastedBeanInventory() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("😑 GET ROASTED BEAN INVENTORY ERROR: $e");
      return [];
    }
  }

  /// 원두 재고 등록
  ///
  /// * return int = 해당 원두의 id 값
  Future<int?> insertRoastedBeanInventory(Map<String, dynamic> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final List findDuplicate = await db.rawQuery("SELECT * FROM $tableName WHERE name = '${values["name"]}'");
        if (findDuplicate.isEmpty) {
          final result = await db.insert(tableName, values);
          return result;
        } else {
          final updateInventoryWeight = await db.update(
            tableName,
            {"inventory_weight": findDuplicate[0]["inventory_weight"] + values["inventory_weight"]},
            where: "id = ?",
            whereArgs: [findDuplicate[0]["id"]],
          );
          return findDuplicate[0]["id"];
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 INSERT ROASTED BEAN INVENTORY ERROR: $e");
      return null;
    }
  }
}
