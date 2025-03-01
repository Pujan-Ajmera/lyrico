import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDatabase {
  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'lyrics.db');
    var db = await openDatabase(path, onCreate: (db, version) async {
      await db.execute('''
          create table Lyrics(
           lyrics_id INTEGER PRIMARY KEY AUTOINCREMENT,
           artist_names TEXT NOT NULL,
           full_title TEXT NOT NULL,
           header_image_thumbnail_url TEXT NOT NULL,
           lyrics TEXT NOT NULL
          )''');
    }, onUpgrade: (db, oldVersion, newVersion) {}, version: 1);
    return db;
  }

  Future<List<Map<String, dynamic>>> selectAllLyrics() async {
    Database db = await initDatabase();
    return await db.rawQuery("select * from Lyrics");
  }

  Future<void> insertLyrics(Map<String, dynamic> lyrics) async {
    try {
      Database db = await initDatabase();
      int id = await db.insert("Lyrics", lyrics);
      print("Inserted Lyrics with ID: $id");
    } catch (e) {
      print("Error inserting lyrics: $e");
    }
  }


  Future<void> deleteLyrics(int lyrics_id) async {
    Database db = await initDatabase();
    int id = await db.delete("Lyrics",where: "lyrics_id = ?",whereArgs: [lyrics_id]);
    print("Deleted Lyrics with ID: $lyrics_id");
  }

  Future<void> deleteAllLyrics() async {
    Database db = await initDatabase();
    await db.delete("Lyrics");
    await db.execute("VACUUM"); // resets the auto increment id
  }


}