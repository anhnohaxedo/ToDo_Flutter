import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/tables.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _db;
  DatabaseHelper._privateConstructor();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init('todo.db');
    return _db!;
  }

  Future<Database> _init(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _create);
  }

  Future _create(Database db, int version) async {
    await db.execute(''' CREATE TABLE task(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            priority INT,
            done BOOL,
            list_id INT)''');
    await db.execute(''' CREATE TABLE taskList(
            id INTEGER PRIMARY KEY,
            title TEXT,
            amount INTEGER,
            workload REAL)''');
  }

  // Handle Task DB.
  Future<void> insertTask(Task task) async {
    final db = await instance.db;
    await db.insert('task', task.toJson());
  }

  Future<void> updateTask(Task task) async {
    final db = await instance.db;
    await db.update(
      'task',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<Task> getTask(int id) async {
    final db = await instance.db;
    final maps = await db.query(
      'task',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<List<Task>> getTaskOfList(int? listId) async {
    final db = await instance.db;
    final result = await db.query(
      'task',
      where: 'list_id = ?',
      whereArgs: [listId],
    );
    return result.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> deleteTask(Task task) async {
    final db = await instance.db;
    await db.delete(
      'task',
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Handle TaskList DB.
  Future<void> insertList(TaskList list) async {
    final db = await instance.db;
    await db.insert('taskList', list.toJson());
  }

  Future<void> updateList(TaskList list) async {
    final db = await instance.db;
    await db.update('taskList', list.toJson(),
        where: 'id = ?', whereArgs: [list.id]);
  }

  Future<List<TaskList>> getIncompleteList() async {
    final db = await instance.db;
    final result = await db.query('taskList', where: 'workload < 1');
    return result.map((json) => TaskList.fromJson(json)).toList();
  }

  Future<List<TaskList>> getCompletedList() async {
    final db = await instance.db;
    final result = await db.query('taskList', where: 'workload = 1');
    return result.map((json) => TaskList.fromJson(json)).toList();
  }

  Future<void> deleteList(TaskList list) async {
    final db = await instance.db;
    await db.delete(
      'taskList',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [list.id],
    );
  }

  Future<void> close() async {
    final db = await instance.db;
    db.close();
  }
}
