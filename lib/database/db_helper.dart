import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todos/model/todos.dart';

class DBHelper {
  static Database? _db;
  static const String table = 'Todos';
  static const String dbName = 'todos.db';
  static const String id = 'id';
  static const String content = 'content';
  static const String isDone = 'isDone';

  Future<Database> get db async => _db ??= await initDB();

  initDB() async {
    _db = await openDatabase(join(await getDatabasesPath(), dbName),
        version: 1, onCreate: _onCreate);
    return _db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "Create TABLE $table ($id INTEGER PRIMARY KEY, $content TEXT, $isDone INTEGER)");
  }

  Future<Todos> save(Todos todo) async {
    var dbClient = await db;
    todo.id = await dbClient.insert(table, todo.toMap());
    return todo;
  }

  Future<List<Todos>> getAllTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(table, columns: [id, content, isDone]);
    List<Todos> todos = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        todos.add(Todos.fromMap(maps[i]));
      }
    }
    return todos;
  }

  Future<List<Todos>> getAllUnDoneTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      table,
      columns: [id, content, isDone],
      where: '$isDone = 0',
    );
    List<Todos> todos = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        todos.add(Todos.fromMap(maps[i]));
      }
    }
    return todos;
  }

  Future<List<Todos>> getAllDoneTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(
      table,
      columns: [id, content, isDone],
      where: '$isDone = 1',
    );
    List<Todos> todos = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        todos.add(Todos.fromMap(maps[i]));
      }
    }
    return todos;
  }

  Future<int> update(Todos todo) async {
    var dbClient = await db;
    return await dbClient
        .update(table, todo.toMap(), where: '$id = ?', whereArgs: [todo.id]);
  }

  @override
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
