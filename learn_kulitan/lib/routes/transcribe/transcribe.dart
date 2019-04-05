import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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

class _TranscribePageState extends State<TranscribePage> {
  final TextEditingController _romanController =
      TextEditingController(text: 'atin ku pung singsing metung yang timpukan');

  String _kulitanText = 'atin ku pung singsing metung yang timpukan';
  List<SizedBox> _glyphs = [];

  void _textChanged() {
    setState(() => _kulitanText = _romanController.text);
    _transcribeRoman();
  }

  @override
  void initState() {
    super.initState();
    _romanController.addListener(_textChanged);
    _transcribeRoman();
  }

  @override
  void dispose() {
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
      if (_glyph == 'nu' || _glyph == 'lu') {
        _textWidget = Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: _textWidget,
        );
      } else if (_glyph.contains('s')) {
        _textWidget = Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: _textWidget,
        );
      }
      _tempGlyphs.add(SizedBox(
        width: _glyph == '?'
            ? 40.0
            : (_glyph.length == 1 &&
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
                        (_glyph[1] == 'a' ||
                            _glyph[1] == 'i' ||
                            _glyph[1] == 'u'))
                ? 100.0
                : _glyph == 'a' ||
                        _glyph == 'ee' ||
                        _glyph == 'oo' ||
                        _glyph == 'ng' ||
                        _glyph == 'nga' ||
                        _glyph == 'ngi' ||
                        _glyph == 'ngu'
                    ? 50.0
                    : _glyph == 'i' ||
                            _glyph == 'u' ||
                            _glyph == 'e' ||
                            _glyph == 'o'
                        ? 40.0
                        : ((_glyph.length > 2 &&
                                        midEnd
                                            .contains(_glyph.substring(0, 3)) &&
                                        !_glyph.contains('ng')) ||
                                    (_glyph.length > 1 &&
                                        midEnd.contains(
                                            _glyph.substring(0, 2)))) &&
                                _glyph != 'alii'
                            ? 40.0
                            : _glyph == 'yaa' || _glyph == 'waa' ? 100.0 : 75.0,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: _textWidget,
        ),
      ));
    }
    return _tempGlyphs;
  }

  void _transcribeRoman() {
    List<String> _allTempGlyphs = [];
    String _filteredText = _kulitanText
        .toLowerCase()
        .replaceAll(
            RegExp(
                r'[^\saàáâäæãåābcdeèéêëēėęfgiîïíīįìjklmnoôöòóœøōõpqrstuûüùúūvwyz?]'),
            ' ')
        .replaceAll(RegExp(r'[àáâäæãåā]+ | a{2,}'), 'aa')
        .replaceAll(RegExp(r'[îïíīįì]+ | i{2,}'), 'ii')
        .replaceAll(RegExp(r'[ûüùúū]+ | u{2,}'), 'uu')
        .replaceAll(RegExp(r'[èéêëēėę]'), 'e')
        .replaceAll(RegExp(r'[ôöòóœøōõ]'), 'o')
        .replaceAll('?', ' ? ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'(^|\s)(e+|e\s)ka\s'), ' alii ka ')
        .replaceAll(RegExp(r'(^|\s)(e+|e\s)ku\s'), ' alii ku ')
        .replaceAll(RegExp(r'(^|\s)(e+|e\s)ke\s'), ' alii ke ')
        .replaceAll(RegExp(r'(^|\s)(e+|e\s)ko\s'), ' alii ko ')
        .replaceAll('r', 'd')
        .replaceAll('ua', 'wa')
        .replaceAll('ea', 'ya')
        .replaceAll('kapampangan', 'kapangpang an')
        .replaceAll('pampanga', 'pangpanga')
        .trim();
    final List<String> _filteredWords = _filteredText.split(RegExp(r' '));
    String _glyphText;
    int _len, _maxLen;
    List<String> _tempGlyphs;
    for (String str in _filteredWords) {
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
      setState(() => _glyphs = _getGlyphs(_allTempGlyphs));
    }
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
        middle: Container(
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
    );

    Widget _kulitanInput = Container(
      padding: const EdgeInsets.only(top: 15.0),
      alignment: Alignment.topRight,
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Wrap(
            runSpacing: 15.0,
            direction: Axis.vertical,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: WrapCrossAlignment.center,
            textDirection: TextDirection.rtl,
            children: _glyphs,
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
      child: CustomCard(
        padding: const EdgeInsets.symmetric(
            horizontal: cardTranscribeHorizontalPadding,
            vertical: cardTranscribeVerticalPadding),
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
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: _pageCard,
            ),
          ],
        ),
      ),
    );
  }
}
