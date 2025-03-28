import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GreenBeansSqfLite {
  final int version = 1;
  static const String tableName = "green_beans";
  Database? db;

  Future<Database?> openDB() async {
    try {
      if (db == null) {
        db = await openDatabase(
          join(await getDatabasesPath(), "green_beans.db"),
          onCreate: (db, version) => db.execute(
            'CREATE TABLE green_beans(id INTEGER PRIMARY KEY, name TEXT NOT NULL)',
          ),
          version: version,
        );
        // print("green_beans DB 생성 >>> $db");
        // print("===========================\n\n\ngreen_beans DB PATH >>> ${getDatabasesPath()}");
      } else {
        return null;
      }
      return db;
    } catch (e) {
      debugPrint("😑 OPEN green_beans DB ERROR: $e");
      return null;
    }
  }

  Future getGreenBeans() async {
    try {
      final db = await openDB();
      if (db != null) {
        final List result = await db.query(tableName);
        return result;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("😑 GET GREEN BEANS ERROR: $e");
      return [];
    }
  }

  /// 생두 DB 등록
  ///
  /// return
  /// * 0: DB is Null or 실패,
  /// * 1: 등록 성공
  /// * 2: 중복으로 실패
  Future insertGreenBean(Map<String, String> value) async {
    try {
      final db = await openDB();
      if (db != null) {
        var duplicateCheck = await db.rawQuery("SELECT * FROM $tableName WHERE name = '${value["name"]}'");
        if (duplicateCheck.isNotEmpty) {
          return 2;
        } else {
          await db.insert(tableName, value);
          return 1;
        }
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("😑 INSERT GREEN BEAN ERROR: $e");
      return 0;
    }
  }

  Future deleteGreenBean(String value) async {
    try {
      final db = await openDB();
      if (db != null) {
        var result = await db.delete(
          tableName,
          where: 'name = ?',
          whereArgs: [value],
        );
        return result == 1 ? true : false;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("😑 DELETE GREEN BEAN ERROR: $e");
      return false;
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
