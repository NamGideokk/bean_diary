import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GreenBeanInventorySqfLite {
  final int version = 1;
  static const String tableName = "green_bean_inventory";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT NOT NULL, inventory_weight INTEGER NOT NULL)',
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

  Future getGreenBeanInventory() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("😑 GET GREEN BEAN INVENTORY ERROR: $e");
      return [];
    }
  }

  /// 생두 재고 등록
  ///
  /// * return int = 해당 생두의 id 값
  Future<int?> insertGreenBeanInventory(Map<String, dynamic> values) async {
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
      debugPrint("😑 INSERT GREEN BEAN INVENTORY ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 재고 차감하기
  Future decreaseInventory(Map<String, dynamic> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final findBean = await db.rawQuery("SELECT * FROM $tableName WHERE name = '${values["name"]}'");
        if (findBean.isNotEmpty) {
          final updateInventoryWeight = await db.update(
            tableName,
            {"inventory_weight": (findBean[0]["inventory_weight"] as int) - (values["weight"] as int)},
            where: "id = ?",
            whereArgs: [findBean[0]["id"]],
          );
          return findBean[0]["id"];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 DECREASE INVENTORY ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 입고 등록 취소하기 (inventory_weight 차감)
  Future revokeRecentInventoryEntry(Map<String, int> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName WHERE id = ${values["greenBeanID"]}");
        if (result.isNotEmpty) {
          int updateWeight = (result[0]["inventory_weight"]! as int) - (values["weight"] as int);
          final updateResult = await db.update(
            tableName,
            {"inventory_weight": updateWeight},
            where: "id = ?",
            whereArgs: [values["greenBeanID"]],
          );
          return updateResult;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 REVOKE RECENT INVENTORY ENTRY ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 재고 차감 취소하기
  Future revokeDecreaseInventory(Map<String, int> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName WHERE id = ${values["greenBeanID"]}");
        if (result.isNotEmpty) {
          int updateWeight = (result[0]["inventory_weight"]! as int) + (values["input_weight"] as int);
          final updateResult = await db.update(
            tableName,
            {"inventory_weight": updateWeight},
            where: "id = ?",
            whereArgs: [values["greenBeanID"]],
          );
          return updateResult;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 REVOKE RECENT DECREASE INVENTORY ERROR: $e");
      return null;
    }
  }

  /// 25-03-24
  ///
  /// 생두 입고 내역 삭제
  Future deleteGreenBeanEntry(int id) async {
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
      debugPrint("😑 DELETE GREEN BEAN ENRTY ERROR: $e");
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
