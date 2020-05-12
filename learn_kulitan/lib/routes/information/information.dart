import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../styles/theme.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/DividerNew.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/Paragraphs.dart';
import '../../db/GameData.dart';
import './components.dart';

class InformationPage extends StatefulWidget {
  const InformationPage(this.audioPlayer);

  final AudioCache audioPlayer;

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  static final GameData _gameData = GameData();
  final ScrollController _scrollController = ScrollController();
  final CustomButtonGroup _buttonGroup = CustomButtonGroup();
  final AutoSizeGroup _textGroup = AutoSizeGroup();

  bool _showBackToStartFAB = false;
  bool _disabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController
      ..addListener(() {
        final double _position = _scrollController.offset;
        final double _threshold = informationFABThreshold *
            _scrollController.position.maxScrollExtent;
        if (_position <= _threshold && _showBackToStartFAB == true)
          setState(() => _showBackToStartFAB = false);
        else if (_position > _threshold && !_showBackToStartFAB)
          setState(() => _showBackToStartFAB = true);
      });
  }

  void _disableButtons() async {
    setState(() => _disabled = true);
    await Future.delayed(const Duration(milliseconds: 2 * defaultCustomButtonPressDuration));
    setState(() => _disabled = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenWidth = _mediaQuery.size.width;
    final double _screenHorizontalPadding = _screenWidth > maxPageWidth ? 0.0 : informationHorizontalScreenPadding;

    final Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(
        headerHorizontalPadding,
        headerVerticalPadding,
        headerHorizontalPadding,
        0.0,
      ),
      child: StaticHeader(
        left: RoundedBackButton(alignment: Alignment.center),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final Widget _historyButton = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        informationVerticalScreenPadding,
        _screenHorizontalPadding,
        0.0,
      ),
      child: CustomButton(
        buttonGroup: _buttonGroup,
        disable: _disabled,
        onPressedImmediate: _disableButtons,
        onPressed: () => Navigator.pushNamed(context, '/information/history'),
        height: _mediaQuery.size.height > smallHeight ? 60.0 : 50.0,
        borderRadius: 30.0,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        elevation: 10.0,
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'History of Kulitan',
                    group: _textGroup,
                    style: _gameData.getStyle('textInfoButton'),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text('>', style: _gameData.getStyle('textInfoButton').copyWith(color: _gameData.getColor('accent'))),
            ],
          ),
        ),
      ),
    );
    final Widget _writingInstructionsButton = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        0.0,
        _screenHorizontalPadding,
        informationVerticalScreenPadding - headerVerticalPadding + 8.0,
      ),
      child: CustomButton(
        buttonGroup: _buttonGroup,
        disable: _disabled,
        onPressedImmediate: _disableButtons,
        onPressed: () => Navigator.pushNamed(context, '/information/guide'),
        height: 60.0,
        borderRadius: 30.0,
        marginTop: 10.0,
        elevation: 10.0,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Writing Guide',
                    group: _textGroup,
                    style: _gameData.getStyle('textInfoButton'),
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Text('>', style: _gameData.getStyle('textInfoButton').copyWith(color: _gameData.getColor('accent'))),
            ],
          ),
        ),
      ),
    );

    final Widget _indungSulatTable = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        informationSubtitleBottomPadding - headerVerticalPadding,
        _screenHorizontalPadding,
        0.0,
      ),
      child: Table(
        defaultColumnWidth: FlexColumnWidth(1.0),
        children: <TableRow>[
          TableRow(children: <Widget>[
            KulitanInfoCell('ga', 'ga', widget.audioPlayer),
            KulitanInfoCell('ka', 'ka', widget.audioPlayer),
            KulitanInfoCell('nga', 'nga', widget.audioPlayer),
            KulitanInfoCell('ta', 'ta', widget.audioPlayer),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('da', 'da', widget.audioPlayer),
            KulitanInfoCell('na', 'na', widget.audioPlayer),
            KulitanInfoCell('la', 'la', widget.audioPlayer),
            KulitanInfoCell('sa', 'sa', widget.audioPlayer),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('ma', 'ma', widget.audioPlayer),
            KulitanInfoCell('pa', 'pa', widget.audioPlayer),
            KulitanInfoCell('ba', 'ba', widget.audioPlayer),
            Container(),
          ]),
        ],
      ),
    );
    final Widget _indungSulatVowelTable = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        0.0,
        _screenHorizontalPadding,
        informationVerticalScreenPadding - headerVerticalPadding + 8.0,
      ),
      child: Table(
        defaultColumnWidth: FlexColumnWidth(1.0),
        children: <TableRow>[
          TableRow(children: <Widget>[
            KulitanInfoCell('a', 'a', widget.audioPlayer),
            KulitanInfoCell('i', 'i', widget.audioPlayer),
            KulitanInfoCell('u', 'u', widget.audioPlayer),
            KulitanInfoCell('ee', 'e', widget.audioPlayer),
            KulitanInfoCell('oo', 'o', widget.audioPlayer),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('aa', 'á/â', widget.audioPlayer),
            KulitanInfoCell('ii', 'í/î', widget.audioPlayer),
            KulitanInfoCell('uu', 'ú/û', widget.audioPlayer),
            Container(),
            Container(),
          ]),
        ],
      ),
    );

    final double _cellWidth = _screenWidth >= 600 ? 120.0 : (_screenWidth - (_screenHorizontalPadding * 2)) / 4;

    final Widget _anakSulatTable = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _screenHorizontalPadding),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(_cellWidth),
          children: <TableRow>[
            TableRow(children: <Widget>[
              KulitanInfoCell('gaa', 'gá/gâ', widget.audioPlayer),
              KulitanInfoCell('gi', 'gi', widget.audioPlayer),
              KulitanInfoCell('gii', 'gí/gî', widget.audioPlayer),
              KulitanInfoCell('gu', 'gu', widget.audioPlayer),
              KulitanInfoCell('guu', 'gú/gû', widget.audioPlayer),
              KulitanInfoCell('ge', 'ge', widget.audioPlayer),
              KulitanInfoCell('go', 'go', widget.audioPlayer),
              KulitanInfoCell('gang', 'gang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('kaa', 'ká/kâ', widget.audioPlayer),
              KulitanInfoCell('ki', 'ki', widget.audioPlayer),
              KulitanInfoCell('kii', 'kí/kî', widget.audioPlayer),
              KulitanInfoCell('ku', 'ku', widget.audioPlayer),
              KulitanInfoCell('kuu', 'kú/kû', widget.audioPlayer),
              KulitanInfoCell('ke', 'ke', widget.audioPlayer),
              KulitanInfoCell('ko', 'ko', widget.audioPlayer),
              KulitanInfoCell('kang', 'kang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('ngaa', 'ngá/ngâ', widget.audioPlayer),
              KulitanInfoCell('ngi', 'ngi', widget.audioPlayer),
              KulitanInfoCell('ngii', 'ngí/ngî', widget.audioPlayer),
              KulitanInfoCell('ngu', 'ngu', widget.audioPlayer),
              KulitanInfoCell('nguu', 'ngú/ngû', widget.audioPlayer),
              KulitanInfoCell('nge', 'nge', widget.audioPlayer),
              KulitanInfoCell('ngo', 'ngo', widget.audioPlayer),
              KulitanInfoCell('ngang', 'ngang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('taa', 'tá/tâ', widget.audioPlayer),
              KulitanInfoCell('ti', 'ti', widget.audioPlayer),
              KulitanInfoCell('tii', 'tí/tî', widget.audioPlayer),
              KulitanInfoCell('tu', 'tu', widget.audioPlayer),
              KulitanInfoCell('tuu', 'tú/tû', widget.audioPlayer),
              KulitanInfoCell('te', 'te', widget.audioPlayer),
              KulitanInfoCell('to', 'to', widget.audioPlayer),
              KulitanInfoCell('tang', 'tang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('daa', 'dá/dâ', widget.audioPlayer),
              KulitanInfoCell('di', 'di', widget.audioPlayer),
              KulitanInfoCell('dii', 'dí/dî', widget.audioPlayer),
              KulitanInfoCell('du', 'du', widget.audioPlayer),
              KulitanInfoCell('duu', 'dú/dû', widget.audioPlayer),
              KulitanInfoCell('de', 'de', widget.audioPlayer),
              KulitanInfoCell('do', 'do', widget.audioPlayer),
              KulitanInfoCell('dang', 'dang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('naa', 'ná/nâ', widget.audioPlayer),
              KulitanInfoCell('ni', 'ni', widget.audioPlayer),
              KulitanInfoCell('nii', 'ní/nî', widget.audioPlayer),
              KulitanInfoCell('nu', 'nu', widget.audioPlayer),
              KulitanInfoCell('nuu', 'nú/nû', widget.audioPlayer),
              KulitanInfoCell('ne', 'ne', widget.audioPlayer),
              KulitanInfoCell('no', 'no', widget.audioPlayer),
              KulitanInfoCell('nang', 'nang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('laa', 'lá/lâ', widget.audioPlayer),
              KulitanInfoCell('li', 'li', widget.audioPlayer),
              KulitanInfoCell('lii', 'lí/lî', widget.audioPlayer),
              KulitanInfoCell('lu', 'lu', widget.audioPlayer),
              KulitanInfoCell('luu', 'lú/lû', widget.audioPlayer),
              KulitanInfoCell('le', 'le', widget.audioPlayer),
              KulitanInfoCell('lo', 'lo', widget.audioPlayer),
              KulitanInfoCell('lang', 'lang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('saa', 'sá/sâ', widget.audioPlayer),
              KulitanInfoCell('si', 'si', widget.audioPlayer),
              KulitanInfoCell('sii', 'sí/sî', widget.audioPlayer),
              KulitanInfoCell('su', 'su', widget.audioPlayer),
              KulitanInfoCell('suu', 'sú/sû', widget.audioPlayer),
              KulitanInfoCell('se', 'se', widget.audioPlayer),
              KulitanInfoCell('so', 'so', widget.audioPlayer),
              KulitanInfoCell('sang', 'sang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('maa', 'má/mâ', widget.audioPlayer),
              KulitanInfoCell('mi', 'mi', widget.audioPlayer),
              KulitanInfoCell('mii', 'mí/mî', widget.audioPlayer),
              KulitanInfoCell('mu', 'mu', widget.audioPlayer),
              KulitanInfoCell('muu', 'mú/mû', widget.audioPlayer),
              KulitanInfoCell('me', 'me', widget.audioPlayer),
              KulitanInfoCell('mo', 'mo', widget.audioPlayer),
              KulitanInfoCell('mang', 'mang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('paa', 'pá/pâ', widget.audioPlayer),
              KulitanInfoCell('pi', 'pi', widget.audioPlayer),
              KulitanInfoCell('pii', 'pí/pî', widget.audioPlayer),
              KulitanInfoCell('pu', 'pu', widget.audioPlayer),
              KulitanInfoCell('puu', 'pú/pû', widget.audioPlayer),
              KulitanInfoCell('pe', 'pe', widget.audioPlayer),
              KulitanInfoCell('po', 'po', widget.audioPlayer),
              KulitanInfoCell('pang', 'pang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('baa', 'bá/bâ', widget.audioPlayer),
              KulitanInfoCell('bi', 'bi', widget.audioPlayer),
              KulitanInfoCell('bii', 'bí/bî', widget.audioPlayer),
              KulitanInfoCell('bu', 'bu', widget.audioPlayer),
              KulitanInfoCell('buu', 'bú/bû', widget.audioPlayer),
              KulitanInfoCell('be', 'be', widget.audioPlayer),
              KulitanInfoCell('bo', 'bo', widget.audioPlayer),
              KulitanInfoCell('bang', 'bang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('yaa', 'yá/yâ', widget.audioPlayer),
              KulitanInfoCell('yi', 'yi', widget.audioPlayer),
              KulitanInfoCell('yii', 'yí/yî', widget.audioPlayer),
              KulitanInfoCell('yu', 'yu', widget.audioPlayer),
              KulitanInfoCell('yuu', 'yú/yû', widget.audioPlayer),
              KulitanInfoCell('ye', 'ye', widget.audioPlayer),
              KulitanInfoCell('yo', 'yo', widget.audioPlayer),
              KulitanInfoCell('yang', 'yang', widget.audioPlayer),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('waa', 'wá/wâ', widget.audioPlayer),
              KulitanInfoCell('wi', 'wi', widget.audioPlayer),
              KulitanInfoCell('wii', 'wí/wî', widget.audioPlayer),
              KulitanInfoCell('wu', 'wu', widget.audioPlayer),
              KulitanInfoCell('wuu', 'wú/wû', widget.audioPlayer),
              KulitanInfoCell('we', 'we', widget.audioPlayer),
              KulitanInfoCell('wo', 'wo', widget.audioPlayer),
              KulitanInfoCell('wang', 'wang', widget.audioPlayer),
            ]),
          ],
        ),
      ),
    );
    final Widget _anakSulatVowelTable = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        0.0,
        _screenHorizontalPadding,
        informationVerticalScreenPadding - headerVerticalPadding + 8.0,
      ),
      child: Table(
        defaultColumnWidth: FlexColumnWidth(1.0),
        children: <TableRow>[
          TableRow(children: <Widget>[
            Container(),
            KulitanInfoCell('ya', 'ya', widget.audioPlayer),
            KulitanInfoCell('wa', 'wa', widget.audioPlayer),
            Container(),
          ]),
        ],
      ),
    );


    final Widget _pakamateSiualaTable = Padding(
      padding: EdgeInsets.fromLTRB(
        _screenHorizontalPadding,
        0.0,
        _screenHorizontalPadding,
        informationVerticalScreenPadding - headerVerticalPadding + 8.0,
      ),
      child: Table(
        defaultColumnWidth: FlexColumnWidth(1.0),
        children: <TableRow>[
          TableRow(children: <Widget>[
            KulitanInfoCell('kan', 'kan', widget.audioPlayer),
            KulitanInfoCell('kin', 'kin', widget.audioPlayer),
            KulitanInfoCell('kun', 'kun', widget.audioPlayer),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('kaan', 'kán', widget.audioPlayer),
            KulitanInfoCell('kiin', 'kín', widget.audioPlayer),
            KulitanInfoCell('kuun', 'kún', widget.audioPlayer),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('ken', 'ken', widget.audioPlayer),
            KulitanInfoCell('kon', 'kon', widget.audioPlayer),
            Container(),
          ]),
        ],
      ),
    );

    final _sulatDivider = Padding(
      padding: EdgeInsets.fromLTRB(
        (_screenWidth >= 600 ? maxPageWidth : _screenWidth) * 0.31,
        40.0,
        (_screenWidth >= 600 ? maxPageWidth : _screenWidth) * 0.31,
        22.0,
      ),
      child: DividerNew(
        height: 3.0,
        color: _gameData.getColor('informationDivider'),
        boxShadow: BoxShadow(
          offset: Offset(2.0, 2.0),
          color: _gameData.getColor('informationDividerShadow'),
        ),
      ),
    );

    final Widget _contents = SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              child: Column(
                children: <Widget>[
                  StickyHeading(
                    headingText: 'Kapabaluan',
                    content: Column(
                      children: <Widget>[
                        _historyButton,
                        _writingInstructionsButton,
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: paragraphTopPadding),
                    child: Paragraphs(
                      padding: 0.0,
                      paragraphs: [
                        RomanText('Tap on any syllable to play its sound.'),
                      ],
                    ),
                  ),
                  StickyHeading(
                    headingText: 'Indûng Súlat',
                    content: Column(
                      children: <Widget>[
                        _indungSulatTable,
                        _sulatDivider,
                        _indungSulatVowelTable,
                      ],
                    ),
                  ),
                  StickyHeading(
                    headingText: 'Anak Súlat',
                    content: Container(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: _anakSulatTable,
          ),
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              child: Column(
                children: <Widget>[
                  _sulatDivider,
                  _anakSulatVowelTable,
                  StickyHeading(
                    headingText: 'Pakamaté Siuálâ',
                    content: Column(
                      children: <Widget>[
                        _pakamateSiualaTable,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    List<Widget> _pageStack = [
      _contents,
      _header,
    ];

    if (_showBackToStartFAB) {
      _pageStack.add(
        BackToStartButton(
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration:
                  const Duration(milliseconds: informationPageScrollDuration),
              curve: informationPageScrollCurve,
            );
          },
        ),
      );
    }
    
    return Material(
      color: _gameData.getColor('background'),
      child: SafeArea(
        child: Stack(children: _pageStack),
      ),
    );
  }
}
