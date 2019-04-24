import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/IconButtonNew.dart';
import '../../../components/buttons/BackToStartButton.dart';
import '../../../components/buttons/GuideButton.dart';
import '../../../components/misc/StaticHeader.dart';
import '../../../components/misc/ImageWithCaption.dart';
import '../../../components/misc/Paragraphs.dart';

class WritingGuidePage extends StatefulWidget {
  @override
  _WritingGuidePageState createState() => _WritingGuidePageState();
}

class _WritingGuidePageState extends State<WritingGuidePage> {
  final PageController _pageController = PageController();

  bool _showBackToStartFAB = false;

  @override
  void initState() {
    super.initState();
    _pageController
      ..addListener(() {
        if (_pageController.page == 0)
          setState(() => _showBackToStartFAB = false);
        else
          setState(() => _showBackToStartFAB = true);
      });
  }

  @override
  void dispose() {
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
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: toastFontSize,
      );
    }
  }

  TextSpan _romanText(String text, [TapGestureRecognizer recognizer]) {
    return TextSpan(
      text: text,
      style: recognizer == null ? textInfoText : textInfoLink,
      recognizer: recognizer,
    );
  }

  TextSpan _italicRomanText(String text) {
    return TextSpan(text: text, style: textInfoTextItalic);
  }

  TextSpan _kulitanText(String text) {
    return TextSpan(text: text, style: kulitanInfoText);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pop(context),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
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
              style: textInfoCredits,
              children: <TextSpan>[
                TextSpan(text: 'Written by Siuálâ Ding Meángûbié. '),
                TextSpan(
                  text: 'Learn more',
                  style: textInfoCreditsLink,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL('http://siuala.com'),
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
        style: textInfoTextItalic,
      ),
    );

    final Widget _poemEnglish = Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: paragraphTopPadding),
      child: Text(
        'Like the Sun that shines from heaven,\nIts radiance reaches down on earth.\nRising from Bunduk Aláya,\nIt descends on Mount Pinatubo.',
        textAlign: TextAlign.center,
        style: textInfoTextItalic,
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
        GuideButton(
          pageNumber: 17,
          text: 'Advanced Kulitan',
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
              style: textInfoImageCaption,
              children: <TextSpan>[
                TextSpan(text: 'Figure 1. ', style: textInfoImageCaptionItalic),
                TextSpan(text: 'The Kapampangan verse that explains why '),
                TextSpan(text: 'Kulitan', style: textInfoImageCaptionItalic),
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
                _romanText('The first two lines refer to '),
                _italicRomanText('Kulitan'),
                _romanText(
                    ' being written vertically top to bottom. The rays of the sun spreads down to earth from the heavens, hence top to bottom. The last two lines refer to '),
                _italicRomanText('Kulitan'),
                _romanText(
                    ' being written left to right. When facing the North Star or '),
                _italicRomanText('Tálâng Úgut'),
                _romanText(
                    ', Bunduk Aláya on the East sits on your right hand while Bunduk Pinatúbû on the West sits on your left, thus explaining the writing direction from right to left.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'pamagkulit.png',
          caption: TextSpan(text: 'PÁMAGKULIT', style: textInfoImageCaption),
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
                TextSpan(text: 'INDÛ AT ANAK', style: textInfoImageCaption),
            subcaption: 'Mother and Child',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              style: textInfoText,
              children: <TextSpan>[
                _romanText('Kulitan is basically made up of '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' or the “mother” characters and the '),
                _italicRomanText('Anak Súlat'),
                _romanText(' or the “offspring” characters. The '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
                    ' are the base characters with the unaltered inherent vowel sounds. They are the building blocks of Súlat Kapampángan. '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' gives birth to '),
                _italicRomanText('Anak Súlat'),
                _romanText(
                    ' or “offspring” characters whenever their inherent vowel sound has been altered by a ligature or a diacritical mark.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('The '),
                _italicRomanText('Siuálâ'),
                _romanText(
                    ' or vowels in Súlat Kapampángan are usually written as '),
                _italicRomanText('garlit'),
                _romanText(
                    ' or diacritical marks placed above or below an individual '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
                    ' or “mother” character. Ligatures are also sometimes used to further lengthen these vowel sounds. A glyph with a diacritical mark or ligature attached to it is an '),
                _italicRomanText('Anak Súlat'),
                _romanText(' or offspring character.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('The '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
                    ' characters are divided into two groups: the consonantal glyphs or '),
                _italicRomanText('Kulit a Mágkas'),
                _romanText(' or '),
                _italicRomanText('Kulit a Makikatnî'),
                _romanText(
                    ' (Hilario, 1962) and the independent vowel glyphs or '),
                _italicRomanText('Kulit a Siuálâ'),
                _romanText('. The '),
                _italicRomanText('Kulit a Siuálâ'),
                _romanText(' or vowel glyphs are not the same as the '),
                _italicRomanText('garlit'),
                _romanText(' or diacritical marks.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('The recital order of the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
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
                style: textInfoImageCaption),
            subcaption: 'The Consonantal Characters',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              style: textInfoText,
              children: <TextSpan>[
                _romanText('There are eleven '),
                _italicRomanText('Kulit a Mágkas'),
                _romanText(
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
            style: textInfoImageCaption,
            children: <TextSpan>[
              TextSpan(text: 'Table 1.', style: textInfoImageCaptionItalic),
              TextSpan(text: ' The '),
              TextSpan(
                  text: 'kulit a mágkas', style: textInfoImageCaptionItalic),
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
                    _italicRomanText('a.  Kulit ngágkas king akmúlan '),
                    _romanText('(velar): GA ('),
                    _kulitanText('ga'),
                    _romanText(') and KA ('),
                    _kulitanText('ka'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText('b.  Kulit ngágkas king árung '),
                    _romanText('(nasal): NGA ('),
                    _kulitanText('nga'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText('c.  Kulit ngágkas king ípan '),
                    _romanText('(dental): NTAGA ('),
                    _kulitanText('ta'),
                    _romanText(') and NA ('),
                    _kulitanText('na'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText(
                        'd.  Kulit ngágkas king ípan a déla king dílâ '),
                    _romanText('(alveolar): DA/RA ('),
                    _kulitanText('da'),
                    _romanText(') and LA ('),
                    _kulitanText('la'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText(
                        'e.  Kulit ngágkas pasalitsit king ípan '),
                    _romanText('(fricative): SA ('),
                    _kulitanText('sa'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText('f.  Kulit ngágkas king lábî '),
                    _romanText('(bilabial): MA ('),
                    _kulitanText('ma'),
                    _romanText(') and PA ('),
                    _kulitanText('pa'),
                    _romanText(').'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    _italicRomanText('g.  Kulit ngágkas patiúp king lábî '),
                    _romanText('(aspirated bilabial): BA ('),
                    _kulitanText('ba'),
                    _romanText(').'),
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
                _romanText(
                    'The consonantal syllables WA and YA are represented by the '),
                _italicRomanText('Kulit a Siuálâ'),
                _romanText(' or vowel glyphs U ('),
                _kulitanText('u'),
                _romanText(') and I ('),
                _kulitanText('i'),
                _romanText(
                    ') respectively (Benavente, 1699 and Hilario, 1962). Like their consonant counterparts in the other scripts of the archipelago, these '),
                _italicRomanText('Kulit a Siuálâ'),
                _romanText(' can be altered by placing a '),
                _italicRomanText('garlit'),
                _romanText(
                    ' or diacritical mark above or below the glyph to form “offspring” characters or '),
                _italicRomanText('Anak Súlat'),
                _romanText(
                    '. This will be explained further in the following sections of this chapter.'),
              ],
            ),
          ],
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'While all other glyphs in the other indigenous scripts within the archipelago resemble one another, Kulitan has also developed unique and distinct character shapes that are different from Baybayin, particularly the '),
                _italicRomanText('Kulit Mágkas'),
                _romanText(' or consonantal characters Ga ('),
                _kulitanText('ga'),
                _romanText('), Ta ('),
                _kulitanText('ta'),
                _romanText('), Sa ('),
                _kulitanText('sa'),
                _romanText(
                    ') that are consistent in appearance in the various '),
                _italicRomanText('cuadernos'),
                _romanText(' and '),
                _italicRomanText('abecedarios'),
                _romanText(
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
                style: textInfoImageCaption),
            subcaption: 'The Vowel Characters',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                _romanText('For vowels as '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
                    ' or independent syllable glyphs, Kulitan has three basic '),
                _italicRomanText('Kulit a Siuálâ'),
                _romanText(' or vowel characters. These are A ('),
                _kulitanText('a'),
                _romanText('), I ('),
                _kulitanText('i'),
                _romanText('), and U ('),
                _kulitanText('u'),
                _romanText(').'),
                _italicRomanText('bábo'),
                _romanText(' (above), '),
                _italicRomanText('sabó'),
                _romanText(' (soup or justice) and '),
                _italicRomanText('ulimó'),
                _romanText(' (tiger) all used to be pronounced as '),
                _italicRomanText('bábau'),
                _romanText(', '),
                _italicRomanText('sabáu'),
                _romanText(' and '),
                _italicRomanText('ulimau'),
                _romanText('. Thus the vowel O is still written as AU ('),
                _italicRomanText('oo'),
                _romanText(') in Kulitan.'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'kulit_a_sisiuala_table.png',
          orientation: Axis.horizontal,
          caption: TextSpan(
            style: textInfoImageCaption,
            children: <TextSpan>[
              TextSpan(
                text: 'Table 2',
                style: textInfoImageCaptionItalic,
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
                _romanText(
                    'However, the Kapampangan language has two monophthongized diphthongs (Gonzales, 1972). These became the vowels E and O and are represented by the “'),
                _italicRomanText('aduang kulit a máging metung mû'),
                _romanText('” (Hilario, 1962) or '),
                _italicRomanText('Miyasáuang Kulit'),
                _romanText(' or “married” or “coupled” vowels E ('),
                _kulitanText('ee'),
                _romanText('), and O ('),
                _kulitanText('oo'),
                _romanText(
                    ') [Table 2]. Unlike other Philippine languages, the Kapampangan language does not interchange the vowels I and E since E is a monophthongized diphthong. Kapampangan words ending in the vowel E like '),
                _italicRomanText('bale'),
                _romanText(' (house), '),
                _italicRomanText('pále'),
                _romanText(' (unhusked rice) and '),
                _italicRomanText('sále'),
                _romanText(' (nest) used to be pronounced as '),
                _italicRomanText('balai'),
                _romanText(', '),
                _italicRomanText('pálai'),
                _romanText(' and '),
                _italicRomanText('sálai'),
                _romanText('. Thus the vowel E is still written as AI ('),
                _kulitanText('ee'),
                _romanText(
                    ') in Kulitan. Likewise, the Kapampangan language does not interchange the vowels U with O since O is also a monophthongized diphthong. The Kapampangan words that end in O like '),
                _italicRomanText('bábo'),
                _romanText(
                    ') in Kulitan. Likewise, the Kapampangan language does not interchange the vowels U with O since O is also a monophthongized diphthong. The Kapampangan words that end in O like '),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('The '),
                _italicRomanText('Kambal Siuálâ'),
                _romanText(
                    ' or “twin” vowels seen on Table 2 represent the lengthening of the vowel sounds and the glottal stops in the Kapampangan language. These are usually represented by the diacritical marks '),
                _italicRomanText('sakúrut'),
                _romanText(' ( ́) and '),
                _italicRomanText('télaturung'),
                _romanText(
                    ' (^) when writing the Kapampangan language in the Latin script. When they stand alone, the '),
                _italicRomanText('kambal siuálâ'),
                _romanText(' or “twin” vowels are as follows: –Á-/-Â ('),
                _kulitanText('aa'),
                _romanText(' ), -Í-/-Î ('),
                _kulitanText('ii'),
                _romanText(') and –Ú-/-Û ('),
                _kulitanText('uu'),
                _romanText(').')
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
            caption: TextSpan(text: 'ANAK SÚLAT', style: textInfoImageCaption),
            subcaption: 'The offspring character',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'As mentioned earlier, all of the consonantal characters in Kulitan possess the inherent vowel sound ‘A’. On their own they are known as '),
                _italicRomanText('Indûng Súlat'),
                _romanText(
                    ' or mother characters. To alter their default vowel sounds and produce '),
                _italicRomanText('Anak Súlat'),
                _romanText(' or offspring characters, one simply places the '),
                _italicRomanText('garlit'),
                _romanText(
                    ' or diacritical marks above or below or place a ligature character next to the mother character. Again, the '),
                _italicRomanText('Anak Súlat'),
                _romanText(
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
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '. The ', style: textInfoImageCaption),
              TextSpan(
                text: 'anak súlat',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: textInfoImageCaption),
              TextSpan(
                text: 'indûng súlat',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: ' SA (', style: textInfoImageCaption),
              TextSpan(
                text: 'sa',
                style: textInfoImageCaptionKulitan,
              ),
              TextSpan(text: ').', style: textInfoImageCaption),
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
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '. Table of ', style: textInfoImageCaption),
              TextSpan(
                text: 'Indûng Súlat',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: ' and their ', style: textInfoImageCaption),
              TextSpan(
                text: 'Anak Súlat',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '.', style: textInfoImageCaption),
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
                style: textInfoImageCaption),
            subcaption: 'Changing the default vowel sound `A` to `I`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'To change the default ‘A’ sound of any of the consonantal characters to ‘I’, simply place a '),
                _italicRomanText('garlit'),
                _romanText(' or diacritical mark above it. For example, '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' KA ('),
                _kulitanText('ka'),
                _romanText(') becomes '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KI ('),
                _kulitanText('ki'),
                _romanText(') by placing the '),
                _italicRomanText('garlit'),
                _romanText(' (’) above it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                style: textInfoImageCaption),
            subcaption: 'Changing the default vowel sound `A` to `U`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'To change the default ‘A’ sound of any of the consonantal characters to ‘U’, simply place a '),
                _italicRomanText('garlit'),
                _romanText(' ‘dot’ or ‘stroke’ below it. For example, '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' KA ('),
                _kulitanText('ka'),
                _romanText(') becomes '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KU ('),
                _kulitanText('ku'),
                _romanText(') by placing the '),
                _italicRomanText('garlit'),
                _romanText(' (’) below it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                    style: textInfoImageCaption),
                TextSpan(
                    text: 'i',
                    style: textInfoImageCaption.copyWith(
                        fontFamily: 'Kulitan Semi Bold')),
                TextSpan(text: ')', style: textInfoImageCaption),
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
                _romanText(
                    'One of the features that make Súlat Kapampángan different from the other indigenous scripts of these islands is the way the vowel glyph I ('),
                _kulitanText('i'),
                _romanText(
                    ') can alter it in the same manner as the consonant glyph YA found in Baybayin and other scripts of the archipelago. Although personally I think the Kapampangan vowel glyph I ('),
                _kulitanText('i'),
                _romanText(
                    ') is really the consonant glyph YA acting as a vowel glyph. They actually look very similar especially when the Kapampangan character is written in cursive form. As explained by Fray Alvaro de Benavente (1699) in his '),
                _italicRomanText('Arte de Lengua Pampanga'),
                _romanText(' and by Zoilo Hilario (1962) in his '),
                _italicRomanText('Báyung Súnis'),
                _romanText(', the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' or “mother character” vowel I ('),
                _kulitanText('i'),
                _romanText(') can be altered with the use of a '),
                _italicRomanText('garlit'),
                _romanText(
                    ' or diacritical mark placed above or below it as well as adding vowel ligatures next to it to produce '),
                _italicRomanText('Anak Súlat'),
                _romanText(
                    ' or offspring characters of the consonant sound Y. For instance the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' I ('),
                _kulitanText('i'),
                _romanText(') can produce the '),
                _italicRomanText('Anak Súlat'),
                _romanText(' YI ('),
                _kulitanText('yi'),
                _romanText(') by placing a '),
                _italicRomanText('garlit'),
                _romanText(' above it and the '),
                _italicRomanText('Anak Súlat'),
                _romanText(' YU ('),
                _kulitanText('yu'),
                _romanText(') by placing the '),
                _italicRomanText('garlit'),
                _romanText(' below it [Table 4].'),
              ],
            ),
            _romanText('Example diagram:'),
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
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '. The ', style: textInfoImageCaption),
              TextSpan(
                text: 'anak kulit',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: textInfoImageCaption),
              TextSpan(text: 'indung kulit', style: textInfoImageCaptionItalic),
              TextSpan(text: ' I (', style: textInfoImageCaption),
              TextSpan(
                text: 'i',
                style: textInfoImageCaptionKulitan,
              ),
              TextSpan(text: ').', style: textInfoImageCaption),
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
                    style: textInfoImageCaption),
                TextSpan(
                    text: 'u',
                    style: textInfoImageCaption.copyWith(
                        fontFamily: 'Kulitan Semi Bold')),
                TextSpan(text: ')', style: textInfoImageCaption),
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
                _romanText(
                    'Again, one of the unique features of Súlat Kapampángan is the way the vowel glyph U ('),
                _kulitanText('u'),
                _romanText(
                    ') can be altered in the same manner as the consonant glyph WA  found in Baybayin and the other scripts of the archipelago. I personally think that the Kapampangan vowel glyph U ('),
                _kulitanText('u'),
                _romanText(
                    ') may actually be the consonant glyph WA acting as a vowel glyph. Christopher Miller (2011b) also noted the similarity in shape of the Baybayin WA with Kapampangan U ('),
                _kulitanText('u'),
                _romanText(
                    '). In Kulitan, WA is usually written by combining the vowels characters U ( '),
                _kulitanText('u'),
                _romanText(') and A ('),
                _kulitanText('a'),
                _romanText(
                    ') [Table 5] but surprisingly the vowel character U ('),
                _kulitanText('u'),
                _romanText(') stood alone without the vowel A ('),
                _kulitanText('a'),
                _romanText(
                    ') in the 1621 signature of Doña Isabel Pangisnauan of Mexico (Masíku). Could this be proof that Kapampangan vowel character U may actually be the consonantal character WA?'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'As explained by Fray Alvaro de Benavente (1699) in his '),
                _italicRomanText('Arte de Lengua Pampanga'),
                _romanText(' and by Zoilo Hilario (1962) in his '),
                _italicRomanText('Báyung Súnis'),
                _romanText(', the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' or “mother character” vowel U ('),
                _kulitanText('u'),
                _romanText(') can be altered with the use of a '),
                _italicRomanText('garlit'),
                _romanText(
                    ' or diacritical mark placed above or below it as well as adding vowel ligatures next to it to produce '),
                _italicRomanText('Anak Súlat'),
                _romanText(
                    ' or offspring characters of the consonant sound W. For instance the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' U ('),
                _kulitanText('u'),
                _romanText(') can produce the '),
                _italicRomanText('Anak Súlat'),
                _romanText(' WI ('),
                _kulitanText('wi'),
                _romanText(') by placing a '),
                _italicRomanText('garlit'),
                _romanText(' above it and the '),
                _italicRomanText('Anak Súlat'),
                _romanText(' WU ('),
                _kulitanText('wu'),
                _romanText(') by placing the '),
                _italicRomanText('garlit'),
                _romanText(' below it [Table 5].'),
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
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '. The ', style: textInfoImageCaption),
              TextSpan(
                text: 'anak kulit',
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(
                  text: ' or offspring characters of the ',
                  style: textInfoImageCaption),
              TextSpan(text: 'indung kulit', style: textInfoImageCaptionItalic),
              TextSpan(text: ' U (', style: textInfoImageCaption),
              TextSpan(
                text: 'u',
                style: textInfoImageCaptionKulitan,
              ),
              TextSpan(text: ').', style: textInfoImageCaption),
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
                style: textInfoImageCaption),
            subcaption: 'Changing the default vowel sound `A` to `E`',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'Since the Kapampangan vowel sound ‘E’ was developed from the monophthongisation of the diphthong ‘AI’, simply place the whole vowel glyph I ('),
                _kulitanText('i'),
                _romanText(
                    ') right next to the target consonantal glyph to change its inherent vowel sound ‘A’ to ‘E’. For example, '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' KA ('),
                _kulitanText('ka'),
                _romanText(') becomes '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KE ('),
                _kulitanText('ke'),
                _romanText(') by placing the vowel character I ('),
                _kulitanText('i'),
                _romanText(') right after it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                style: textInfoImageCaption),
            subcaption: 'Changing the default vowel sound ‘A’ to ‘O’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'Since the Kapampangan vowel sound ‘O’ was developed from the monophthongisation of the diphthong ‘AU’, simply place the whole vowel glyph U ('),
                _kulitanText('u'),
                _romanText(
                    ') right next to the target consonantal glyph to change its inherent vowel sound ‘A’ to ‘O’. For example, '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' KA ('),
                _kulitanText('ka'),
                _romanText(') becomes '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KO ('),
                _kulitanText('ko'),
                _romanText(') by placing the vowel character U ('),
                _kulitanText('u'),
                _romanText(') right after it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                text: 'DING KAMBAL SIUÁLÂ', style: textInfoImageCaption),
            subcaption: 'Stress and Accents in Kulitan',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText('The'),
                _italicRomanText('Kambal Siuálâ'),
                _romanText(
                    ' or the lengthening of the vowel sounds in the Kapampangan language indicate the stress emphasis given to one or more syllables in a word. The accents or stress in the Kapampangan language or often lexical in nature. In Kapampangan, there are usually two or more words that are spelled similarly when written in the Latin script. Their meanings are different however depending on which syllable the emphasis falls. Strictly speaking, words having different accents, even if they are spelled the same way, are not the same word (Bachuber, 1952). In the Kapampangan language, a shift in stress may indicate a change in numbers among nouns, a change in tense among verbs, or even a change in the parts of speech (Hilario, 1962, Henson, 1965 and Pangilinan, 2006).'),
              ],
            ),
            _romanText(
                'The following classic example comes from Mariano Henson (1965):'),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(top: paragraphTopPadding),
          constraints: BoxConstraints(maxWidth: 600.0),
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: SizedBox(
              width: 0.5 * _width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('masákit\nmásakit\nmasakit',
                        style: textInfoTextItalic),
                  ),
                  Expanded(
                    child: Text('‘difficult’\n‘infirm’\n‘painful’',
                        style: textInfoText),
                  ),
                  Expanded(
                    child: Text(
                      '(ADJ.)\n(N.)\n(ADJ.)',
                      style: textInfoText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            _romanText(
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
                _romanText(
                    'In Kulitan however, the placement of stress in a syllable is quite evident because of the '),
                _italicRomanText('Kambal Siuálâ'),
                _romanText(
                    '. Unlike the Latin script, no two words are spelled the same way in Kulitan. Notice Mariano Henson’s examples again written in Kulitan above. Unlike in the Latin script, none of the three words in the examples are spelled the same way in Kulitan. The placement extra glyph ‘A’ ('),
                _kulitanText('a'),
                _romanText(') to form the '),
                _italicRomanText('Kambal Siuálâ'),
                _romanText(' –Á-/-Â ('),
                _kulitanText('aa'),
                _romanText(') can be readily seen.'),
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
                text: 'KAMBAL SIUÁLÂ ‘A’', style: textInfoImageCaption),
            subcaption: 'Lengthening the inherent vowel ‘A’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText('Since all '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' vowel character A ('),
                _kulitanText('a'),
                _romanText(') right after the target glyph. For example, KA ('),
                _kulitanText('ka'),
                _romanText(') becomes medial KÁ ('),
                _kulitanText('kaa'),
                _romanText(') or final KÂ ('),
                _kulitanText('kaa'),
                _romanText(') by placing the vowel character A ('),
                _kulitanText('a'),
                _romanText(') right after it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                text: 'KAMBAL SIUÁLÂ ‘I’', style: textInfoImageCaption),
            subcaption: 'Lengthening the offspring vowel sound ‘I’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'The vowel sound ‘I’ of an Anak Súlat or offspring character can further be lengthened simply by adding the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' vowel character I ('),
                _kulitanText('i'),
                _romanText(') right after the target '),
                _italicRomanText('Anak Súlat'),
                _romanText(' or offspring character. For example, '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KI ('),
                _kulitanText('ki'),
                _romanText(') gives birth to another '),
                _italicRomanText('Anak Súlat'),
                _romanText(' ~ the medial KÍ ('),
                _kulitanText('kii'),
                _romanText(') or final KÎ'),
                _kulitanText('kii'),
                _romanText('), by placing '),
                _italicRomanText('Indúng Súlat'),
                _romanText(' vowel character I ('),
                _kulitanText('i'),
                _romanText(') right after it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                text: 'KAMBAL SIUÁLÂ ‘U’', style: textInfoImageCaption),
            subcaption: 'Lengthening the offspring vowel sound ‘U’',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'The vowel sound ‘U’ of an Anak Súlat or offspring character can further be lengthened simply by adding the '),
                _italicRomanText('Indûng Súlat'),
                _romanText(' vowel character U ('),
                _kulitanText('u'),
                _romanText(') right after the target '),
                _italicRomanText('Anak Súlat'),
                _romanText(' or offspring character. For example, '),
                _italicRomanText('Anak Súlat'),
                _romanText(' KU ('),
                _kulitanText('ku'),
                _romanText(') becomes another '),
                _italicRomanText('Anak Súlat'),
                _romanText(' ~ the medial KÚ ('),
                _kulitanText('kuu'),
                _romanText('), by placing '),
                _italicRomanText('Indúng Súlat'),
                _romanText(' vowel character U ('),
                _kulitanText('u'),
                _romanText(') right after it.'),
              ],
            ),
            _romanText('Example diagram:'),
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
                text: 'PÁMAKAMATÉ SIUÁLÂ', style: textInfoImageCaption),
            subcaption: 'Terminating the default vowel sound',
            screenWidth: _width,
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'There are two things that actually make Súlat Kapampángan different from all other scripts within the archipelago: First, it is the only script in the archipelago that is traditionally and preferably written vertically top to bottom, left to right, similar to other East Asian scripts. Second, Súlat Kapampángan is also the only script in the archipelago that has managed to create a spelling convention where the final consonant glyph is retained minus its inherent vowel sound ‘A’ without using a '),
                _italicRomanText('virama'),
                _romanText(
                    ' (vowel killer).This spelling convention has been observed as early as the 17\u1d57\u02b0 century based on several Kapampángan signatures from that era (Miller, 2010 and 2011a). While the other indigenous scripts in the archipelago either dropped the coda consonant in the same manner as the Bugis-Makasarese scripts of Indonesia (Miller, 2011a and 2012) or use the '),
                _italicRomanText('virama'),
                _romanText(
                    ' or “vowel killer” in the form of a “cross kudlit” introduced by the Spanish friar Francisco Lopez in 1620 (Marcilla, 1895), the final consonant glyph is written out in full in Súlat Kapampángan but is read without the default vowel sound ‘A’.'),
              ],
            ),
            TextSpan(
                text:
                    'The only way to appreciate how this is done is by writing Súlat Kapampángan vertically instead of horizontally. To terminate the inherent vowel sound ‘A’ of any of the consonantal glyphs, simply write the target character next to the one preceding it instead of below it. This will terminate its default vowel sound.'),
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'For instance on [Table 6], to terminate the inherent ‘A’ sound of NA ('),
                _kulitanText('na'),
                _romanText(') in ‘NGANA’ simply write NA ('),
                _kulitanText('na'),
                _romanText(') right next to NGA ('),
                _kulitanText('nga'),
                _romanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of NA ('),
                _kulitanText('na'),
                _romanText('), creating the syllable ‘NGAN’.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('To terminate the inherent ‘A’ sound of NGA ('),
                _kulitanText('nga'),
                _romanText(') in the word ‘SANGA’, simply write NGA ('),
                _kulitanText('nga'),
                _romanText(') right next to SA ('),
                _kulitanText('sa'),
                _romanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of NGA ('),
                _kulitanText('nga'),
                _romanText('), creating the syllable ‘SANG’.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('To terminate the inherent ‘A’ sound of SA ('),
                _kulitanText('sa'),
                _romanText(') in the ‘BUSA’, simply write SA ('),
                _kulitanText('sa'),
                _romanText(') right next to the '),
                _italicRomanText('anak súlat'),
                _romanText(' BU ('),
                _italicRomanText('bu'),
                _romanText(
                    ') instead of below it. This will terminate the default ‘A’ sound of SA ('),
                _kulitanText('sa'),
                _romanText('), creating the syllable ‘BUS’.'),
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
                style: textInfoImageCaptionItalic,
              ),
              TextSpan(text: '. Terminating the inherent vowel sound ‘A’.'),
            ],
          ),
          screenWidth: _width,
        ),
      ],

      // Advanced Kulitan
      [
        Padding(
          padding: const EdgeInsets.only(
              top: imageTopPadding - informationCreditsVerticalPadding),
          child: ImageWithCaption(
            filename: 'sinupan.jpg',
            hasPadding: false,
            captionAlignment: TextAlign.center,
            caption: TextSpan(
                text:
                    'Sínúpan Singsing:\nCenter for Kapampángan Cultural Heritage'),
            screenWidth: _width,
            borderRadius: 1.0,
          ),
        ),
        ImageWithCaption(
          filename: 'kulitan_book.jpg',
          orientation: Axis.horizontal,
          captionAlignment: TextAlign.center,
          caption: TextSpan(
              text:
                  'An Introduction to Kulitan:\nThe Indigenous Kapampangan Script'),
          subcaption: 'by Michael Raymon M. Pangilinan',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(children: <TextSpan>[
              _romanText(
                  'To learn more about the history, rules, and uses of Kulitan, you may read the continuation of this guide in the book '),
              _romanText(
                'An Introduction to Kulitan: The Indigenous Kapampangan Script',
                TapGestureRecognizer()
                  ..onTap = () => _openURL('http://siuala.com/'),
              ),
              _romanText(' by '),
              _romanText(
                'Michael Raymon M. Pangilinan',
                TapGestureRecognizer()
                  ..onTap = () => _openURL('http://siuala.com/siuala/'),
              ),
              _romanText(' (Siuálâ ding Meángûbié).'),
            ]),
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'For a hands-on experience, you may opt to attend writing workshops organized by Sínúpan Singsing: Center for Kapampángan Cultural Heritage. Upcoming events and activites can be viewed on their '),
                _romanText(
                  'Facebook page',
                  TapGestureRecognizer()
                    ..onTap = () =>
                        _openURL('https://www.facebook.com/sinupan.singsing/'),
                ),
                _romanText(
                    '. For related news and articles, you may also visit their official website at '),
                _romanText(
                  'sinupan.org',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://www.sinupan.org/'),
                ),
                _romanText('.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                _romanText('A '),
                _romanText(
                  'Facebook group',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://www.facebook.com/groups/Kulitkulitan/'),
                ),
                _romanText(
                    ' exists for Kulitan enthusiasts and those who would like to learn the indigenous Kapampangan script. Only English and Kapampangan languages are allowed in the group.'),
              ],
            ),
            _romanText(
                'It is important to note that Kulitan shall exclusively be written in the Kapampangan language only.'),
          ],
        ),
      ],
    ];

    final Widget _chapters = Scrollbar(
      child: PageView.builder(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        itemCount: _guideList.length,
        itemBuilder: (BuildContext _, int index) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: informationHorizontalScreenPadding),
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
          );
        },
      ),
    );

    List<Widget> _pageStack = [
      Column(
        children: <Widget>[
          Container(
            color: backgroundColor,
            padding: const EdgeInsets.fromLTRB(
              informationHorizontalScreenPadding,
              headerVerticalPadding - 8.0,
              informationHorizontalScreenPadding,
              0.0,
            ),
            child: Text('Guide', style: textPageTitle),
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
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: _pageStack,
        ),
      ),
    );
  }
}
