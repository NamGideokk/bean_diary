import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RoastingBeanStockSqfLite {
  final int version = 1;
  static const String tableName = "roasting_bean_stock";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL, roasting_weight INTEGER, history TEXT NOT NULL)',
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

  Future getRoastingBeanStock() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print("😑 GET ROASTING BEAN STOCK ERROR: $e");
      return [];
    }
  }

  Future insertRoastingBeanStock(Map<String, String> value) async {
    try {
      final db = await openDB();
      if (db != null) {
        List? findWeight = await db.rawQuery(
          "SELECT roasting_weight, history FROM $tableName WHERE name = ?",
          [value["name"]],
        );
        if (findWeight.isNotEmpty) {
          int beforeWeight = findWeight[0]["roasting_weight"];
          List decodeHistory = jsonDecode(findWeight[0]["history"]);
          List insertHistory = jsonDecode(value["history"]!);
          await db.rawUpdate(
            "UPDATE $tableName SET `roasting_weight` = ?, 'history' = ? WHERE name = ?",
            [
              beforeWeight + int.parse(value["roasting_weight"]!),
              jsonEncode([...decodeHistory, ...insertHistory]),
              value["name"],
            ],
          );
          return true;
        } else {
          await db.insert(tableName, value);
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("😑 INSERT $tableName ERROR: $e");
      return false;
    }
  }

  Future updateWeightRoastingBeanStock(Map<String, String> value) async {
    try {
      final db = await openDB();
      if (db != null) {
        List? findWeight = await db.rawQuery(
          "SELECT roasting_weight FROM $tableName WHERE name = ?",
          [value["name"]],
        );
        if (findWeight.isNotEmpty) {
          int beforeWeight = findWeight[0]["roasting_weight"];
          await db.rawUpdate(
            "UPDATE $tableName SET `roasting_weight` = ? WHERE name = ?",
            [
              beforeWeight - int.parse(value["sales_weight"]!),
              value["name"],
            ],
          );
          return true;
        } else {
          await db.insert(tableName, value);
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("😑 UPDATE WEIGHT ROASTING BEAN STOCK ERROR: $e");
      return false;
    }
  }
}
