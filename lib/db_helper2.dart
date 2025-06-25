import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_model.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT,
            embedding TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertUser(User user) async {
    final dbClient = await db;
    return await dbClient.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    final dbClient = await db;
    final result = await dbClient.query('users');
    return result.map((e) => User.fromMap(e)).toList();
  }
}
