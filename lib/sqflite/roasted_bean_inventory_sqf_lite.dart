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

  /// 25-03-24
  ///
  /// 원두 재고 차감하기
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
  /// 로스팅 등록 취소하기 (inventory_weight 차감)
  Future revokeRecentInventoryRoasting(Map<String, int> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName WHERE id = ${values["roastedBeanID"]}");
        if (result.isNotEmpty) {
          int updateWeight = (result[0]["inventory_weight"]! as int) - (values["output_weight"] as int);
          final updateResult = await db.update(
            tableName,
            {"inventory_weight": updateWeight},
            where: "id = ?",
            whereArgs: [values["roastedBeanID"]],
          );
          return updateResult;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("😑 REVOKE RECENT INVENTORY ROASTING ERROR: $e");
      return null;
    }
  }

  /// 25-03-25
  ///
  /// 원두 재고 차감 취소하기 (판매 등록 취소)
  Future revokeDecreaseInventory(Map<String, int> values) async {
    try {
      final db = await openDB();
      if (db != null) {
        final result = await db.rawQuery("SELECT * FROM $tableName WHERE id = ${values["roastedBeanID"]}");
        if (result.isNotEmpty) {
          int updateWeight = (result[0]["inventory_weight"]! as int) + (values["salesWeight"] as int);
          final updateResult = await db.update(
            tableName,
            {"inventory_weight": updateWeight},
            where: "id = ?",
            whereArgs: [values["roastedBeanID"]],
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
  /// 원두 재고 삭제하기
  Future deleteRoastedBean(int id) async {
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
      debugPrint("😑 DELETE ROASTED BEAN ERROR: $e");
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
