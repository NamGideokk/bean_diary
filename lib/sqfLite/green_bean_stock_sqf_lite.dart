import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GreenBeanStockSqfLite {
  final int version = 1;
  static const String tableName = "green_bean_stock";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT NOT NULL, weight INTEGER, date TEXT NOT NULL, company TEXT NOT NULL)',
          ),
          version: version,
        );
        print("$tableName DB 생성 >>> $db");
        print("===========================\n\n\n$tableName DB PATH >>> ${getDatabasesPath()}");
      } else {
        return null;
      }
      return db;
    } catch (e) {
      print("😑 OPEN $tableName DB ERROR: $e");
      return null;
    }
  }

  Future getGreenBeanStock() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        print(result);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      print("😑 GET GREEN BEAN STOCK ERROR: $e");
      return [];
    }
  }

  Future insertGreenBeanStock(Map<String, String> value) async {
    try {
      final db = await openDB();
      if (db != null) {
        List? findWeight = await db.rawQuery(
          "SELECT weight FROM $tableName WHERE name = ?",
          [value["name"]],
        );
        if (findWeight.isNotEmpty) {
          int beforeWeight = findWeight[0]["weight"];
          await db.rawUpdate(
            "UPDATE $tableName SET `weight` = ? WHERE name = ?",
            [
              beforeWeight + int.parse(value["weight"]!),
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
      print("😑 INSERT GREEN BEAN STOCK ERROR: $e");
      return false;
    }
  }

  Future updateWeightGreenBeanStock(Map<String, String> value) async {
    print("⚽️ 무 게 업 데 이 트 실 행");
    print("V  A  L  U  E : $value");
    try {
      final db = await openDB();
      if (db != null) {
        List? findWeight = await db.rawQuery(
          "SELECT weight FROM $tableName WHERE name = ?",
          [value["name"]],
        );
        if (findWeight.isNotEmpty) {
          int beforeWeight = findWeight[0]["weight"];
          await db.rawUpdate(
            "UPDATE $tableName SET `weight` = ? WHERE name = ?",
            [
              beforeWeight - int.parse(value["weight"]!),
              value["name"],
            ],
          );
          print("WEIGHTㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ\n$beforeWeight ,,,,,,,,,,, ${int.parse(value["weight"]!)}");
          return true;
        } else {
          await db.insert(tableName, value);
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("😑 UPDATE WEIGHT GREEN BEAN STOCK ERROR: $e");
      return false;
    }
  }
}
