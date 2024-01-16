import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databasename = 'expense. ';
  static final version = 1;

  static final _tablename = 'my_table';
  static final Colid = 'id';
  static final expenseName = 'name';
  static final expenseMoney = 'money';

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      try {
        _database = await initDatabase();
        return _database;
      } catch (e) {
        debugPrint('Error getting database: $e');
        return null;
      }
    }
  }

  initDatabase() async {
    try {
      Directory docDirectory = await getApplicationDocumentsDirectory();
      String path = join(docDirectory.path, _databasename);
      debugPrint(path);
      return openDatabase(path, version: version, onCreate: _onCreate);
    } catch (e) {
      debugPrint('Error initializing database: $e');
      throw Exception(e.toString());
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_tablename (
      $Colid INTEGER PRIMARY KEY,
      $expenseName TEXT NOT NULL,
      $expenseMoney INTEGER NOT NULL
    )
  ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      if (db != null) {
        return await db.insert(_tablename, row);
      } else {
        debugPrint('Insertion failed: Database is null');
        return 0;
      }
    } catch (e) {
      debugPrint('Insertion failed: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.database;
    if (db != null) {
      return await db.query(_tablename);
    } else {
      return [
        {Colid: 0, expenseName: 'No Data', expenseMoney: 0}
      ];
    }
  }

  Future<List<Map<String, dynamic>>> query(int id) async {
    Database? db = await instance.database;
    if (db != null) {
      List<Map<String, dynamic>> result =
          await db.query(_tablename, where: '$Colid = ?', whereArgs: [id]);
      return result;
    } else {
      return [
        {
          Colid: 0,
          expenseName: 'No Data',
          expenseMoney: 0,
        }
      ];
    }
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    if (db != null) {
      int id = row[Colid] ?? 0;
      return await db
          .update(_tablename, row, where: '$Colid = ?', whereArgs: [id]);
    } else {
      return 0;
    }
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    if (db != null) {
      return await db.delete(_tablename, where: '$Colid = ?', whereArgs: [id]);
    } else {
      return 0;
    }
  }
}
