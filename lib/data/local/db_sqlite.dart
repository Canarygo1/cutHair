import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../model/user.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';

class DBProvider {
  static Database _db = null;
  static final DBProvider db = DBProvider._private();

  DBProvider._private();

  Future<Database> get database async {
    if (_db != null)
      return _db;
    else
      _db = await initDB();

    return _db;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'CurrentUserDB.db');
    print(1);
    print(path);
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE User ('
          'surname TEXT,'
          'name TEXT,'
          'email TEXT,'
          'phone TEXT,'
          'permission INTEGER,'
          'uid TEXT PRIMARY KEY'
          ')');
    });
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  insert(User user) async {
    final databaseObject = await database;
    await databaseObject.insert("User", user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(User user) async => await _db
      .update("User", user.toMap(), where: 'name = ?', whereArgs: [user.name]);

  Future<int> delete(User user) async {
    final databaseObject = await database;
    List<Map<String, dynamic>> lista = null;
    lista = await databaseObject.rawQuery("DELETE FROM User");
  }

  Future<User> getUser() async {
    final databaseObject = await database;
    List<Map<String, dynamic>> lista =
        await databaseObject.rawQuery('SELECT * FROM User');
    List<User> listaNueva = List.generate(lista.length, (i) {
      return User(lista[i]['surname'], lista[i]['name'], lista[i]['email'],
          lista[i]['permission'], lista[i]['phone'], lista[i]['uid']);
    });

    for (var name in lista) {
      print(name);
    }
  }

  static closeDB() async {
    _db.close();
  }
}
