import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'tasks';
  static final _CategoryTableName = 'categorytable';


  static Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDb();
    return _database;
  }

  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  static Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static void _onCreate(Database db, int newVersion) async {
    await db.execute(
        '''CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            description TEXT, 
            startDate TEXT, 
            endDate TEXT, 
            status TEXT, 
            category TEXT, 
            priority TEXT)
            ''',);
    await db.execute(
        '''
         CREATE TABLE $_CategoryTableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            categoryname TEXT NOT NULL UNIQUE
            )
        ''',
        );
    // Add more table creation statements if needed
  }


  // static Future<Database> initDatabase() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'task_database.db'),
  //     onCreate: (db, version) {
  //       return db.execute(
  //         '''CREATE TABLE $_tableName(
  //           id INTEGER PRIMARY KEY AUTOINCREMENT, 
  //           title TEXT, 
  //           description TEXT, 
  //           startDate TEXT, 
  //           endDate TEXT, 
  //           status TEXT, 
  //           category TEXT, 
  //           priority TEXT)
  //           ''',
  //       );

  //     },
  //     version: 1,
  //   );
  // }

  static Future<List<String>> getGategoriesList() async {
    final Database? db = await database;
    List<Map<String, dynamic>> result = await db!.query('$_CategoryTableName');
    return result.map((map) => map['categoryname'] as String).toList();
  }

  static Future<void> insertCategory(Map<String, dynamic> cat) async {
    final Database? db = await database;
    await db!.insert(
      _CategoryTableName,
      cat,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteCategory(int id) async {
    final Database? db = await database;
    await db!.delete(
      _CategoryTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final Database? db = await database;
    return db!.query(_CategoryTableName);
  }


  static Future<void> insertTask(Map<String, dynamic> task) async {
    final Database? db = await database;
    await db!.insert(
      _tableName,
      task,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTask(Map<String, dynamic> task) async {
    final Database? db = await database;
    await db!.update(
      _tableName,
      task,
      where: 'id = ?',
      whereArgs: [task['id']],
    );
  }

  static Future<void> deleteTask(int id) async {
    final Database? db = await database;
    await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final Database? db = await database;
    return db!.query(_tableName);
  }


  static Future<Map<String, dynamic>?> getRecordById(int id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Return the first record if found, otherwise return null
    return results.isNotEmpty ? results.first : null;
  }

  static Future<List<Map<String, dynamic>>> getRecordByCategory(String catName) async {
    final Database? db = await database;
    // List<Map<String, dynamic>> results = await db!.query(
    //   'tasks',
    //   where: 'category = ?',
    //   whereArgs: [catName],
    // );

    // Return the first record if found, otherwise return null
    return db!.query('tasks', where: 'category = ?', whereArgs: [catName],);
  }
  
}


// class DatabaseHelper {
//   static const dbName = "todoDatabase.db";
//   static const dbVersion = 1;
//   static const dbTaskTable = "taskTable";
//   static const dbCategoryTable = "category_todo";

//   static const taskId = 'taskId';
//   static const taskTitle = "title";
//   static final startDate = "startDate";
//   static final endDate = "endDate";
//   static const taskDesc = "description";
//   static const status = 'status';
//   static const priority = 'priority';

//   static const taskCategory = "category";
//   static const categoryID = 'categoryID';
//   static const categoryTitle = 'categoryTitle';
//   // constructor
//   static final DatabaseHelper instance = DatabaseHelper();

//   // database initialize
//   static Database? _database;

//   Future<Database?> get database async {
//     _database ??= await initDB();
//     return _database;
//     // if(_database != null) return _database;


//     // _database = await initDB();
//     // return _database;
//   }

//   initDB() async {
//     Directory directory = await getApplicationCacheDirectory();
//     String path = join(directory.path, dbName);
//     return await openDatabase(path, version: dbVersion, onCreate: onCreate);
//   }

//   Future onCreate(Database db, int version) async {
//     db.execute('''
//         CREATE TABLE $dbTaskTable (
//          $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
//          $taskTitle TEXT,
//          $taskDesc TEXT,
//          $startDate TEXT,
//          $endDate TEXT,
//          $status TEXT,
//          $taskCategory TEXT,
//          $priority TEXT,
//         );
         
//       ''');
//   }

//   insertRecord(Map<String, dynamic> row) async {
//     Database? db = await instance.database;
//     return db?.insert(dbTaskTable, row);
//   }

//   Future<List<Map<String, dynamic>>?> queryRecord() async {
//     Database? db = await instance.database;
//     return await db?.query(dbTaskTable);
//   }
// }

// enum myStatus { todo, doing, done }
// enum myPriorities {low, medium, high, imp}