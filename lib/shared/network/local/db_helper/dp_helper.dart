import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {

  static late Database database;

  static Future<void> initializeDatabase() async {

    String path = await getDatabasesPath();
    path = '$path/media.db';

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) {
        if (kDebugMode) {
          print('Create Database !!');
        }
        database
            .execute(
            'CREATE TABLE MEDIA (id INTEGER PRIMARY KEY,title TEXT, path TEXT,type TEXT,thumbnail TEXT)')
            .then((value) {
          if (kDebugMode) {
            print('Table MEDIA is Created');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print(error.toString());
          }
        });
      },
      onOpen: (database) {

        if (kDebugMode) {
          print('Database is Open');
        }
      },
    );
  }

  static Future<int> insertToDatabase({
    required int id,
    required String title,
    required String path,
    required String type,
    String? thumbnail,
  }) async {
    return database.rawInsert(
        'INSERT INTO MEDIA (id,title,path,type,thumbnail) VALUES (?,?,?,?,?)',
        [id, title, path,type,thumbnail]);
  }

  static Future<List<Map<String,dynamic>>> getIfIsFavourite({
  required int id,
}){
    return database.query(
      'MEDIA',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String,dynamic>>> getAllImages() async {
    return await database.query(
      'MEDIA',
      where: 'type = ?',
      whereArgs: ["image"],
    );
  }
  static Future<List<Map<String,dynamic>>> getAllVideos() async {
    return await database.query(
      'MEDIA',
      where: 'type = ?',
      whereArgs: ["video"],
    );
  }
  static Future<int> deleteRowFromDatabase(
      {
        required int id,
      }) {
    return database.rawDelete(
        'DELETE FROM MEDIA WHERE id = ?',[id]
    );
  }

}