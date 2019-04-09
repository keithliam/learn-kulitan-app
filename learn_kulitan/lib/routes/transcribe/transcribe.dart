import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChannels;
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CustomCard.dart';
import '../../components/misc/DividerNew.dart';
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
  List<Container> _glyphLines = [];

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
      if (_glyph == 'nga') print(_width);
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
        .replaceAll('kapampangan', 'kapangpang an')
        .replaceAll('pampanga', 'pangpanga')
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
      _tempLines.add(_getGlyphs(_allTempGlyphs));
    }
    setState(() => _glyphLines = _getLines(_tempLines));
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
    }
    _keyboardController.reset();
    _keyboardController.forward();
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
          cursorColor: accentColor,
          cursorRadius: Radius.circular(15.0),
          cursorWidth: 4.0,
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

    Widget _pageCard = Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: transcribeHorizontalScreenPadding,
          vertical: transcribeVerticalScreenPadding),
      child: GestureDetector(
        onVerticalDragStart: (_) => FocusScope.of(context).requestFocus(new FocusNode()),
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

    final double _keyboardHeight = MediaQuery.of(context).size.width * 0.6588;
    final double _keyHeight = (_keyboardHeight - keyboardDividerHeight) / 4.0;

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -_keyboardHeight * _keyboardOffset,
                    bottom: _keyboardHeight * _keyboardOffset,
                    left: 0.0,
                    right: 0.0,
                    child: _pageCard,
                  ),
                  Positioned(
                    bottom:
                        -_keyboardHeight + (_keyboardHeight * _keyboardOffset),
                    left: keyboardPadding,
                    right: keyboardPadding,
                    child: SizedBox(
                      height: _keyboardHeight,
                      child: Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.55,
                            child: DividerNew(
                              height: keyboardDividerHeight,
                              color: whiteColor,
                            ),
                          ),
                          Expanded(
                            child: Table(
                              defaultColumnWidth: FlexColumnWidth(1.0),
                              children: <TableRow>[
                                TableRow(
                                  children: <Widget>[
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'g',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'k',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'ng',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'a',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'clear',
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 't',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'd',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'n',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'i',
                                    ),
                                    Container(),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'l',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 's',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'm',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'u',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'delete',
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: <Widget>[
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'p',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'b',
                                    ),
                                    Container(),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'add',
                                    ),
                                    KeyboardKey(
                                      height: _keyHeight,
                                      keyType: 'enter',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeyboardKey extends StatelessWidget {
  KeyboardKey({this.keyType, this.height});

  final String keyType;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(keyboardKeyPadding),
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: KeyboardKeyContainer(
          keyType: this.keyType,
        ),
      ),
    );
  }
}

class KeyboardKeyContainer extends StatelessWidget {
  const KeyboardKeyContainer({this.keyType});

  final String keyType;

  @override
  Widget build(BuildContext context) {
    if (keyType == 'a') {
      return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          keyType,
          textAlign: TextAlign.center,
          style: kulitanKeyboard.copyWith(shadows: <Shadow>[
            Shadow(color: keyboardStrokeShadowColor, offset: Offset(0.75, 0.75))
          ]),
        ),
      );
    } else if (keyType == 'clear') {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'CLEAR\nALL',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0.8,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w900,
              color: keyboardStrokeColor,
              shadows: <Shadow>[
                Shadow(
                    color: keyboardStrokeShadowColor, offset: Offset(1.8, 1.8))
              ],
            ),
          ),
        ),
      );
    } else if (keyType == 'delete' || keyType == 'enter' || keyType == 'add') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: _KeyIconPainter(
            keyType: this.keyType,
          ),
        ),
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              this.keyType,
              textAlign: TextAlign.center,
              style: kulitanKeyboard.copyWith(shadows: <Shadow>[
                Shadow(
                    color: keyboardStrokeShadowColor,
                    offset: Offset(0.75, 0.75))
              ]),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Opacity(
              opacity: 0.55,
              child: Text(
                this.keyType != 'i'
                    ? this.keyType != 'u' ? this.keyType + 'i' : 'wi'
                    : 'yi',
                textAlign: TextAlign.center,
                style: kulitanKeyboard,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Opacity(
              opacity: 0.55,
              child: Text(
                this.keyType != 'i'
                    ? this.keyType != 'u' ? this.keyType + 'u' : 'wu'
                    : 'yu',
                textAlign: TextAlign.center,
                style: kulitanKeyboard,
              ),
            ),
          ),
        ],
      );
    }
  }
}

class _KeyIconPainter extends CustomPainter {
  _KeyIconPainter({this.keyType});

  final String keyType;

  @override
  bool shouldRepaint(_KeyIconPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset _shadowOffset = Offset(2.5, 2.5);
    final double _strokeWidth = 3.0;
    final double _start = _strokeWidth - (_shadowOffset.dx / 2.0);
    final double _end = size.width - _strokeWidth - (_shadowOffset.dx / 2.0);
    final double _width = _end - _start;
    final double _middle = size.height / 2.0;

    Paint _stroke = Paint()
      ..color = keyboardStrokeShadowColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    if (keyType == 'delete') {
      final double _midpoint = _start + (_width * 0.66678);
      final double _offset1 = _width * 0.33391;
      final double _offset2 = _width * 0.16713;
      final Path _outline = Path()
        ..moveTo(_start, _middle)
        ..lineTo(_start + _offset1, _middle - _offset1)
        ..lineTo(_end, _middle - _offset1)
        ..lineTo(_end, _middle + _offset1)
        ..lineTo(_start + _offset1, _middle + _offset1)
        ..lineTo(_start, _middle);
      final Path _cross1 = Path()
        ..moveTo(_midpoint - _offset2, _middle - _offset2)
        ..lineTo(_midpoint + _offset2, _middle + _offset2);
      final Path _cross2 = Path()
        ..moveTo(_midpoint - _offset2, _middle + _offset2)
        ..lineTo(_midpoint + _offset2, _middle - _offset2);
      canvas.drawPath(_outline.shift(_shadowOffset), _stroke);
      canvas.drawPath(_cross1.shift(_shadowOffset), _stroke);
      canvas.drawPath(_cross2.shift(_shadowOffset), _stroke);
      canvas.drawPath(_outline, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_cross1, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_cross2, _stroke..color = keyboardStrokeColor);
    } else if (keyType == 'enter') {
      final double _offset1 = _width * 0.26544;
      final Path _head = Path()
        ..moveTo(_start + _offset1, _middle - _offset1)
        ..lineTo(_start, _middle)
        ..lineTo(_start + _offset1, _middle + _offset1);
      final Path _body = Path()
        ..moveTo(_start, _middle)
        ..lineTo(_end, _middle)
        ..lineTo(_end, _middle - (_width * 0.29824));
      canvas.drawPath(_head.shift(_shadowOffset), _stroke);
      canvas.drawPath(_body.shift(_shadowOffset), _stroke);
      canvas.drawPath(_head, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_body, _stroke..color = keyboardStrokeColor);
    } else if (keyType == 'add') {
      final double _offset = _width * 0.33391;
      final double _center = (_start + _end) / 2.0;
      final Path _topDown = Path()
        ..moveTo(_center, _middle - _offset)
        ..lineTo(_center, _middle + _offset);
      final Path _leftRight = Path()
        ..moveTo(_center - _offset, _middle)
        ..lineTo(_center + _offset, _middle);
      canvas.drawPath(_topDown.shift(_shadowOffset), _stroke);
      canvas.drawPath(_leftRight.shift(_shadowOffset), _stroke);
      canvas.drawPath(_topDown, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_leftRight, _stroke..color = keyboardStrokeColor);
    }
  }
}
