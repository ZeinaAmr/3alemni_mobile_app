import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, 'app_database.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
      throw Exception("Failed to initialize database");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL,
          role TEXT NOT NULL
        )
      ''');

      // Insert a test user for debugging
      await db.insert('users', {
        'email': 'test@example.com',
        'password': 'test123',
        'role': 'Admin'
      });

      print("Database tables created successfully");
    } catch (e) {
      print("Error creating tables: $e");
      throw Exception("Failed to create database tables");
    }
  }

  Future<int> insertUser(User user) async {
    try {
      final db = await database;
      return await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Error inserting user: $e");
      throw Exception("Failed to insert user");
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final db = await database;
      final results = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
        limit: 1,
      );

      if (results.isNotEmpty) {
        return User.fromMap(results.first);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      throw Exception("Failed to fetch user");
    }
  }

  Future<void> close() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
    } catch (e) {
      print("Error closing database: $e");
    }
  }
}