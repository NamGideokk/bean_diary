import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GreenBeanSqfLite {
  final int version = 1;
  static const String tableName = "green_beans";
  Database? db;

  Future<Database?> openDB() async {
    if (db == null) {
      db = await openDatabase(
        join(await getDatabasesPath(), "green_beans.db"),
        onCreate: (db, version) => db.execute('CREATE TABLE green_beans(id INTEGER PRIMARY KEY, name TEXT NOT NULL)'),
        version: version,
      );
      print("green_beans DB 생성 >>> $db");
      print("===========================\n\n\ngreen_beans DB PATH >>> ${getDatabasesPath()}");
    }
    return db;
  }

  Future getGreenBeans() async {
    final db = await openDB();
    if (db != null) {
      final List result = await db.query(tableName);
      print("GET GREEN BEANS DB RESULT ::: $result");
      return result;
    } else {
      print("GREEN BEANS DB IS NULL");
      return [];
    }
  }

  Future insertGreenBean(Map<String, String> value) async {
    final db = await openDB();
    if (db != null) {
      await db.insert(tableName, value);
      return true;
    } else {
      return false;
    }
  }
}
