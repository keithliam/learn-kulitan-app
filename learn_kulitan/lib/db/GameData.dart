import 'dart:io' show Directory;
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

class GameData {
  static final GameData _instance = GameData._internal();
  factory GameData() => _instance;
  GameData._internal();

  Future<void> initStorage() async {
    _db = await _DatabaseHelper.instance.database;
    _prefs = await _PreferencesHelper.instance.preferences;
    if (_prefs.getBool('introTutorial') == null) await _initPrefs();
    await _getGameData();
  }

  Database _db;
  SharedPreferences _prefs;
  Map<String, dynamic> _data = {};

  bool getTutorial(String page) => _data[page]['tutorial'];
  int getOverallProgress(String page) => _data[page]['progress']['overall_progress'];
  int getBatch(String page) => _data[page]['progress']['current_batch'];
  bool getReadingMode() => _data['reading']['mode'];
  Map<String, String> getCards(String page) => _data[page]['cards'];
  Map<String, String> getChoices() => _data['reading']['choices'];
  int getGlyphProgress(String page, String glyph) => _data[page]['glyphs'][glyph];
  Map<String, int> getGlyphProgressList(String page) => _data[page]['glyphs'];
  
  void setTutorial(String page, bool i) {
    _data[page]['tutorial'] = i;
    _prefs.setBool('${page}Tutorial', i);
  }
  void setBatch(String page, int batch) {
    _db.update('Page', { 'current_batch': batch }, where: 'name = "$page"');
    _data[page]['progress']['current_batch'] = batch;
  }
  void setOverallProgress(String page, int progress) {
    _db.update('Page', { 'overall_progress': progress }, where: 'name = "$page"');
    _data[page]['progress']['overall_progress'] = progress;
  }
  void setMode(bool mode) {
    _db.update('CurrentQuiz', { 'kulitanMode': mode }, where: 'type = "mode"');
    _data['reading']['mode'] = mode;
  }
  void setGlyphProgress(String page, String glyph, int progress) {
    _db.update('Glyph', { 'progress_count_$page': progress }, where: 'name = "$glyph"');
    _data[page]['glyphs'][glyph] = progress;
  }
  void setCards(String page, Map<String, String> _cards) {
    _db.update('Current${page == 'reading'? 'Quiz' : 'Draw'}', _cards, where: 'type = "cards"');
    _cards.forEach((String key, String value) => _data[page]['cards'][key] = value);
  }
  void setChoices(Map<String, String> _choices) {
    _db.update('CurrentQuiz', _choices, where: 'type = "choices"');
    _choices.forEach((String key, String value) => _data['reading']['choices'][key] = value);
  }

  Future<void> _getGameData() async {
    _data['intro'] = {};
    _data['reading'] = {};
    _data['writing'] = {};
    _data['transcribe'] = {};
    _data['intro']['tutorial'] = _prefs.getBool('introTutorial');
    _data['reading']['tutorial'] = _prefs.getBool('readingTutorial');
    _data['writing']['tutorial'] = _prefs.getBool('writingTutorial');
    _data['transcribe']['tutorial'] = _prefs.getBool('transcribeTutorial');
    _data['reading']['progress'] = Map<String, int>.from((await _db.query('Page', columns: ['overall_progress', 'current_batch'], where: 'name = "reading"'))[0]);
    _data['writing']['progress'] = Map<String, int>.from((await _db.query('Page', columns: ['overall_progress', 'current_batch'], where: 'name = "writing"'))[0]);
    _data['reading']['mode'] = (await _db.query('CurrentQuiz', columns: ['kulitanMode'], where: 'type = "mode"'))[0]['kulitanMode'] == 'true';
    _data['reading']['cards'] = Map<String, String>.from((await _db.query('CurrentQuiz', where: 'type = "cards"'))[0]);
    _data['writing']['cards'] = Map<String, String>.from((await _db.query('CurrentDraw', where: 'type = "cards"'))[0]);
    _data['reading']['choices'] = Map<String, String>.from((await _db.query('CurrentQuiz', where: 'type = "choices"'))[0]);
    final List<Map<String, dynamic>> _glyphData = await _db.query('Glyph');
    _data['reading']['glyphs'] = Map<String, int>.fromIterable(_glyphData, key: (glyph) => glyph['name'], value: (glyph) => glyph['progress_count_reading']);
    _data['writing']['glyphs'] = Map<String, int>.fromIterable(_glyphData, key: (glyph) => glyph['name'], value: (glyph) => glyph['progress_count_writing']);
  }

  Future<void> _initPrefs() async {
    await _prefs.setBool('introTutorial', true);
    await _prefs.setBool('readingTutorial', true);
    await _prefs.setBool('writingTutorial', true);
    await _prefs.setBool('transcribeTutorial', true);
  }
}

class _PreferencesHelper {
  const _PreferencesHelper._constructor();
  static final _PreferencesHelper instance = _PreferencesHelper._constructor();

  static SharedPreferences _preferences;
  Future<SharedPreferences> get preferences async {
    if (_preferences != null) return _preferences;
    else _preferences = await SharedPreferences.getInstance();
    if (_preferences.getBool('IntroTutorial') == null) await _initPrefs();
    return _preferences;
  }

  Future<void> _initPrefs() async {
    await _preferences.setBool('IntroTutorial', true);
    await _preferences.setBool('ReadingTutorial', true);
    await _preferences.setBool('WritingTutorial', true);
    await _preferences.setBool('TranscribeTutorial', true);
  }
}

class _DatabaseHelper {
  const _DatabaseHelper._constructor();
  static final _DatabaseHelper instance = _DatabaseHelper._constructor();

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
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Page (
            name TEXT(10) PRIMARY KEY,
            overall_progress INTEGER NOT NULL,
            current_batch INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE Glyph (
            name TEXT(10) PRIMARY KEY,
            progress_count_reading INTEGER NOT NULL,
            progress_count_writing INTEGER NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE CurrentQuiz (
            type TEXT(10) PRIMARY KEY,
            one text,
            two text,
            three text,
            four text,
            kulitanMode text
          )
          ''');
    await db.execute('''
          CREATE TABLE CurrentDraw (
            type TEXT(10) PRIMARY KEY,
            one text,
            two text
          )
          ''');
    await db.execute('INSERT INTO Page VALUES ("reading", 0, 0)');
    await db.execute('INSERT INTO Page VALUES ("writing", 0, 0)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("mode", null, null, null, null, "true")');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("cards", null, null, null, null, null)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("choices", null, null, null, null, null)');
    await db.execute('INSERT INTO CurrentDraw VALUES ("cards", null, null)');
    await db.execute('INSERT INTO Glyph VALUES ("a", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("i", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("u", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("e", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("o", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ga", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gi", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ge", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("go", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("gang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ka", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ká", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ki", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("kí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ku", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("kú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ke", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ko", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("kang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ta", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("tá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ti", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("tí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("tu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("tú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("te", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("to", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("tang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("da", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("dá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("di", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("dí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("du", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("dú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("de", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("do", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("dang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("na", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ná", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ni", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ní", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("nu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("nú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ne", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("no", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("nang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("la", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("li", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("le", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lo", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("lang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("sa", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("sá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("si", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("sí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("su", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("sú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("se", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("so", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("sang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ma", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("má", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mi", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("me", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mo", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("mang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pa", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pi", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pe", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("po", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("pang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ba", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bi", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("be", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bo", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("bang", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("nga", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngá", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngi", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngí", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngu", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngú", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("nge", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngo", 0, 0)');
    await db.execute('INSERT INTO Glyph VALUES ("ngang", 0, 0)');
  }
}