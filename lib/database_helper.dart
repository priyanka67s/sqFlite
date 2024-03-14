
import 'package:sqflite/sqflite.dart' as sql;

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? db;



  //open
static Future openDatabase() async{
  return sql.openDatabase(
    'contact.db', version: 1,
    onCreate: (sql.Database database, int version) async{
      await createTables(database);
    });
}
// create table
 static Future createTables(sql.Database database) async
 {
  await database.execute("""CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
     title TEXT,
     description TEXT,
     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
  """);
 }
 //  Create new items, map- key value storing
static Future<int> createItem(String title, String description) async{
  final db = await DatabaseHelper.openDatabase();
  final data = {'title': title,'description': description}; //map datatype
  final id = await db!.insert('items', data,
  conflictAlgorithm: sql.ConflictAlgorithm.replace);//keys
  return id;
}
//List<String> image=["]
//read
static Future<List<Map<String,dynamic>>> getItems() async{
  final db = await DatabaseHelper.openDatabase();
  return db!.query('items', orderBy: 'id');
}
 //update
static Future<int> updateItem(int id, String title, String description) async{
  final db = await DatabaseHelper.openDatabase();
  final data ={'title': title, 'description': description,
    'createdAt': DateTime.now().toString()};
  final result = await db!.update('items', data, where: "id=?",whereArgs: [id]);
  return result;
}
//delete
static Future deleteItem(int id) async{
  final db = await DatabaseHelper.openDatabase();
  await db!.delete('items', where: "id=?", whereArgs: [id]);
}
//close
static Future closeDatabase() async{
  await db!.close();
}
}
//crud function