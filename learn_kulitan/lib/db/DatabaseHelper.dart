import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class DatabaseHelper {
  DatabaseHelper._constructor();
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  static final _databaseName = "LearnKulitan.db";
  static final _databaseVersion = 1;

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // await deleteDatabase(path); // TODO: remove
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Page (
            name TEXT PRIMARY KEY,
            overall_progress INTEGER NOT NULL,
            current_batch INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE Character (
            name TEXT PRIMARY KEY,
            progress_count_reading INTEGER NOT NULL,
            progress_count_writing INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE CurrentQuiz (
            type TEXT PRIMARY KEY,
            one text,
            two text,
            three text,
            four text
          )
          ''');
    await db.execute('INSERT INTO Page VALUES ("reading", 0, 0)');
    await db.execute('INSERT INTO Page VALUES ("writing", 0, 0)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("cards", null, null, null, null)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("choices", null, null, null, null)');
    await db.execute('INSERT INTO Character VALUES ("a", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("i", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("u", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("e", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("o", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ga", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gi", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ge", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("go", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("gang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ka", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ká", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ki", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("kí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ku", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("kú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ke", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ko", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("kang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ta", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("tá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ti", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("tí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("tu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("tú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("te", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("to", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("tang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("da", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("dá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("di", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("dí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("du", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("dú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("de", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("do", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("dang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("na", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ná", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ni", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ní", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("nu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("nú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ne", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("no", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("nang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("la", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("li", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("le", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lo", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("lang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("sa", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("sá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("si", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("sí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("su", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("sú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("se", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("so", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("sang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ma", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("má", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mi", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("me", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mo", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("mang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pa", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pi", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pe", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("po", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("pang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ba", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bi", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("be", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bo", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("bang", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("nga", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngá", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngi", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngí", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngu", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngú", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("nge", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngo", 0, 0)');
    await db.execute('INSERT INTO Character VALUES ("ngang", 0, 0)');
  }
}
