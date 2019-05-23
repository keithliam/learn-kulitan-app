import 'dart:io' show Directory;
import 'dart:collection' show HashSet;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import '../styles/theme.dart';

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
  static final HashSet<String> _colorset = HashSet.from(['primary', 'accent', 'foreground', 'kulitanPath', 'empty', 'correctAnswer', 'wrongAnswer', 'quizCardMiddle', 'quizCardLast', 'white', 'tutorialsOverlayBackground', 'cardShadow', 'buttonShadow']);

  List<String> getUnlockedColorSchemes() => _data['colors']['unlockedSchemes'];
  Color getColor(String color) {
    if (_colorset.contains(color))
      return Color(_data['colors'][color]);
    else if (color == 'backToStartFABPressed')
      return Color.lerp(Color(_data['colors']['white']), Color(_data['colors']['foreground']), 0.2);
    else {
      if (color == 'background') return Color(_data['colors']['primary']);
      else if (color == 'loaderStroke') return Color(_data['colors']['white']);
      else if (color == 'loaderStrokeShadow') return Color(_data['colors']['accent']);
      else if (color == 'loaderBackground') return Color(_data['colors']['primary']);
      else if (color == 'headerNavigation') return Color(_data['colors']['white']);
      else if (color == 'circularProgressText') return Color(_data['colors']['white']);
      else if (color == 'circularProgressForeground') return Color(_data['colors']['accent']);
      else if (color == 'circularProgressBackground') return Color(_data['colors']['white']);
      else if (color == 'linearProgressForeground') return Color(_data['colors']['accent']);
      else if (color == 'linearProgressBackground') return Color(_data['colors']['empty']);
      else if (color == 'writingHeaderProgressBG') return Color(_data['colors']['white']);
      else if (color == 'customSwitch') return Color(_data['colors']['white']);
      else if (color == 'customSwitchToggle') return Color(_data['colors']['accent']);
      else if (color == 'cardDefault') return Color(_data['colors']['white']);
      else if (color == 'buttonDefault') return Color(_data['colors']['white']);
      else if (color == 'cardQuiz1') return Color(_data['colors']['white']);
      else if (color == 'cardQuiz2') return Color(_data['colors']['quizCardMiddle']);
      else if (color == 'cardQuiz3') return Color(_data['colors']['quizCardLast']);
      else if (color == 'cardChoices') return Color(_data['colors']['white']);
      else if (color == 'cardChoicesText') return Color(_data['colors']['foreground']);
      else if (color == 'cardChoicesRight') return Color(_data['colors']['correctAnswer']);
      else if (color == 'cardChoicesRightText') return Color(_data['colors']['foreground']);
      else if (color == 'cardChoicesWrong') return Color(_data['colors']['wrongAnswer']);
      else if (color == 'cardChoicesWrongText') return Color(_data['colors']['white']);
      else if (color == 'writingGuide') return Color(_data['colors']['accent']);
      else if (color == 'writingDraw') return Color(_data['colors']['kulitanPath']);
      else if (color == 'writingShadow') return Color(_data['colors']['empty']);
      else if (color == 'transcribeDivider') return Color(_data['colors']['empty']);
      else if (color == 'transcribeCursor') return Color(_data['colors']['accent']);
      else if (color == 'informationDivider') return Color(_data['colors']['accent']);
      else if (color == 'informationDividerShadow') return Color(_data['colors']['buttonShadow']);
      else if (color == 'backToStartFAB') return Color(_data['colors']['white']);
      else if (color == 'backToStartFABShadow') return Color(_data['colors']['buttonShadow']);
      else if (color == 'backToStartFABIcon') return Color(_data['colors']['accent']);
      else if (color == 'keyboardStroke') return Color(_data['colors']['white']);
      else if (color == 'keyboardStrokeShadow') return Color(_data['colors']['accent']);
      else if (color == 'keyboardPress') return Color(_data['colors']['white']);
      else if (color == 'keyboardMainPress') return Color(_data['colors']['white']);
      else if (color == 'keyboardKeyHint') return Color(_data['colors']['accent']);
      else if (color == 'links') return Color(_data['colors']['accent']);
      else if (color == 'paragraphText') return Color(_data['colors']['white']);
      else return Color(_data['colors']['accent']);  // fallback color
    }
  }
  TextStyle getStyle(String style) {
    // Kulitan Fonts
    if (style == 'kulitanHome') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      color: getColor('foreground'),
    );
    else if (style == 'kulitanSwitch') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      fontSize: 20.0,
      color: getColor('customSwitch'),
    );
    else if (style == 'kulitanQuiz') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      fontSize: 150.0,
      color: getColor('foreground'),
    );
    else if (style == 'kulitanInfo') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      fontSize: 45.0,
      color: getColor('white'),
    );
    else if (style == 'kulitanInfoText') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      fontSize: 15.0,
      color: getColor('white'),
    );
    else if (style == 'kulitanTranscribe') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      color: getColor('foreground'),
    );
    else if (style == 'kulitanKeyboard') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      color: getColor('keyboardStroke'),
    );

    // Barlow Fonts
    else if (style == 'textHeaderButton') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
    );
    else if (style == 'textHomeTitle') return TextStyle(
      height: 0.8,
      fontFamily: 'Barlow',
      fontSize: 75.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(5.0, 7.0))
      ]
    );
    else if (style == 'textHomeSubtitle') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(4.0, 4.0))
      ]
    );
    else if (style == 'textHomeButton') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 40.0,
      fontWeight: FontWeight.w600,
      color: getColor('foreground'),
      height: 0.7,
    );
    else if (style == 'textHomeButtonSub') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 10.0,
      fontWeight: FontWeight.w600,
      color: getColor('foreground'),
    );
    else if (style == 'textPageTitle') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 50.0,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: getColor('white'),
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(4.0, 4.0))
      ]
    );
    else if (style == 'textSwitch') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: getColor('customSwitchToggle'),
    );
    else if (style == 'textQuizHeader') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
    );
    else if (style == 'textQuizAnswer') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 110.0,
      color: getColor('foreground'),
      height: 0.8,
    );
    else if (style == 'textQuizChoice') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
      color: getColor('foreground'),
    );
    else if (style == 'textWritingProgressBar') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 14.0,
      color: getColor('white'),
    );
    else if (style == 'textWriting') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 100.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
      height: 0.7,
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(7.0, 7.0))
      ]
    );
    else if (style == 'textWritingGuide') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 100.0,
      fontWeight: FontWeight.bold,
      color: getColor('accent'),
      height: 0.9,
    );
    else if (style == 'textInfoButton') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 30.0,
      fontWeight: FontWeight.w600,
      color: getColor('foreground'),
    );
    else if (style == 'textGuideButton') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: getColor('foreground'),
    );
    else if (style == 'textAboutButton') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
    );
    else if (style == 'textInfoCaption') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: getColor('foreground'),
    );
    else if (style == 'textInfoCredits') return TextStyle(
      fontFamily: 'Barlow',
      fontStyle: FontStyle.italic,
      color: getColor('white'),
    );
    else if (style == 'textInfoCreditsLink') return TextStyle(
      fontFamily: 'Barlow',
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.underline,
      color: getColor('links'),
    );
    else if (style == 'textInfoImageCaption') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 13.0,
      color: getColor('white'),
    );
    else if (style == 'textInfoImageCaptionItalic') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 13.0,
      fontStyle: FontStyle.italic,
      color: getColor('white'),
    );
    else if (style == 'textInfoImageCaptionKulitan') return TextStyle(
      fontFamily: 'Kulitan Semi Bold',
      fontSize: 13.0,
      color: getColor('white'),
    );
    else if (style == 'textInfoImageSubCaption') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 9.0,
      color: getColor('white'),
    );
    else if (style == 'textInfoText') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 15.0,
      color: getColor('white'),
    );
    else if (style == 'textInfoTextItalic') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 15.0,
      fontStyle: FontStyle.italic,
      color: getColor('white'),
    );
    else if (style == 'textInfoLink') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 15.0,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.underline,
      color: getColor('links'),
    );
    else if (style == 'textTranscribe') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: getColor('foreground'),
    );
    else if (style == 'textAboutSubtitle') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(3.0, 3.0))
      ]
    );
    else if (style == 'textAboutFooter') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 10.0,
      color: getColor('white'),
    );
    else if (style == 'textSettingsSubtitle') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      color: getColor('white'),
      shadows: <Shadow>[
        Shadow(color: getColor('accent'), offset: Offset(3.0, 3.0))
      ]
    );
    else if (style == 'textTutorialOverlay') return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 18.0,
      color: getColor('white'),
    );
    else return TextStyle(
      fontFamily: 'Barlow',
      fontSize: 15.0,
      color: getColor('foreground'),
    );
  }
  String getColorScheme() => _data['colors']['scheme'];
  bool getTutorial(String page) => _data[page]['tutorial'];
  int getOverallProgress(String page) => _data[page]['progress']['overall_progress'];
  int getBatch(String page) => _data[page]['progress']['current_batch'];
  bool getReadingMode() => _data['reading']['mode'];
  Map<String, String> getCards(String page) => _data[page]['cards'];
  Map<String, String> getChoices() => _data['reading']['choices'];
  int getGlyphProgress(String page, String glyph) => _data[page]['glyphs'][glyph];
  Map<String, int> getGlyphProgressList(String page) => _data[page]['glyphs'];
  
  void unlockColor(String colorScheme) {
    final List<String> _colorSchemeList = _data['colors']['unlockedSchemes']
      ..add(colorScheme);
    _data['colors']['unlockedSchemes'] = _colorSchemeList;
    _db.execute('INSERT INTO UnlockedColorSchemes VALUES ("$colorScheme")');
  }
  void setStatusBarColors(String colorScheme) {
    final Map<String, int> colors = colorSchemes[colorScheme];
    if (darkColorSchemes.contains(colorScheme)) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xFFFABF40),
        systemNavigationBarColor: Color(0xFFFABF40),
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(colors['primary']),
        systemNavigationBarColor: Color(colors['primary']),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }
  Future<void> setColorScheme(String colorScheme) async {
    final Map<String, int> colors = colorSchemes[colorScheme];
    await _prefs.setString('colorScheme', colorScheme);
    await _prefs.setInt('primary', colors['primary']);
    await _prefs.setInt('accent', colors['accent']);
    await _prefs.setInt('foreground', colors['foreground']);
    await _prefs.setInt('kulitanPath', colors['kulitanPath']);
    await _prefs.setInt('empty', colors['empty']);
    await _prefs.setInt('correctAnswer', colors['correctAnswer']);
    await _prefs.setInt('wrongAnswer', colors['wrongAnswer']);
    await _prefs.setInt('quizCardMiddle', colors['quizCardMiddle']);
    await _prefs.setInt('quizCardLast', colors['quizCardLast']);
    await _prefs.setInt('white', colors['white']);
    await _prefs.setInt('tutorialsOverlayBackground', colors['tutorialsOverlayBackground']);
    await _prefs.setInt('cardShadow', colors['cardShadow']);
    await _prefs.setInt('buttonShadow', colors['buttonShadow']);
    _data['colors'].addAll(colors);
    _data['colors']['scheme'] = colorScheme;
    setStatusBarColors(colorScheme);
  }
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

  void clearGameData() {
    _prefs.clear();
    _DatabaseHelper.clearDatabase();
  }

  Future<void> _getGameData() async {
    _data['colors'] = {};
    _data['intro'] = {};
    _data['reading'] = {};
    _data['writing'] = {};
    _data['transcribe'] = {};
    _data['colors']['unlockedSchemes'] = List<String>.from((await _db.query('UnlockedColorSchemes')).map((color) => color['color']));
    _data['colors']['scheme'] = _prefs.getString('colorScheme');
    _data['colors']['primary'] = _prefs.getInt('primary');
    _data['colors']['accent'] = _prefs.getInt('accent');
    _data['colors']['foreground'] = _prefs.getInt('foreground');
    _data['colors']['kulitanPath'] = _prefs.getInt('kulitanPath');
    _data['colors']['empty'] = _prefs.getInt('empty');
    _data['colors']['correctAnswer'] = _prefs.getInt('correctAnswer');
    _data['colors']['wrongAnswer'] = _prefs.getInt('wrongAnswer');
    _data['colors']['quizCardMiddle'] = _prefs.getInt('quizCardMiddle');
    _data['colors']['quizCardLast'] = _prefs.getInt('quizCardLast');
    _data['colors']['white'] = _prefs.getInt('white');
    _data['colors']['tutorialsOverlayBackground'] = _prefs.getInt('tutorialsOverlayBackground');
    _data['colors']['cardShadow'] = _prefs.getInt('cardShadow');
    _data['colors']['buttonShadow'] = _prefs.getInt('buttonShadow');
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
    setColorScheme('default');
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

  Future<Database> _initDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  static Future<void> clearDatabase() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String _path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(_path);
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
    await db.execute('''
          CREATE TABLE UnlockedColorSchemes (
            color TEXT(20) PRIMARY KEY
          )
          ''');
    await db.execute('INSERT INTO Page VALUES ("reading", 0, 0)');
    await db.execute('INSERT INTO Page VALUES ("writing", 0, 0)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("mode", null, null, null, null, "true")');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("cards", null, null, null, null, null)');
    await db.execute('INSERT INTO CurrentQuiz VALUES ("choices", null, null, null, null, null)');
    await db.execute('INSERT INTO CurrentDraw VALUES ("cards", null, null)');
    await db.execute('INSERT INTO UnlockedColorSchemes VALUES ("default")');
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