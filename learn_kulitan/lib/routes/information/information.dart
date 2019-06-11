import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../styles/theme.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/DividerNew.dart';
import '../../components/misc/StickyHeading.dart';
import '../../db/GameData.dart';
import './components.dart';

class InformationPage extends StatefulWidget {
  const InformationPage();
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
    final double _screenWidth = MediaQuery.of(context).size.width;
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
        right: SizedBox(width: 56.0, height: 48.0),
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
        height: MediaQuery.of(context).size.height > smallHeight ? 60.0 : 50.0,
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
          TableRow(children: const <Widget>[
            KulitanInfoCell('ga', 'ga'),
            KulitanInfoCell('ka', 'ka'),
            KulitanInfoCell('nga', 'nga'),
            KulitanInfoCell('ta', 'ta'),
          ]),
          TableRow(children: const <Widget>[
            KulitanInfoCell('da', 'da'),
            KulitanInfoCell('na', 'na'),
            KulitanInfoCell('la', 'la'),
            KulitanInfoCell('sa', 'sa'),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('ma', 'ma'),
            KulitanInfoCell('pa', 'pa'),
            KulitanInfoCell('ba', 'ba'),
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
          TableRow(children: const <Widget>[
            KulitanInfoCell('a', 'a'),
            KulitanInfoCell('i', 'ka'),
            KulitanInfoCell('u', 'u'),
            KulitanInfoCell('e', 'e'),
            KulitanInfoCell('o', 'o'),
          ]),
          TableRow(children: <Widget>[
            KulitanInfoCell('aa', 'á/â'),
            KulitanInfoCell('ii', 'í/î'),
            KulitanInfoCell('uu', 'ú/û'),
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
        padding: EdgeInsets.fromLTRB(
          _screenHorizontalPadding,
          0.0,
          _screenHorizontalPadding,
          informationVerticalScreenPadding,
        ),
        child: Table(
          defaultColumnWidth: FixedColumnWidth(_cellWidth),
          children: const <TableRow>[
            TableRow(children: <Widget>[
              KulitanInfoCell('gaa', 'gá/gâ'),
              KulitanInfoCell('gi', 'gi'),
              KulitanInfoCell('gii', 'gí/gî'),
              KulitanInfoCell('gu', 'gu'),
              KulitanInfoCell('guu', 'gú/gû'),
              KulitanInfoCell('ge', 'ge'),
              KulitanInfoCell('go', 'go'),
              KulitanInfoCell('gang', 'gang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('kaa', 'ká/kâ'),
              KulitanInfoCell('ki', 'ki'),
              KulitanInfoCell('kii', 'kí/kî'),
              KulitanInfoCell('ku', 'ku'),
              KulitanInfoCell('kuu', 'kú/kû'),
              KulitanInfoCell('ke', 'ke'),
              KulitanInfoCell('ko', 'ko'),
              KulitanInfoCell('kang', 'kang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('ngaa', 'ngá/ngâ'),
              KulitanInfoCell('ngi', 'ngi'),
              KulitanInfoCell('ngii', 'ngí/ngî'),
              KulitanInfoCell('ngu', 'ngu'),
              KulitanInfoCell('nguu', 'ngú/ngû'),
              KulitanInfoCell('nge', 'nge'),
              KulitanInfoCell('ngo', 'ngo'),
              KulitanInfoCell('ngang', 'ngang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('taa', 'tá/tâ'),
              KulitanInfoCell('ti', 'ti'),
              KulitanInfoCell('tii', 'tí/tî'),
              KulitanInfoCell('tu', 'tu'),
              KulitanInfoCell('tuu', 'tú/tû'),
              KulitanInfoCell('te', 'te'),
              KulitanInfoCell('to', 'to'),
              KulitanInfoCell('tang', 'tang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('daa', 'dá/dâ'),
              KulitanInfoCell('di', 'di'),
              KulitanInfoCell('dii', 'dí/dî'),
              KulitanInfoCell('du', 'du'),
              KulitanInfoCell('duu', 'dú/dû'),
              KulitanInfoCell('de', 'de'),
              KulitanInfoCell('do', 'do'),
              KulitanInfoCell('dang', 'dang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('naa', 'ná/nâ'),
              KulitanInfoCell('ni', 'ni'),
              KulitanInfoCell('nii', 'ní/nî'),
              KulitanInfoCell('nu', 'nu'),
              KulitanInfoCell('nuu', 'nú/nû'),
              KulitanInfoCell('ne', 'ne'),
              KulitanInfoCell('no', 'no'),
              KulitanInfoCell('nang', 'nang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('laa', 'lá/lâ'),
              KulitanInfoCell('li', 'li'),
              KulitanInfoCell('lii', 'lí/lî'),
              KulitanInfoCell('lu', 'lu'),
              KulitanInfoCell('luu', 'lú/lû'),
              KulitanInfoCell('le', 'le'),
              KulitanInfoCell('lo', 'lo'),
              KulitanInfoCell('lang', 'lang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('saa', 'sá/sâ'),
              KulitanInfoCell('si', 'si'),
              KulitanInfoCell('sii', 'sí/sî'),
              KulitanInfoCell('su', 'su'),
              KulitanInfoCell('suu', 'sú/sû'),
              KulitanInfoCell('se', 'se'),
              KulitanInfoCell('so', 'so'),
              KulitanInfoCell('sang', 'sang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('maa', 'má/mâ'),
              KulitanInfoCell('mi', 'mi'),
              KulitanInfoCell('mii', 'mí/mî'),
              KulitanInfoCell('mu', 'mu'),
              KulitanInfoCell('muu', 'mú/mû'),
              KulitanInfoCell('me', 'me'),
              KulitanInfoCell('mo', 'mo'),
              KulitanInfoCell('mang', 'mang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('paa', 'pá/pâ'),
              KulitanInfoCell('pi', 'pi'),
              KulitanInfoCell('pii', 'pí/pî'),
              KulitanInfoCell('pu', 'pu'),
              KulitanInfoCell('puu', 'pú/pû'),
              KulitanInfoCell('pe', 'pe'),
              KulitanInfoCell('po', 'po'),
              KulitanInfoCell('pang', 'pang'),
            ]),
            TableRow(children: <Widget>[
              KulitanInfoCell('baa', 'bá/bâ'),
              KulitanInfoCell('bi', 'bi'),
              KulitanInfoCell('bii', 'bí/bî'),
              KulitanInfoCell('bu', 'bu'),
              KulitanInfoCell('buu', 'bú/bû'),
              KulitanInfoCell('be', 'be'),
              KulitanInfoCell('bo', 'bo'),
              KulitanInfoCell('bang', 'bang'),
            ]),
          ],
        ),
      ),
    );

    final _indungSulatDivider = Padding(
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
                  StickyHeading(
                    headingText: 'Indûng Súlat',
                    content: Column(
                      children: <Widget>[
                        _indungSulatTable,
                        _indungSulatDivider,
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
          )
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
        child: Stack(
          children: _pageStack,
        ),
      ),
    );
  }
}
