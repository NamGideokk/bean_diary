import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// RoastingSingleStockSqfList
class RoastingSingleStockSqfList {
  final int version = 1;
  static const String tableName = "roasting_single_stock_sqf_lite";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, type TEXT NOT NULL, name TEXT NOT NULL, roasting_weight INTEGER, date TEXT NOT NULL)',
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

  Future insertRoastingSingleStock(Map<String, String> value) async {
    try {
      final db = await openDB();
      if (db != null) {
        await db.insert(tableName, value);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("😑 INSERT $tableName ERROR: $e");
      return false;
    }
  }
}
