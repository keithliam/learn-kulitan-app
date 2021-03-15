import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:firebase_analytics/observer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/RoundedBackButton.dart';
import '../../../components/buttons/BackToStartButton.dart';
import '../../../components/buttons/GuideButton.dart';
import '../../../components/misc/StaticHeader.dart';
import '../../../components/misc/ImageWithCaption.dart';
import '../../../components/misc/Paragraphs.dart';
import '../../../db/GameData.dart';

class WritingGuidePage extends StatefulWidget {
  const WritingGuidePage({ @required this.firebaseObserver });

  final FirebaseAnalyticsObserver firebaseObserver;

  @override
  _WritingGuidePageState createState() => _WritingGuidePageState();
}

class _WritingGuidePageState extends State<WritingGuidePage> {
  static final GameData _gameData = GameData();
  final PageController _pageController = PageController();

  Timer _analyticsTimer;
  int _page;
  bool _showBackToStartFAB = false;


  void _attemptPushAnalytics() {
    if (_analyticsTimer != null) _analyticsTimer.cancel();

    _analyticsTimer = Timer(Duration(milliseconds: informationPageScrollDuration), () {
      widget.firebaseObserver.analytics.setCurrentScreen(
        screenName: '/information/guide/$_page',
      );
      _analyticsTimer = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _page = 0;
    _pageController
      ..addListener(() {
        final int _currentPage = _pageController.page.round();
        if (_page != _currentPage) {
          _page = _currentPage;
          _attemptPushAnalytics();
        }
        if (_currentPage == 0)
          setState(() => _showBackToStartFAB = false);
        else
          setState(() => _showBackToStartFAB = true);
      });
  }

  @override
  void dispose() {
    _analyticsTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open webpage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenHorizontalPadding = _mediaQuery.size.width > maxPageWidth ? 0.0 : informationHorizontalScreenPadding;
    final double _width = _mediaQuery.size.width > maxPageWidth ? maxPageWidth : _mediaQuery.size.width;


    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final Widget _pageCredits = Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: informationCreditsHorizontalPadding,
        vertical: informationCreditsVerticalPadding,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: RichText(
            text: TextSpan(
              style: _gameData.getStyle('textInfoCredits'),
              children: <TextSpan>[
                TextSpan(text: 'Written by Siuálâ Ding Meángûbié. '),
                TextSpan(
                  text: 'Learn more',
                  style: _gameData.getStyle('textInfoCreditsLink'),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-Siuala'),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ),
    );

    final Widget _poemKapampangan = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: paragraphTopPadding),
      child: Text(
        'Anting Aldó síslag banua,\nKéti súlip áslagan na.\nSisílang ya king Aláya,\nKing Pinatúbû lulbug ya.',
        textAlign: TextAlign.center,
        style: _gameData.getStyle('textInfoTextItalic'),
      ),
    );

    final Widget _poemEnglish = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: paragraphTopPadding),
      child: Text(
        'Like the Sun that shines from heaven,\nIts radiance reaches down on earth.\nRising from Bunduk Aláya,\nIt descends on Mount Pinatubo.',
        textAlign: TextAlign.center,
        style: _gameData.getStyle('textInfoTextItalic'),
      ),
    );

    final List<List<Widget>> _guideList = [
      // Table of Contents
      [
        GuideButton(
          pageNumber: 1,
          text: 'Writing Direction',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 2,
          text: 'Indú at Anak',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 3,
          text: 'Indûng Súlat a Mágkas',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 4,
          text: 'Indûng Súlat a Sisiuálâ',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 5,
          text: 'Anak Súlat',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 6,
          text: 'Pámanganak ning Indûng Súlat king Siuálâng `I`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 7,
          text: 'Pámanganak ning Indûng Súlat king Siuálâng `U`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 8,
          text: 'Ding Ának ning Indûng Súlat a `I`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 9,
          text: 'Ding Ának ning Indûng Súlat a `U`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 10,
          text: 'Pámanganak ning Indûng Súlat king Siuálâng `E`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 11,
          text: 'Pámanganak ning Indûng Súlat king Siuálâng `O`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 12,
          text: 'Ding Kambal Siuálâ',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 13,
          text: 'Kambal Siuálâ `A`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 14,
          text: 'Kambal Siuálâ `I`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 15,
          text: 'Kambal Siuálâ `U`',
          controller: _pageController,
        ),
        GuideButton(
          pageNumber: 16,
          text: 'Pámakamaté Siuálâ',
          controller: _pageController,
        ),
      ],

      // Introduction: Poem
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kulitan_direction_poem.png',
            screenWidth: _width,
            hasPadding: false,
            caption: TextSpan(
              style: _gameData.getStyle('textInfoImageCaption'),
              children: <TextSpan>[
                TextSpan(text: 'Figure 1. ', style: _gameData.getStyle('textInfoImageCaptionItalic')),
                TextSpan(text: 'The Kapampangan verse that explains why '),
                TextSpan(text: 'Kulitan', style: _gameData.getStyle('textInfoImageCaptionItalic')),
                TextSpan(text: ' is written top to bottom, right to left.'),
              ],
            ),
          ),
        ),
        _poemKapampangan,
        _poemEnglish,
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText('The first two lines refer to '),
                ItalicRomanText('Kulitan'),
                RomanText(
                    ' being written vertically top to bottom. The rays of the sun spreads down to earth from the heavens, hence top to bottom. The last two lines refer to '),
                ItalicRomanText('Kulitan'),
                RomanText(
                    ' being written left to right. When facing the North Star or '),
                ItalicRomanText('Tálâng Úgut'),
                RomanText(
                    ', Bunduk Aláya on the East sits on your right hand while Bunduk Pinatúbû on the West sits on your left, thus explaining the writing direction from right to left.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'pamagkulit.png',
          caption: TextSpan(text: 'PÁMAGKULIT', style: _gameData.getStyle('textInfoImageCaption')),
          subcaption: 'WRITING RULES',
          screenWidth: _width,
        ),
      ],

      // Indu at Anak
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'indu_at_anak.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption:
                TextSpan(text: 'INDÛ AT ANAK', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Mother and Child',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              style: _gameData.getStyle('textInfoText'),
              children: <TextSpan>[
                RomanText('Kulitan is basically made up of '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' or the “mother” characters and the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' or the “offspring” characters. The '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' are the base characters with the unaltered inherent vowel sounds. They are the building blocks of Súlat Kapampángan. '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' gives birth to '),
                ItalicRomanText('Anak Súlat'),
                RomanText(
                    ' or “offspring” characters whenever their inherent vowel sound has been altered by a ligature or a diacritical mark.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('The '),
                ItalicRomanText('Siuálâ'),
                RomanText(
                    ' or vowels in Súlat Kapampángan are usually written as '),
                ItalicRomanText('garlit'),
                RomanText(
                    ' or diacritical marks placed above or below an individual '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' or “mother” character. Ligatures are also sometimes used to further lengthen these vowel sounds. A glyph with a diacritical mark or ligature attached to it is an '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' or offspring character.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('The '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' characters are divided into two groups: the consonantal glyphs or '),
                ItalicRomanText('Kulit a Mágkas'),
                RomanText(' or '),
                ItalicRomanText('Kulit a Makikatnî'),
                RomanText(
                    ' (Hilario, 1962) and the independent vowel glyphs or '),
                ItalicRomanText('Kulit a Siuálâ'),
                RomanText('. The '),
                ItalicRomanText('Kulit a Siuálâ'),
                RomanText(' or vowel glyphs are not the same as the '),
                ItalicRomanText('garlit'),
                RomanText(' or diacritical marks.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('The recital order of the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' or basic mother characters are A, I, U, E, O, GA, KA, NGA, TA, DA, NA, LA, SA, MA, PA, BA.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'kulitan_table.jpeg',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Indûng Súlat a Mágkas
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kulit_a_magkas.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'INDÛNG SÚLAT: KULIT A MÁGKAS',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'The Consonantal Characters',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              style: _gameData.getStyle('textInfoText'),
              children: <TextSpan>[
                RomanText('There are eleven '),
                ItalicRomanText('Kulit a Mágkas'),
                RomanText(
                    ' or consonantal glyphs in Kulitan, the recital order of which are GA, KA, NGA, TA, DA, NA, LA, SA, MA, PA, BA. They are however arranged and usually grouped together as follows [Table 1]:'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'kulit_a_magkas_table.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(text: 'Table 1.', style: _gameData.getStyle('textInfoImageCaptionItalic')),
              TextSpan(text: ' The '),
              TextSpan(
                  text: 'kulit a mágkas', style: _gameData.getStyle('textInfoImageCaptionItalic')),
              TextSpan(
                  text:
                      ' or Kulitan consonantal characters in their natural arrangement, read from the right column going to the left.'),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(10.0, paragraphTopPadding, 10.0, 0.0),
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText('a.  Kulit ngágkas king akmúlan '),
                    RomanText('(velar): GA ('),
                    KulitanText('ga'),
                    RomanText(') and KA ('),
                    KulitanText('ka'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText('b.  Kulit ngágkas king árung '),
                    RomanText('(nasal): NGA ('),
                    KulitanText('nga'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText('c.  Kulit ngágkas king ípan '),
                    RomanText('(dental): NTAGA ('),
                    KulitanText('ta'),
                    RomanText(') and NA ('),
                    KulitanText('na'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText(
                        'd.  Kulit ngágkas king ípan a déla king dílâ '),
                    RomanText('(alveolar): DA/RA ('),
                    KulitanText('da'),
                    RomanText(') and LA ('),
                    KulitanText('la'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText(
                        'e.  Kulit ngágkas pasalitsit king ípan '),
                    RomanText('(fricative): SA ('),
                    KulitanText('sa'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText('f.  Kulit ngágkas king lábî '),
                    RomanText('(bilabial): MA ('),
                    KulitanText('ma'),
                    RomanText(') and PA ('),
                    KulitanText('pa'),
                    RomanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    ItalicRomanText('g.  Kulit ngágkas patiúp king lábî '),
                    RomanText('(aspirated bilabial): BA ('),
                    KulitanText('ba'),
                    RomanText(').'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'The consonantal syllables WA and YA are represented by the '),
                ItalicRomanText('Kulit a Siuálâ'),
                RomanText(' or vowel glyphs U ('),
                KulitanText('u'),
                RomanText(') and I ('),
                KulitanText('i'),
                RomanText(
                    ') respectively (Benavente, 1699 and Hilario, 1962). Like their consonant counterparts in the other scripts of the archipelago, these '),
                ItalicRomanText('Kulit a Siuálâ'),
                RomanText(' can be altered by placing a '),
                ItalicRomanText('garlit'),
                RomanText(
                    ' or diacritical mark above or below the glyph to form “offspring” characters or '),
                ItalicRomanText('Anak Súlat'),
                RomanText(
                    '. This will be explained further in the following sections of this chapter.'),
              ],
            ),
          ],
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'While all other glyphs in the other indigenous scripts within the archipelago resemble one another, Kulitan has also developed unique and distinct character shapes that are different from Baybayin, particularly the '),
                ItalicRomanText('Kulit Mágkas'),
                RomanText(' or consonantal characters Ga ('),
                KulitanText('ga'),
                RomanText('), Ta ('),
                KulitanText('ta'),
                RomanText('), Sa ('),
                KulitanText('sa'),
                RomanText(
                    ') that are consistent in appearance in the various '),
                ItalicRomanText('cuadernos'),
                RomanText(' and '),
                ItalicRomanText('abecedarios'),
                RomanText(
                    ' that have appeared during the Spanish era (Benavente, 1699; Mas, 1842 and Marcilla, 1895) and the modern era (Hilario, 1962, Henson, 1965 and Pangilinan, 1995), and the plain vertical line for LA found in several 17\u1d57\u02b0 century Kapampangan signatures (Miller, 2010 and 2012b).'),
              ],
            ),
          ],
        ),
      ],

      // Indûng Súlat a Sisiuálâ
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kulit_a_sisiuala.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'INDÛNG SÚLAT: KULIT A SISIUÁLÂ',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'The Vowel Characters',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText('For vowels as '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' or independent syllable glyphs, Kulitan has three basic '),
                ItalicRomanText('Kulit a Siuálâ'),
                RomanText(' or vowel characters. These are A ('),
                KulitanText('a'),
                RomanText('), I ('),
                KulitanText('i'),
                RomanText('), and U ('),
                KulitanText('u'),
                RomanText(').'),
                ItalicRomanText('bábo'),
                RomanText(' (above), '),
                ItalicRomanText('sabó'),
                RomanText(' (soup or justice) and '),
                ItalicRomanText('ulimó'),
                RomanText(' (tiger) all used to be pronounced as '),
                ItalicRomanText('bábau'),
                RomanText(', '),
                ItalicRomanText('sabáu'),
                RomanText(' and '),
                ItalicRomanText('ulimau'),
                RomanText('. Thus the vowel O is still written as AU ('),
                ItalicRomanText('oo'),
                RomanText(') in Kulitan.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'kulit_a_sisiuala_table.png',
          orientation: Axis.horizontal,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(
                text: 'Table 2',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. The '),
              TextSpan(text: 'kulit a siuálâ'),
              TextSpan(text: ' or Kulitan vowel glyphs.'),
            ],
          ),
          subcaption: 'The Vowel Characters',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'However, the Kapampangan language has two monophthongized diphthongs (Gonzales, 1972). These became the vowels E and O and are represented by the “'),
                ItalicRomanText('aduang kulit a máging metung mû'),
                RomanText('” (Hilario, 1962) or '),
                ItalicRomanText('Miyasáuang Kulit'),
                RomanText(' or “married” or “coupled” vowels E ('),
                KulitanText('ee'),
                RomanText('), and O ('),
                KulitanText('oo'),
                RomanText(
                    ') [Table 2]. Unlike other Philippine languages, the Kapampangan language does not interchange the vowels I and E since E is a monophthongized diphthong. Kapampangan words ending in the vowel E like '),
                ItalicRomanText('bale'),
                RomanText(' (house), '),
                ItalicRomanText('pále'),
                RomanText(' (unhusked rice) and '),
                ItalicRomanText('sále'),
                RomanText(' (nest) used to be pronounced as '),
                ItalicRomanText('balai'),
                RomanText(', '),
                ItalicRomanText('pálai'),
                RomanText(' and '),
                ItalicRomanText('sálai'),
                RomanText('. Thus the vowel E is still written as AI ('),
                KulitanText('ee'),
                RomanText(
                    ') in Kulitan. Likewise, the Kapampangan language does not interchange the vowels U with O since O is also a monophthongized diphthong. The Kapampangan words that end in O like '),
                ItalicRomanText('bábo'),
                RomanText(
                    ') in Kulitan. Likewise, the Kapampangan language does not interchange the vowels U with O since O is also a monophthongized diphthong. The Kapampangan words that end in O like '),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('The '),
                ItalicRomanText('Kambal Siuálâ'),
                RomanText(
                    ' or “twin” vowels seen on Table 2 represent the lengthening of the vowel sounds and the glottal stops in the Kapampangan language. These are usually represented by the diacritical marks '),
                ItalicRomanText('sakúrut'),
                RomanText(' ( ́) and '),
                ItalicRomanText('télaturung'),
                RomanText(
                    ' (^) when writing the Kapampangan language in the Latin script. When they stand alone, the '),
                ItalicRomanText('kambal siuálâ'),
                RomanText(' or “twin” vowels are as follows: –Á-/-Â ('),
                KulitanText('aa'),
                RomanText(' ), -Í-/-Î ('),
                KulitanText('ii'),
                RomanText(') and –Ú-/-Û ('),
                KulitanText('uu'),
                RomanText(').')
              ],
            ),
          ],
        ),
      ],

      // Anak Súlat
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'anak_sulat.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(text: 'ANAK SÚLAT', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'The offspring character',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'As mentioned earlier, all of the consonantal characters in Kulitan possess the inherent vowel sound ‘A’. On their own they are known as '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(
                    ' or mother characters. To alter their default vowel sounds and produce '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' or offspring characters, one simply places the '),
                ItalicRomanText('garlit'),
                RomanText(
                    ' or diacritical marks above or below or place a ligature character next to the mother character. Again, the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(
                    ' or offspring characters are those characters with their inherent vowel sounds altered by the diacritical marks or ligatures [Table 3a & 3b].'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_table.png',
          orientation: Axis.horizontal,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Table 3a',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. The ', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'anak súlat',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'indûng súlat',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: ' SA (', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'sa',
                style: _gameData.getStyle('textInfoImageCaptionKulitan'),
              ),
              TextSpan(text: ').', style: _gameData.getStyle('textInfoImageCaption')),
            ],
          ),
          screenWidth: _width,
        ),
        ImageWithCaption(
          filename: 'indu_anak_table.jpeg',
          orientation: Axis.horizontal,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Table 3b',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. Table of ', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'Indûng Súlat',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: ' and their ', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'Anak Súlat',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '.', style: _gameData.getStyle('textInfoImageCaption')),
            ],
          ),
          screenWidth: _width,
        ),
      ],

      // Pámanganak Ning Indûng Súlat King Siuálâng `I`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'pamanganak.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            captionAlignment: TextAlign.center,
            caption: TextSpan(
                text: 'PÁMANGANAK NING INDÛNG SÚLAT\nKING SIUÁLÂNG ‘I’',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Changing the default vowel sound `A` to `I`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'To change the default ‘A’ sound of any of the consonantal characters to ‘I’, simply place a '),
                ItalicRomanText('garlit'),
                RomanText(' or diacritical mark above it. For example, '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' KA ('),
                KulitanText('ka'),
                RomanText(') becomes '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KI ('),
                KulitanText('ki'),
                RomanText(') by placing the '),
                ItalicRomanText('garlit'),
                RomanText(' (’) above it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_diagram_1.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Pámanganak Ning Indûng Súlat King Siuálâng `U`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'pamanganak.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            captionAlignment: TextAlign.center,
            caption: TextSpan(
                text: 'PÁMANGANAK NING INDÛNG SÚLAT\nKING SIUÁLÂNG ‘U’',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Changing the default vowel sound `A` to `U`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'To change the default ‘A’ sound of any of the consonantal characters to ‘U’, simply place a '),
                ItalicRomanText('garlit'),
                RomanText(' ‘dot’ or ‘stroke’ below it. For example, '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' KA ('),
                KulitanText('ka'),
                RomanText(') becomes '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KU ('),
                KulitanText('ku'),
                RomanText(') by placing the '),
                ItalicRomanText('garlit'),
                RomanText(' (’) below it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_diagram_2.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Ding Ának ning Indûng Súlat A `I`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'anak_a_i_u.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'DING ÁNAK NING INDÛNG SÚLAT A `I` (',
                    style: _gameData.getStyle('textInfoImageCaption')),
                TextSpan(
                    text: 'i',
                    style: _gameData.getStyle('textInfoImageCaption').copyWith(
                        fontFamily: 'Kulitan Semi Bold')),
                TextSpan(text: ')', style: _gameData.getStyle('textInfoImageCaption')),
              ],
            ),
            subcaption: 'Altering the vowel glyph I as the consonant Y',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'One of the features that make Súlat Kapampángan different from the other indigenous scripts of these islands is the way the vowel glyph I ('),
                KulitanText('i'),
                RomanText(
                    ') can alter it in the same manner as the consonant glyph YA found in Baybayin and other scripts of the archipelago. Although personally I think the Kapampangan vowel glyph I ('),
                KulitanText('i'),
                RomanText(
                    ') is really the consonant glyph YA acting as a vowel glyph. They actually look very similar especially when the Kapampangan character is written in cursive form. As explained by Fray Alvaro de Benavente (1699) in his '),
                ItalicRomanText('Arte de Lengua Pampanga'),
                RomanText(' and by Zoilo Hilario (1962) in his '),
                ItalicRomanText('Báyung Súnis'),
                RomanText(', the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' or “mother character” vowel I ('),
                KulitanText('i'),
                RomanText(') can be altered with the use of a '),
                ItalicRomanText('garlit'),
                RomanText(
                    ' or diacritical mark placed above or below it as well as adding vowel ligatures next to it to produce '),
                ItalicRomanText('Anak Súlat'),
                RomanText(
                    ' or offspring characters of the consonant sound Y. For instance the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' I ('),
                KulitanText('i'),
                RomanText(') can produce the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' YI ('),
                KulitanText('yi'),
                RomanText(') by placing a '),
                ItalicRomanText('garlit'),
                RomanText(' above it and the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' YU ('),
                KulitanText('yu'),
                RomanText(') by placing the '),
                ItalicRomanText('garlit'),
                RomanText(' below it [Table 4].'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_i_a_table.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Table 4',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. The ', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'anak kulit',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(text: 'indung kulit', style: _gameData.getStyle('textInfoImageCaptionItalic')),
              TextSpan(text: ' I (', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'i',
                style: _gameData.getStyle('textInfoImageCaptionKulitan'),
              ),
              TextSpan(text: ').', style: _gameData.getStyle('textInfoImageCaption')),
            ],
          ),
        ),
      ],

      // Ding Ának ning Indûng Súlat A `U`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'anak_a_i_u.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'DING ÁNAK NING INDÛNG SÚLAT A `U` (',
                    style: _gameData.getStyle('textInfoImageCaption')),
                TextSpan(
                    text: 'u',
                    style: _gameData.getStyle('textInfoImageCaption').copyWith(
                        fontFamily: 'Kulitan Semi Bold')),
                TextSpan(text: ')', style: _gameData.getStyle('textInfoImageCaption')),
              ],
            ),
            subcaption: 'Altering the vowel glyph U as the consonant W',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Again, one of the unique features of Súlat Kapampángan is the way the vowel glyph U ('),
                KulitanText('u'),
                RomanText(
                    ') can be altered in the same manner as the consonant glyph WA  found in Baybayin and the other scripts of the archipelago. I personally think that the Kapampangan vowel glyph U ('),
                KulitanText('u'),
                RomanText(
                    ') may actually be the consonant glyph WA acting as a vowel glyph. Christopher Miller (2011b) also noted the similarity in shape of the Baybayin WA with Kapampangan U ('),
                KulitanText('u'),
                RomanText(
                    '). In Kulitan, WA is usually written by combining the vowels characters U ( '),
                KulitanText('u'),
                RomanText(') and A ('),
                KulitanText('a'),
                RomanText(
                    ') [Table 5] but surprisingly the vowel character U ('),
                KulitanText('u'),
                RomanText(') stood alone without the vowel A ('),
                KulitanText('a'),
                RomanText(
                    ') in the 1621 signature of Doña Isabel Pangisnauan of Mexico (Masíku). Could this be proof that Kapampangan vowel character U may actually be the consonantal character WA?'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'As explained by Fray Alvaro de Benavente (1699) in his '),
                ItalicRomanText('Arte de Lengua Pampanga'),
                RomanText(' and by Zoilo Hilario (1962) in his '),
                ItalicRomanText('Báyung Súnis'),
                RomanText(', the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' or “mother character” vowel U ('),
                KulitanText('u'),
                RomanText(') can be altered with the use of a '),
                ItalicRomanText('garlit'),
                RomanText(
                    ' or diacritical mark placed above or below it as well as adding vowel ligatures next to it to produce '),
                ItalicRomanText('Anak Súlat'),
                RomanText(
                    ' or offspring characters of the consonant sound W. For instance the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' U ('),
                KulitanText('u'),
                RomanText(') can produce the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' WI ('),
                KulitanText('wi'),
                RomanText(') by placing a '),
                ItalicRomanText('garlit'),
                RomanText(' above it and the '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' WU ('),
                KulitanText('wu'),
                RomanText(') by placing the '),
                ItalicRomanText('garlit'),
                RomanText(' below it [Table 5].'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_u_a_table.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Table 5',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. The ', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'anak kulit',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(text: 'indung kulit', style: _gameData.getStyle('textInfoImageCaptionItalic')),
              TextSpan(text: ' U (', style: _gameData.getStyle('textInfoImageCaption')),
              TextSpan(
                text: 'u',
                style: _gameData.getStyle('textInfoImageCaptionKulitan'),
              ),
              TextSpan(text: ').', style: _gameData.getStyle('textInfoImageCaption')),
            ],
          ),
        ),
      ],

      // Pámanganak Ning Indûng Súlat King Siuálâng `E`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'pamanganak.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            captionAlignment: TextAlign.center,
            caption: TextSpan(
                text: 'PÁMANGANAK NING INDÛNG SÚLAT\nKING SIUÁLÂNG ‘E’',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Changing the default vowel sound `A` to `E`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Since the Kapampangan vowel sound ‘E’ was developed from the monophthongisation of the diphthong ‘AI’, simply place the whole vowel glyph I ('),
                KulitanText('i'),
                RomanText(
                    ') right next to the target consonantal glyph to change its inherent vowel sound ‘A’ to ‘E’. For example, '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' KA ('),
                KulitanText('ka'),
                RomanText(') becomes '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KE ('),
                KulitanText('ke'),
                RomanText(') by placing the vowel character I ('),
                KulitanText('i'),
                RomanText(') right after it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_diagram_3.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Pámanganak Ning Indûng Súlat King Siuálâng `O`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'pamanganak.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            captionAlignment: TextAlign.center,
            caption: TextSpan(
                text: 'PÁMANGANAK NING INDÛNG SÚLAT\nKING SIUÁLÂNG ‘O’',
                style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Changing the default vowel sound ‘A’ to ‘O’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Since the Kapampangan vowel sound ‘O’ was developed from the monophthongisation of the diphthong ‘AU’, simply place the whole vowel glyph U ('),
                KulitanText('u'),
                RomanText(
                    ') right next to the target consonantal glyph to change its inherent vowel sound ‘A’ to ‘O’. For example, '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' KA ('),
                KulitanText('ka'),
                RomanText(') becomes '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KO ('),
                KulitanText('ko'),
                RomanText(') by placing the vowel character U ('),
                KulitanText('u'),
                RomanText(') right after it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'anak_sulat_diagram_4.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Ding Kambal Siuálâ
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kambal_siuala.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'DING KAMBAL SIUÁLÂ', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Stress and Accents in Kulitan',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText('The'),
                ItalicRomanText('Kambal Siuálâ'),
                RomanText(
                    ' or the lengthening of the vowel sounds in the Kapampangan language indicate the stress emphasis given to one or more syllables in a word. The accents or stress in the Kapampangan language or often lexical in nature. In Kapampangan, there are usually two or more words that are spelled similarly when written in the Latin script. Their meanings are different however depending on which syllable the emphasis falls. Strictly speaking, words having different accents, even if they are spelled the same way, are not the same word (Bachuber, 1952). In the Kapampangan language, a shift in stress may indicate a change in numbers among nouns, a change in tense among verbs, or even a change in the parts of speech (Hilario, 1962, Henson, 1965 and Pangilinan, 2006).'),
              ],
            ),
            RomanText(
                'The following classic example comes from Mariano Henson (1965):'),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: paragraphTopPadding),
          constraints: BoxConstraints(maxWidth: maxPageWidth),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width: 0.5 * _width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('masákit\nmásakit\nmasakit',
                        style: _gameData.getStyle('textInfoTextItalic')),
                  ),
                  Expanded(
                    child: Text('‘difficult’\n‘infirm’\n‘painful’',
                        style: _gameData.getStyle('textInfoText')),
                  ),
                  Expanded(
                    child: Text(
                      '(ADJ.)\n(N.)\n(ADJ.)',
                      style: _gameData.getStyle('textInfoText'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            RomanText(
                'In the Latin script, stress is indicated by the indispensable use of the diacritical marks. A misplacement of these marks could result in a fallacy of accent, or the confusion of one word with another due to similarity in spelling but with a different reading.'),
          ],
        ),
        ImageWithCaption(
          filename: 'kambal_siuala_examples.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'In Kulitan however, the placement of stress in a syllable is quite evident because of the '),
                ItalicRomanText('Kambal Siuálâ'),
                RomanText(
                    '. Unlike the Latin script, no two words are spelled the same way in Kulitan. Notice Mariano Henson’s examples again written in Kulitan above. Unlike in the Latin script, none of the three words in the examples are spelled the same way in Kulitan. The placement extra glyph ‘A’ ('),
                KulitanText('a'),
                RomanText(') to form the '),
                ItalicRomanText('Kambal Siuálâ'),
                RomanText(' –Á-/-Â ('),
                KulitanText('aa'),
                RomanText(') can be readily seen.'),
              ],
            ),
          ],
        ),
      ],

      // Kambal Siuálâ `A`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kambal_siuala.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'KAMBAL SIUÁLÂ ‘A’', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Lengthening the inherent vowel ‘A’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText('Since all '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' vowel character A ('),
                KulitanText('a'),
                RomanText(') right after the target glyph. For example, KA ('),
                KulitanText('ka'),
                RomanText(') becomes medial KÁ ('),
                KulitanText('kaa'),
                RomanText(') or final KÂ ('),
                KulitanText('kaa'),
                RomanText(') by placing the vowel character A ('),
                KulitanText('a'),
                RomanText(') right after it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'kambal_siuala_diagram_1.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Kambal Siuálâ `I`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kambal_siuala.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'KAMBAL SIUÁLÂ ‘I’', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Lengthening the offspring vowel sound ‘I’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'The vowel sound ‘I’ of an Anak Súlat or offspring character can further be lengthened simply by adding the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' vowel character I ('),
                KulitanText('i'),
                RomanText(') right after the target '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' or offspring character. For example, '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KI ('),
                KulitanText('ki'),
                RomanText(') gives birth to another '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' ~ the medial KÍ ('),
                KulitanText('kii'),
                RomanText(') or final KÎ ('),
                KulitanText('kii'),
                RomanText('), by placing '),
                ItalicRomanText('Indúng Súlat'),
                RomanText(' vowel character I ('),
                KulitanText('i'),
                RomanText(') right after it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'kambal_siuala_diagram_2.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Kambal Siuálâ `U`
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'kambal_siuala.png',
            hasPadding: false,
            orientation: Axis.horizontal,
            caption: TextSpan(
                text: 'KAMBAL SIUÁLÂ ‘U’', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Lengthening the offspring vowel sound ‘U’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'The vowel sound ‘U’ of an Anak Súlat or offspring character can further be lengthened simply by adding the '),
                ItalicRomanText('Indûng Súlat'),
                RomanText(' vowel character U ('),
                KulitanText('u'),
                RomanText(') right after the target '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' or offspring character. For example, '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' KU ('),
                KulitanText('ku'),
                RomanText(') becomes another '),
                ItalicRomanText('Anak Súlat'),
                RomanText(' ~ the medial KÚ ('),
                KulitanText('kuu'),
                RomanText('), by placing '),
                ItalicRomanText('Indúng Súlat'),
                RomanText(' vowel character U ('),
                KulitanText('u'),
                RomanText(') right after it.'),
              ],
            ),
            RomanText('Example diagram:'),
          ],
        ),
        ImageWithCaption(
          filename: 'kambal_siuala_diagram_3.png',
          orientation: Axis.horizontal,
          screenWidth: _width,
        ),
      ],

      // Pámakamaté Siuálâ
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'pamakamate_siuala.png',
            hasPadding: false,
            caption: TextSpan(
                text: 'PÁMAKAMATÉ SIUÁLÂ', style: _gameData.getStyle('textInfoImageCaption')),
            subcaption: 'Terminating the default vowel sound',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'There are two things that actually make Súlat Kapampángan different from all other scripts within the archipelago: First, it is the only script in the archipelago that is traditionally and preferably written vertically top to bottom, left to right, similar to other East Asian scripts. Second, Súlat Kapampángan is also the only script in the archipelago that has managed to create a spelling convention where the final consonant glyph is retained minus its inherent vowel sound ‘A’ without using a '),
                ItalicRomanText('virama'),
                RomanText(
                    ' (vowel killer). This spelling convention has been observed as early as the 17\u1d57\u02b0 century based on several Kapampángan signatures from that era (Miller, 2010 and 2011a). While the other indigenous scripts in the archipelago either dropped the coda consonant in the same manner as the Bugis-Makasarese scripts of Indonesia (Miller, 2011a and 2012) or use the '),
                ItalicRomanText('virama'),
                RomanText(
                    ' or “vowel killer” in the form of a “cross kudlit” introduced by the Spanish friar Francisco Lopez in 1620 (Marcilla, 1895), the final consonant glyph is written out in full in Súlat Kapampángan but is read without the default vowel sound ‘A’.'),
              ],
            ),
            RomanText(
                'The only way to appreciate how this is done is by writing Súlat Kapampángan vertically instead of horizontally. To terminate the inherent vowel sound ‘A’ of any of the consonantal glyphs, simply write the target character next to the one preceding it instead of below it. This will terminate its default vowel sound.'),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'For instance on [Table 6], to terminate the inherent ‘A’ sound of NA ('),
                KulitanText('na'),
                RomanText(') in ‘NGANA’ simply write NA ('),
                KulitanText('na'),
                RomanText(') right next to NGA ('),
                KulitanText('nga'),
                RomanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of NA ('),
                KulitanText('na'),
                RomanText('), creating the syllable ‘NGAN’.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('To terminate the inherent ‘A’ sound of NGA ('),
                KulitanText('nga'),
                RomanText(') in the word ‘SANGA’, simply write NGA ('),
                KulitanText('nga'),
                RomanText(') right next to SA ('),
                KulitanText('sa'),
                RomanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of NGA ('),
                KulitanText('nga'),
                RomanText('), creating the syllable ‘SANG’.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('To terminate the inherent ‘A’ sound of SA ('),
                KulitanText('sa'),
                RomanText(') in the ‘BUSA’, simply write SA ('),
                KulitanText('sa'),
                RomanText(') right next to the '),
                ItalicRomanText('anak súlat'),
                RomanText(' BU ('),
                KulitanText('bu'),
                RomanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of SA ('),
                KulitanText('sa'),
                RomanText('), creating the syllable ‘BUS’.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'terminating_vowel_table.png',
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'Table 6',
                style: _gameData.getStyle('textInfoImageCaptionItalic'),
              ),
              TextSpan(text: '. Terminating the inherent vowel sound ‘A’.'),
            ],
          ),
          screenWidth: _width,
        ),
      ],
    ];

    final Widget _chapters = Scrollbar(
      child: PageView.builder(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        itemCount: _guideList.length,
        itemBuilder: (BuildContext _, int index) {
          return Align(
            alignment: Alignment.center,
            child: Container(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: _screenHorizontalPadding),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: informationVerticalScreenPadding -
                          (index == 0 ? 7.5 : 0.0)),
                  child: Column(
                    children: _guideList[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    List<Widget> _pageStack = [
      Column(
        children: <Widget>[
          Container(
            color: _gameData.getColor('background'),
            width: double.infinity,
            height: 48.0 + headerVerticalPadding,
            padding: const EdgeInsets.fromLTRB(
              headerHorizontalPadding + 48.0,
              headerVerticalPadding - 8.0,
              headerHorizontalPadding + 48.0,
              0.0,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('Writing Guide', style: _gameData.getStyle('textPageTitle')),
            ),
          ),
          _pageCredits,
          Expanded(
            child: _chapters,
          ),
        ],
      ),
      _header,
    ];

    if (_showBackToStartFAB) {
      _pageStack.add(
        BackToStartButton(
          direction: Axis.horizontal,
          onPressed: () {
            _pageController.animateToPage(
              0,
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
