import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CustomCard.dart';
import '../../components/misc/DividerNew.dart';
import './components.dart';
import 'kulitan_combinations.dart';

class TranscribePage extends StatefulWidget {
  @override
  _TranscribePageState createState() => _TranscribePageState();
}

class _TranscribePageState extends State<TranscribePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _romanController =
      TextEditingController(text: 'atin ku pung singsing metung yang timpukan');

  String _kulitanText = 'atin ku pung singsing metung yang timpukan';
  List<Widget> _glyphLines = [];
  List<List<String>> _kulitanGlyphs = [[]];

  double _keyboardDrag = 0.0;
  double _keyboardOffset = 0.0;
  AnimationController _keyboardController;
  Tween<double> _keyboardTween;
  Animation<double> _keyboardAnimation;

  void _textChanged() {
    setState(() => _kulitanText = _romanController.text);
    _transcribeRoman();
  }

  @override
  void initState() {
    super.initState();
    _keyboardController = AnimationController(
        duration: Duration(milliseconds: keyboardAnimateDuration), vsync: this);
    final CurvedAnimation _keyboardCurve = CurvedAnimation(
        parent: _keyboardController, curve: keyboardAnimateToggleCurve);
    _keyboardTween = Tween<double>(begin: 0.0, end: 1.0);
    _keyboardAnimation = _keyboardTween.animate(_keyboardCurve)
      ..addListener(
          () => setState(() => _keyboardOffset = _keyboardAnimation.value));
    _romanController.addListener(_textChanged);
    _transcribeRoman(isInit: true);
  }

  @override
  void dispose() {
    _keyboardController.dispose();
    _romanController.dispose();
    super.dispose();
  }

  String _getGlyph(String str, int maxLen) {
    final int _len = str.length;
    if (maxLen == 6 && six.contains(str))
      return str.substring(_len - 6, _len);
    else if (maxLen > 4 && five.contains(str.substring(_len - 5, _len)))
      return str.substring(_len - 5, _len);
    else if (maxLen > 3 && four.contains(str.substring(_len - 4, _len)))
      return str.substring(_len - 4, _len);
    else if (maxLen > 2 && three.contains(str.substring(_len - 3, _len)))
      return str.substring(_len - 3, _len);
    else if (maxLen > 2 && midEnd.contains(str.substring(0, 3)))
      return str.substring(0, 3);
    else if (maxLen > 1 && two.contains(str.substring(_len - 2, _len)))
      return str.substring(_len - 2, _len);
    else if (maxLen > 1 && midEnd.contains(str.substring(0, 2)))
      return str.substring(0, 2);
    else if (maxLen > 0 && one.contains(str.substring(_len - 1, _len)))
      return str.substring(_len - 1, _len);
    else
      return '';
  }

  List<SizedBox> _getGlyphs(List<String> glyphList) {
    Widget _textWidget;
    List<SizedBox> _tempGlyphs = [];
    for (String _glyph in glyphList) {
      _textWidget = Text(
        _glyph,
        textAlign: TextAlign.center,
        style:
            _glyph == 'k' || _glyph == 'ka' || _glyph == 'ki' || _glyph == 'ku'
                ? kulitanTranscribe.copyWith(height: 0.7)
                : kulitanTranscribe,
      );
      double _width = 75.0 * transcribeRelativeFontSize;
      if (_glyph == 'nu' || _glyph == 'lu')
        _textWidget = Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: _textWidget,
        );
      else if (_glyph.contains('s'))
        _textWidget = Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: _textWidget,
        );
      if (_glyph == '?')
        _width = 40.0 * transcribeRelativeFontSize;
      else if (_glyph == 'ngaa' ||
          (_glyph.length == 3 && (_glyph.contains('ng') && _glyph != 'ang')))
        _width = 100.0 * transcribeRelativeFontSize;
      else if (_glyph == 'a' ||
          _glyph == 'aa' ||
          _glyph == 'ee' ||
          _glyph == 'oo' ||
          _glyph == 'ng' ||
          _glyph == 'ang')
        _width = 60.0 * transcribeRelativeFontSize;
      else if ((_glyph.length == 1 &&
              _glyph != 'a' &&
              _glyph != 'i' &&
              _glyph != 'u' &&
              _glyph != 'e' &&
              _glyph != 'o') ||
          (_glyph.length == 2 &&
              _glyph[0] != 'i' &&
              _glyph[0] != 'u' &&
              _glyph[0] != 'e' &&
              _glyph[0] != 'o' &&
              (_glyph[1] == 'a' || _glyph[1] == 'i' || _glyph[1] == 'u')))
        _width = 90.0 * transcribeRelativeFontSize;
      else if (_glyph == 'i' || _glyph == 'u' || _glyph == 'e' || _glyph == 'o')
        _width = 40.0 * transcribeRelativeFontSize;
      else if (((_glyph.length > 2 &&
                  midEnd.contains(_glyph.substring(0, 3)) &&
                  !_glyph.contains('ng')) ||
              (_glyph.length > 1 && midEnd.contains(_glyph.substring(0, 2)))) &&
          _glyph != 'alii')
        _width = 45.0 * transcribeRelativeFontSize;
      else if (_glyph == 'yaa' || _glyph == 'waa')
        _width = 100.0 * transcribeRelativeFontSize;
      else
        _width = 75.0 * transcribeRelativeFontSize;
      _tempGlyphs.add(SizedBox(
        width: _width,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: _textWidget,
        ),
      ));
    }
    return _tempGlyphs;
  }

  List<Container> _getLines(List<List<SizedBox>> lines) {
    List<Container> _tempLines = [];
    for (List<SizedBox> _glyphs in lines) {
      _tempLines.insert(
        0,
        Container(
          height: double.infinity,
          padding:
              const EdgeInsets.only(left: 5.0 * transcribeRelativeFontSize),
          child: Wrap(
            runSpacing: 5.0 * transcribeRelativeFontSize,
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.rtl,
            children: _glyphs,
          ),
        ),
      );
    }
    return _tempLines;
  }

  void _transcribeRoman({isInit: false}) {
    List<String> _allTempGlyphs = [];
    String _filteredText = _kulitanText
        .toLowerCase()
        .replaceAll(
            RegExp(
                r'[^\s\\naàáâäæãåābcdeèéêëēėęfgiîïíīįìjklmnoôöòóœøōõpqrstuûüùúūvwyz]'),
            ' ')
        .replaceAll(RegExp(r'[àáâäæãåā]+|aa+'), 'aa')
        .replaceAll(RegExp(r'[îïíīįì]+|ii+'), 'ii')
        .replaceAll(RegExp(r'[ûüùúū]+|uu+'), 'uu')
        .replaceAll(RegExp(r'[èéêëēėę]'), 'e')
        .replaceAll(RegExp(r'[ôöòóœøōõ]'), 'o')
        .replaceAll('?', ' ? ')
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll('r', 'd')
        .replaceAll('z', 's')
        .replaceAll('ua', 'wa')
        .replaceAll('ea', 'ya')
        .replaceAll(
            RegExp(r'kapampangan|pampanga|kapampaangan'), 'kapangpaang an')
        .trim();
    final List<String> _lines = _filteredText.split('\n');
    List<List<String>> _lineGlyphs = [];
    for (String _line in _lines) {
      _line = _line
          .replaceAll(RegExp(r'(^|\s)e+(\s|$)'), ' alii ')
          .replaceAll(RegExp(r'(^|\s)(e+|e\s)ka(\s|$)'), ' alii ka ')
          .replaceAll(RegExp(r'(^|\s)(e+|e\s)ku(\s|$)'), ' alii ku ')
          .replaceAll(RegExp(r'(^|\s)(e+|e\s)ke(\s|$)'), ' alii ke ')
          .replaceAll(RegExp(r'(^|\s)(e+|e\s)ko(\s|$)'), ' alii ko ')
          .replaceAll(RegExp(r'(^|\s)i+ka(\s|$)'), ' iik ')
          .replaceAll(RegExp(r'(^|\s)i+ka\s?tamu(\s|$)'), ' iik tamu ')
          .replaceAll(RegExp(r'(^|\s)i+ka\s?mi(\s|$)'), ' iik mi ')
          .replaceAll(RegExp(r'(^|\s)i+ka\s?yu(\s|$)'), ' iik yu ')
          .replaceAll(RegExp(r'(^|\s)i+la(\s|$)'), ' iil ')
          .replaceAll(RegExp(r'(^|\s)mewala(\s|$)'), ' me ala ')
          .trim();
      _lineGlyphs.add(_line.split(' '));
    }
    String _glyphText;
    int _len, _maxLen;
    List<List<SizedBox>> _tempLines = [];
    List<List<String>> _tempKulitans = [];
    List<String> _tempGlyphs;
    for (List<String> _line in _lineGlyphs) {
      _allTempGlyphs = [];
      for (String str in _line) {
        if (str == 'ali' || str == 'alii') {
          _allTempGlyphs.add('alii');
        } else if (str == '?') {
          _allTempGlyphs.add('?');
        } else {
          _tempGlyphs = [];
          _filteredText = str;
          while (_filteredText.length > 0) {
            if (_filteredText == 'e') {
              _filteredText = '';
              _tempGlyphs.insert(0, 'ee');
            } else if (_filteredText == 'o') {
              _filteredText = '';
              _tempGlyphs.insert(0, 'oo');
            } else {
              _len = _filteredText.length;
              _maxLen = _len < 6 ? _len : 6;
              _glyphText = _getGlyph(
                  _filteredText.substring(_len - _maxLen, _len), _maxLen);
              if (_glyphText.length != 0) {
                _filteredText =
                    _filteredText.substring(0, _len - _glyphText.length);
                _tempGlyphs.insert(0, _glyphText);
              } else {
                _filteredText = _filteredText.substring(0, _len - 1);
              }
            }
          }
          _allTempGlyphs.addAll(_tempGlyphs);
        }
      }
      _tempKulitans.add(_allTempGlyphs);
      _tempLines.add(_getGlyphs(_allTempGlyphs));
    }
    setState(() {
      _glyphLines = _getLines(_tempLines);
      _kulitanGlyphs = _tempKulitans.length > 0 ? _tempKulitans : [[]];
    });
    if (!isInit) {
      final double _maxPosition = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(_maxPosition,
          curve: transcribeScrollChangeCurve,
          duration:
              const Duration(milliseconds: transcribeScrollChangeDuration));
    }
  }

  void _dragUpdate(DragUpdateDetails details) {
    final double _newOffset = _keyboardDrag -
        (details.delta.dy * 0.00475 * keyboardToggleSensitivity);
    if (_newOffset >= 0.0 && _newOffset <= 1.0) {
      _keyboardDrag = _newOffset;
      setState(() =>
          _keyboardOffset = Curves.easeInOutQuad.transform(_keyboardDrag));
    }
  }

  void _dragEnd(DragEndDetails details) {
    _keyboardTween.begin = _keyboardOffset;
    if (_keyboardOffset >= 0.5) {
      _keyboardDrag = 1.0;
      _keyboardTween.end = 1.0;
    } else {
      _keyboardDrag = 0.0;
      _keyboardTween.end = 0.0;
    }
    _keyboardController.reset();
    _keyboardController.forward();
  }

  void _animateToggleKeyboard() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _keyboardTween.begin = _keyboardOffset;
    if (_keyboardOffset >= 0.5) {
      _keyboardDrag = 0.0;
      _keyboardTween.end = 0.0;
    } else {
      _keyboardDrag = 1.0;
      _keyboardTween.end = 1.0;
      _transcribeKulitan();
    }
    _keyboardController.reset();
    _keyboardController.forward();
  }

  String _getLastKulitanGlyph() =>
      _kulitanGlyphs.length > 0 && _kulitanGlyphs.last.length > 0
          ? _kulitanGlyphs.last.last
          : null;

  bool _hasOneIndungSulat(String glyph) =>
      glyph.length > 1 &&
      (glyph.endsWith('a') ||
          glyph.endsWith('i') ||
          glyph.endsWith('u') ||
          glyph.endsWith('e') ||
          glyph.endsWith('o'));

  bool _hasTwoIndungSulat(String glyph) =>
      glyph.contains(RegExp(r'^.+(a|i|u|e|o).+$'));

  void _kulitanKeyPressed(String next, {String glyph}) {
    if (next == 'enter') {
      if (_kulitanGlyphs.last.length > 0 && _kulitanGlyphs.last.last != 'br')
        _kulitanGlyphs.last.add('br');
      else {
        if (_kulitanGlyphs.last.last == 'br') _kulitanGlyphs.last.removeLast();
        _kulitanGlyphs.add([]);
      }
    } else if (next == 'delete') {
      if (_kulitanGlyphs.last.length > 0) {
        final List<String> _kulitList = _kulitanGlyphs.last;
        final int _last = _kulitList.length - 1;
        final String _curr = _kulitList.last;
        // if (_curr.length == 1)
        if (_hasTwoIndungSulat(_curr))
          _kulitList[_last] =
              _curr.replaceAll(RegExp(r'(g|k|ng|t|d|n|l|s|m|p|b)$'), '');
        else if (_curr.contains(RegExp(r'^.+(e|o)$')))
          _kulitList[_last] = _curr.replaceAll(RegExp(r'e|o'), 'a');
        else if (_curr.contains(RegExp(r'^(i|u)a(a|e|o)$')) ||
            _curr.contains(RegExp(r'^(i|u)a$')) ||
            _curr.contains(RegExp(r'^a(i|u)$')) ||
            _curr.contains(RegExp(r'(aa|ii|uu)$')))
          _kulitList[_last] = _curr.substring(0, _curr.length - 1);
        else
          _kulitList.removeLast();
      }
    } else if (next == 'clear') {
      _kulitanGlyphs = [[]];
    } else if (next == 'add') {
      _kulitanGlyphs.last[_kulitanGlyphs.last.length - 1] = glyph;
    } else {
      if (_kulitanGlyphs.last.length > 0 && _kulitanGlyphs.last.last != 'br') {
        final List<String> _induA = [
          'ga',
          'ka',
          'nga',
          'ta',
          'da',
          'na',
          'la',
          'sa',
          'ma',
          'pa',
          'ba',
          'ia',
          'ua',
        ];
        final List<String> _induI = [
          'gi',
          'ki',
          'ngi',
          'ti',
          'di',
          'ni',
          'li',
          'si',
          'mi',
          'pi',
          'bi',
        ];
        final List<String> _induU = [
          'gu',
          'ku',
          'ngu',
          'tu',
          'du',
          'nu',
          'lu',
          'su',
          'mu',
          'pu',
          'bu',
        ];
        final List<String> _kulitList = _kulitanGlyphs.last;
        final int _last = _kulitList.length - 1;
        final String _curr = _kulitList.last;
        if (next == 'a') {
          if (_induA.contains(_curr) || _curr == 'i' || _curr == 'u')
            _kulitList[_last] += 'a';
          else
            _kulitanGlyphs.last.add('a');
        } else if (next == 'e') {
          if (_curr == 'ali')
            _kulitList[_last] = 'alii';
          else if (_induI.contains(_curr) ||
              _induU.contains(_curr) ||
              _curr == 'e' ||
              _curr == 'ia' ||
              _curr == 'ua' ||
              _curr == 'a')
            _kulitList[_last] += 'i';
          else
            _kulitanGlyphs.last.add('i');
        } else if (next == 'o') {
          if (_induU.contains(_curr) ||
              _curr == 'o' ||
              _curr == 'ia' ||
              _curr == 'ua' ||
              _curr == 'a')
            _kulitList[_last] += 'u';
          else
            _kulitanGlyphs.last.add('u');
        } else if (next == 'li' && _curr == 'a') {
          _kulitList[_last] = 'ali';
        } else if (next.endsWith('a') && _hasOneIndungSulat(_curr)) {
          _kulitList[_last] += next.substring(0, next.length - 1);
        } else {
          _kulitanGlyphs.last.add(next);
        }
      } else {
        if (_kulitanGlyphs.last.length > 0 && _kulitanGlyphs.last.last == 'br')
          _kulitanGlyphs.last.removeLast();
        if (next == 'e')
          _kulitanGlyphs[_kulitanGlyphs.length - 1].add('i');
        else if (next == 'o')
          _kulitanGlyphs[_kulitanGlyphs.length - 1].add('u');
        else
          _kulitanGlyphs[_kulitanGlyphs.length - 1].add(next);
      }
    }
    _transcribeKulitan();
  }

  void _transcribeKulitan() {
    for (List<String> _list in _kulitanGlyphs)
      for (int i = 0; i < _list.length; i++)
        _list[i] = _list[i]
            .replaceAll('ya', 'ia')
            .replaceAll('ye', 'iai')
            .replaceAll('yo', 'iau')
            .replaceAll('wa', 'ua')
            .replaceAll('we', 'uai')
            .replaceAll('wo', 'uau');
    _updateInputsFromKulitan();
  }

  void _updateInputsFromKulitan() {
    List<List<SizedBox>> _tempGlyphs = [];
    List<String> _tempLine;
    String _transcribed = '';
    for (List<String> _line in _kulitanGlyphs) {
      _tempLine = List<String>.from(_line);
      for (int i = 0; i < _tempLine.length; i++) {
        _tempLine[i] = _tempLine[i]
            .replaceAll('ia', 'ya')
            .replaceAll('iai', 'ye')
            .replaceAll('iau', 'yo')
            .replaceAll('ua', 'wa')
            .replaceAll('uai', 'we')
            .replaceAll('uau', 'wo');
        if (_tempLine[i] != 'br') _transcribed += _tempLine[i] + ' ';
      }
      _transcribed.replaceAll(RegExp(r' $'), ' ');
      _transcribed += '\n';
      if (_tempLine.length > 0) {
        if (_tempLine.last != 'br')
          _tempGlyphs.add(_getGlyphs(_tempLine));
        else
          _tempGlyphs
              .add(_getGlyphs(_tempLine.sublist(0, _tempLine.length - 1)));
      }
    }
    if (_tempLine.length > 0 && _tempLine.last != 'br')
      _transcribed = _transcribed.trimRight();
    _romanController.text = _transcribed;
    setState(() => _glyphLines = _getLines(_tempGlyphs));
  }

  @override
  Widget build(BuildContext context) {
    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        middle: Padding(
          padding: const EdgeInsets.only(bottom: headerVerticalPadding),
          child: Center(
            child: Text('Transcribe', style: textPageTitle),
          ),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );

    Widget _romanInput = Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Scrollbar(
        child: TextField(
          controller: _romanController,
          autocorrect: false,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: textTranscribe,
          cursorColor: transcribeCursorColor,
          cursorRadius: Radius.circular(15.0),
          cursorWidth: transcribeCursorWidth,
          decoration: null,
        ),
      ),
    );

    Widget _kulitanInput = Container(
      padding: const EdgeInsets.only(top: 15.0),
      alignment: Alignment.topRight,
      child: SizedBox(
        height: double.infinity,
        child: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _glyphLines,
            ),
          ),
        ),
      ),
    );

    Widget _divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: DividerNew(
        height: 8.0,
        color: transcribeDividerColor,
      ),
    );

    Widget _page = Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: transcribeHorizontalScreenPadding,
          vertical: transcribeVerticalScreenPadding),
      child: GestureDetector(
        onVerticalDragStart: (_) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        onVerticalDragUpdate: _dragUpdate,
        onVerticalDragEnd: _dragEnd,
        onTap: _animateToggleKeyboard,
        child: CustomCard(
          padding: const EdgeInsets.fromLTRB(
              cardTranscribeHorizontalPadding,
              cardTranscribeVerticalPadding,
              cardTranscribeHorizontalPadding,
              cardTranscribeVerticalPadding / 2),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _romanInput,
              ),
              Expanded(
                flex: 0,
                child: _divider,
              ),
              Expanded(
                flex: 2,
                child: _kulitanInput,
              ),
            ],
          ),
        ),
      ),
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: KulitanKeyboard(
                getGlyph: _getLastKulitanGlyph,
                visibility: _keyboardOffset,
                onKeyPress: _kulitanKeyPressed,
                child: _page,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
