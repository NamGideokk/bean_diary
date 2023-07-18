import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CoffeeBeansSqfLite {
  final int version = 1;
  static const String tableName = "coffee_beans";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "$tableName.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT NOT NULL, weight INTEGER, date TEXT NOT NULL, type TEXT NOT NULL)',
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
}
