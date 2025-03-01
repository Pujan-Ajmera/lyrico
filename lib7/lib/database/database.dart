import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ColorDatabase {
  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'color_db.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ColorTable(
            id INTEGER PRIMARY KEY,
            colorName TEXT NOT NULL
          )''');
        await db.insert("ColorTable", {"id": 1, "colorName": "green"});
      },
    );
    return db;
  }

  Future<String> getColor() async {
    Database db = await initDatabase();
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT colorName FROM ColorTable WHERE id = 1");
    if (result.isNotEmpty) {
      return result.first["colorName"];
    }
    return "green";
  }

  // Update the color
  Future<void> updateColor(String newColor) async {
    Database db = await initDatabase();
    await db.update(
      "ColorTable",
      {"colorName": newColor},
      where: "id = ?",
      whereArgs: [1],
    );
  }
}
