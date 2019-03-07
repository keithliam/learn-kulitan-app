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
          CREATE TABLE Syllable (
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
    await db.execute('INSERT INTO Syllable VALUES ("a", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("i", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("u", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("e", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("o", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ga", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gi", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ge", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("go", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("gang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ka", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ká", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ki", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("kí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ku", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("kú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ke", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ko", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("kang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ta", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("tá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ti", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("tí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("tu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("tú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("te", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("to", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("tang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("da", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("dá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("di", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("dí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("du", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("dú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("de", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("do", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("dang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("na", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ná", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ni", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ní", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("nu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("nú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ne", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("no", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("nang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("la", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("li", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("le", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lo", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("lang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("sa", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("sá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("si", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("sí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("su", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("sú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("se", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("so", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("sang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ma", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("má", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mi", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("me", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mo", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("mang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pa", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pi", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pe", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("po", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("pang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ba", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bi", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("be", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bo", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("bang", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("nga", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngá", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngi", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngí", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngu", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngú", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("nge", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngo", 0, 0)');
    await db.execute('INSERT INTO Syllable VALUES ("ngang", 0, 0)');
  }
}
