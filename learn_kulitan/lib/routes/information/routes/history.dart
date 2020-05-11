import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, GestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/RoundedBackButton.dart';
import '../../../components/buttons/BackToStartButton.dart';
import '../../../components/misc/StaticHeader.dart';
import '../../../components/misc/StickyHeading.dart';
import '../../../components/misc/ImageWithCaption.dart';
import '../../../components/misc/Paragraphs.dart';
import '../../../db/GameData.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage();
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  static final GameData _gameData = GameData();
  final _scrollController = ScrollController();

  bool _showBackToStartFAB = false;

  @override
  void initState() {
    super.initState();
    _scrollController
      ..addListener(() {
        final double _position = _scrollController.offset;
        final double _threshold =
            historyFABThreshold * _scrollController.position.maxScrollExtent;
        if (_position <= _threshold && _showBackToStartFAB == true)
          setState(() => _showBackToStartFAB = false);
        else if (_position > _threshold && !_showBackToStartFAB)
          setState(() => _showBackToStartFAB = true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open webpage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
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
        right: SizedBox(width: 56.0, height: 48.0),
      ),
    );

    final Widget _history = Column(
      children: <Widget>[
        ImageWithCaption(
          filename: 'history_kulitan.png',
          caption: TextSpan(text: 'KASALÉSAYAN', style: _gameData.getStyle('textInfoImageCaption')),
          subcaption: 'HISTORY',
          screenWidth: _width,
          hasPadding: false,
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Long before the idea of a Filipino nation was even conceived, the Kapampangan, Butuanon, Tausug, Magindanau, Hiligaynon, Sugbuanon, Waray, Iloko, Sambal and many other ethnolinguistic groups within the archipelago, already existed as '),
                ItalicRomanText('bangsâ'),
                RomanText(
                    ' or nations in their own right. Many of these nations formed their own states and principalities centuries before the Spaniards created the Philippines in the late 16th century. The oldest of these states include Butuan (蒲端) which existed on Chinese records as early as 1001 C.E., Sulu (蘇祿) in 1368 C.E. and the Kingdom of Luzon (呂宋国) in 1373 C.E. These three sovereign states were ruled by kings (國王) and not by chieftains according to Chinese historical records (Zhang, 1617; Scott 1989; Wang 1989; Wade, 2005 and Wang, 2008).'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'japanese_map.jpeg',
          screenWidth: _width,
          orientation: Axis.horizontal,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 1.',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' The Kingdom of Luzon (呂宋國) as it appears on a Japanese map during the Ming dynasty (1368 to 1644). From “A look at history based on Ming dynasty maps” (從大明坤輿萬國 圖看歷史) posted by zhaijia1987 in '),
              TextSpan(
                  text: 'Baidu Tieba (百度贴吧)',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(text: ' on 2010 November 11.'),
            ],
          ),
        ),
        ImageWithCaption(
          filename: 'map_of_pampanga.jpeg',
          screenWidth: _width,
          orientation: Axis.horizontal,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 2.',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text: ' Map of Pampanga from Pedro Murillo Velarde’s 1744 '),
              TextSpan(
                  text: 'Mapa de las Islas Filipinas.',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' The Pampanga Delta Region had been inaccurately assigned to Bulacan.'),
            ],
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'The Kapampangan nation was once a part of the Kingdom of Luzon [Fig. 1]. They were one of the '),
                ItalicRomanText('Luçoes'),
                RomanText(
                    ', ‘people of Luzon’, encountered by Portuguese explorers during their initial ventures into Southeast Asia in the early 16th century (Scott, 1994). The Kapampangan homeland, '),
                ItalicRomanText('Indûng Kapampángan'),
                RomanText(
                    ' (Pampanga), became the first province carved out of the Kingdom of Luzon when the Spaniards conquered it in 1571 C.E. (Cavada, 1876 and Henson, 1965). Indûng Kapampángan’s political boundaries once encompassed a large portion of the central plains of Luzon, stretching from the eastern coastline of the Bataan Peninsula in the Southwest, all the way to Casiguran Bay in the Northeast (Murillo Velarde, 1744; San Antonio, 1744; Beyer, 1918; Henson, 1965; Larkin, 1972 and Tayag, 1985) [Fig 2.]. It was said to be the most populated region in Luzon at that time, with an established agricultural base that can support a huge population (Loarca, 1583; San Agustin, 1699; Mallat, 1846; B&R, 1905; Henson, 1965 and Larkin, 1972). It also has a highly advanced material culture where Chinese porcelain is used extensively and where firearms and bronze cannons were manufactured (Morga, 1609; Mas, 1843; B&R, 1905; Beyer, 1947; Larkin, 1972; Santiago, 1990b and Dizon, 1999). The old capital of the Kingdom of Luzon, Tondo (東都: “Eastern Capital”), once spoke one language with the rest of Indûng Kapampángan that is different from the language spoken in Manila (Loarca, 1583; B&R, 1905 and Tayag, 1985). Jose Villa Panganiban, the former commissioner of the Institute of National Language, once thought the Pasig River that divides Tondo and Manila to be the same dividing line between Kapampangan and Tagalog (Tayag, 1985). The descendants of the old rulers of the Kingdom of Luzon, namely those of Salalílâ, Lakandúlâ and Suliman, can still be found all over Indûng Kapampángan (Beyer, 1918; Beyer, 1943; Henson, 1965 and Santiago, 1990a).'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'luzon_jar.jpeg',
          screenWidth: _width,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 3.',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' A typical brown-glazed four-eared Luzon jar (呂宋壷 [褐釉 四耳壷]) exported to Japan by the Kingdom of Luzon in the mid-16th century. Photo courtesy of Hikone Castle Museum (彦根城博物館) Newsletter, Vol. 13, 1991 May 1. Figure 3. A typical brown-glazed four-eared Luzon jar (呂宋壷 [褐釉 四耳壷]) exported to Japan by the Kingdom of Luzon in the mid-16th century. Photo courtesy of Hikone Castle Museum (彦根城博物館) Newsletter, Vol. 13, 1991 May 1.'),
            ],
          ),
        ),
        ImageWithCaption(
          filename: 'tokiko.jpeg',
          screenWidth: _width,
          caption: TextSpan(
            style: _gameData.getStyle('textInfoImageCaption'),
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 4.',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' A page in Faye-Cooper Cole’s English translation of Tauchi Yonesaburo’s '),
              TextSpan(
                  text: 'Tokiko',
                  style: _gameData.getStyle('textInfoImageCaption').copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' (陶器考) showing the ‘national writing of Luzon’ (呂宋國字) in comparison to Philippine scripts.'),
            ],
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'If the Kapampangan nation made up the bulk of the population of the Kingdom of Luzon, then perhaps the oldest evidence of Kapampangan writing can be found in the jars (呂宋壺) exported to Japan prior to the arrival of the Spaniards in the 16th century C.E. [Fig. 3]. In his book '),
                ItalicRomanText('Tokiko'),
                RomanText(
                    ' (陶器考) or “Investigations of Pottery” published in 1853 C.E., Tauchi Yonesaburo (田内米三郎) presents several jars marked with the '),
                ItalicRomanText('ruson koku ji'),
                RomanText(
                    ' (呂宋國字) or the “writing of the Kingdom of Luzon” (Tauchi [田内], 1853 and Cole, 1912). The marks that looked like the Chinese character '),
                ItalicRomanText('ting'),
                RomanText(
                    ' (丁) found in several Luzon jars might have been the indigenous Kapampangan script '),
                ItalicRomanText('la'),
                RomanText(' ('),
                KulitanText('la'),
                RomanText(
                    '), the first syllable in the name “Luzon” [Fig. 4].'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Writing has always been a testament to civilization among the great nations. The Chinese write ‘civilization’ as '),
                ItalicRomanText('wénmíng'),
                RomanText(
                    ' (文明) or ‘enlightenment through writing’, combining the characters '),
                ItalicRomanText('wén'),
                RomanText(' (文) ‘writing’ and '),
                ItalicRomanText('míng'),
                RomanText(
                    ' (明) ‘brightness’. Sadly, the Kapampangan nation, a once proud civilization with a long established literature has now become a tribe of confused barbarians. Although many Kapampangans can read and write fluently in foreign languages, namely Filipino and English, they are strangely illiterate in their own native Kapampangan language.'),
              ],
            ),
            RomanText(
                'The Kapampangan language currently does not possess a standard written orthography. The dispute on which orthography to use when writing the Kapampangan language in the Latin Script ~ whether to retain the old Spanish style orthography a.k.a. Súlat Bacúlud or implement the indigenized Súlat Wáwâ which replaced the Q and C with the letter K, remains unsettled. This unending battle on orthography has taken its toll on the development of Kapampangan literature and the literacy of the Kapampangan speaking majority (Pangilinan, 2006 and 2009b). No written masterpiece that could rival the works of the Kapampangan literary giants of the late 19th and early 20th centuries has yet been written. The few poems that earned a number of contemporary poets the title of Poet Laureate no longer have the same impact that would immortalize them in the people’s collective memory. Worse, the Kapampangan language is now even showing signs of decay and endangerment (Del Corro, 2000 and Pangilinan, 2009b).'),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'While the old literary elite continue to bicker endlessly which Latinized attitudinal procedure to follow, a small yet growing number of Kapampangan youth have become frustrated and disillusioned with the current state of Kapampangan language and culture. They see the old Spanish style orthography that still uses the letters C & Q as a perpetuation of Spain’s hold into the intellectual expressions of the Kapampangan people. The new orthography that has replaced the letters C and Q with K is also viewed to be foreign since they identify it with the Tagalog '),
                ItalicRomanText('w'),
                RomanText(
                    '. Instead of being forced to choose which orthography to use in writing Kapampangan, they chose to forego the use of the Latin script altogether. They decided instead to go back to writing in the indigenous '),
                ItalicRomanText('Súlat Kapampángan'),
                RomanText(' or '),
                ItalicRomanText('Kulitan.'),
              ],
            ),
          ],
        )
      ],
    );

    final Widget _references = Column(
      children: <Widget>[
        Paragraphs(
          textAlign: TextAlign.left,
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Avila, Bobit. (2007 August 24). Ethnic cleansing our own Filipino brethren? In '),
                ItalicRomanText(
                    'The Philippine Star. Retrieved 2012 March 16 from http://www.philstar.com/Article.aspx?articleId=15037.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Beyer, Henry Otley. (1918). '),
                ItalicRomanText(
                    'Ethnography of the Pampangan People: A Comprehensive Collection of Original Sources.'),
                RomanText(' Vol. 1& 2. Manila, Philippines. [Microfilm].'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Beyer, Henry Otley. (1943). '),
                ItalicRomanText('A Brief History of Fort Santiago.'),
                RomanText(' Manila (no publisher).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Cavada, Agustin de la. (1876). '),
                ItalicRomanText(
                    'Historia geográfica, geológica y estadistica de Filipinas.'),
                RomanText(' 2 vols. Manila: Ramirez y Giraudier.'),
              ],
            ),
            TextSpan(
              style: _gameData.getStyle('textInfoText'),
              children: <TextSpan>[
                RomanText('Cole, Fay–Cooper. (1912) '),
                ItalicRomanText('Chinese Pottery in the Philippines.'),
                RomanText(
                    ' Field Museum of Natural History Anthropological Series,Vol. 12 (1), Chicago.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Constitution of the Republic of the Philippines (1987). In '),
                ItalicRomanText('Chan Robles Virtual Law Library. '),
                RomanText(' Retrieved June 6, 2009 from '),
                RomanText(
                  'http://www.chanrobles.com/article14language.htm',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'http://www.chanrobles.com/article14language.htm'),
                ),
                RomanText('.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Defenders of the Indigenous Languages of the Archipelago (DILA). (2007). '),
                ItalicRomanText('Filipino is not our language.'),
                RomanText(
                    ' Angeles City, Pampanga: Defenders of the Indigenous Languages of the Archipelago (DILA).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Del Corro, Anicia. (2000). '),
                ItalicRomanText(
                    'Language Endangerment and Bible Translation.'),
                RomanText(
                    ' Malaga, Spain: Universal Bible Society Triennial Translation Workshop.'),
              ],
            ),
            RomanText(
                'Dizon, Eusebio et al. (5 October 1999).  Southeast Asian Protohistoric Archaeology at Porac, Pampanga, Central Luzon, Philippines. Mid-Year Progress Report. Archaeological Studies Program. University of the Philippines at Diliman, Quezon City, Philippines.'),
            TextSpan(
              children: <TextSpan>[
                RomanText('Henson, Mariano A. (1965). '),
                ItalicRomanText(
                    'The Province of Pampanga and Its Towns: A.D. 1300-1965.'),
                RomanText(
                    ' 4th ed. revised. Angeles City: Mariano A. Henson.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Larkin, John A. (1972). '),
                ItalicRomanText(
                    'The Pampangans: Colonial Society in a Philippine Province.'),
                RomanText(
                    ' 1993 Philippine Edition. Quezon City: New Day Publishers.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Loarca, Miguel de. (1583) Relacion de las Yslas Filipinas. In E. Blair and J. Robertson, eds. and trans. '),
                ItalicRomanText('The Philippine Islands, 1493-1898'),
                RomanText(', volume 5, page 34 – 187.'),
              ],
            ),
            RomanText(
                'Mallat, Jean. (1846). Les Philippines: histoire, geographie, mœurs, agriculture, industrie, commerce des colonies Espagnoles dans l’Oceanie. Paris: Arthus Bertrand. [English ed. 1998] Santillan, P. and Castrence, L. (Transl.), Manila: National Historical Institute.'),
            TextSpan(
              children: <TextSpan>[
                RomanText('Mantawe, Herb. (1998). '),
                ItalicRomanText('Ethnic Cleansing in the Philippines.'),
                RomanText(
                    ' [2012 March 11 ed.]. Retrieved March 23, 2012 from '),
                RomanText(
                  'http://dila.ph/ethnic.pdf',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('http://dila.ph/ethnic.pdf'),
                ),
                RomanText('.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Martinez, David C. (2004). '),
                ItalicRomanText(
                    'A Country of Our Own: Partitioning the Philippines.'),
                RomanText(' Los Angeles, California, USA: Bisaya Books.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Mas, Sinibaldo de (1843). '),
                RomanText(
                  'Informe sobre el estado de las Islas Filipinas en 1842',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://books.google.com.ph/books?id=rbM9AAAAIAAJ&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false'),
                ),
                RomanText('. Madrid. Vol 1.'),
              ],
            ),
            RomanText(
                'Morga, Antonio de. (1609) Sucesos de las Islas Filipinas. Obra publicada en Mejico el año de 1609 nuevamente sacada a luz y anotada por Jose Rizal y precedida de un prologo del Prof. Fernando Blumentritt, Impresion al offset de la Edicion Anotada por Rizal, Paris 1890. [Reprinted 1991] Manila, Philippines: National Historical Institute.'),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Murillo Velarde, Pedro. (1744). Mapa de las islas Filipinas. In '),
                ItalicRomanText(
                    'The Norman B. Leventhal Map Center at the Boston Public Library.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Pangilinan, Michael R.M. (2006a) '),
                RomanText(
                  'Kapampángan or Capampáñgan: Settling the Dispute on the Kapampángan Romanized Orthography',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://sil-philippines-languages.org/ical/papers/pangilinan-Dispute%20on%20Orthography.pdf'),
                ),
                RomanText(
                    '. A paper presented at the 10th International Conference on Austronesian Linguistiics, Puerto Princesa, Palawan, Philippines. January 2006.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Pangilinan, Michael R.M. (2009b). '),
                RomanText(
                  'Kapampangan lexical borrowing from Tagalog: endangerment rather than enrichment',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://www.academia.edu/5419261/Kapampangan_Lexical_Borrowing_from_Tagalog_Endangerment_rather_than_Enrichment'),
                ),
                RomanText(
                    '. A paper presented at the 11th International Conference on Austronesian Linguistics, June 21 – 25, 2009, Aussois, France.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('San Agustin, Gaspar de. (1699). '),
                ItalicRomanText(
                    'Conquistas de las Islas Philipinas 1565-1615.'),
                RomanText(
                    ' [1998 Bilingual Ed.: Spanish & English] Translated by Luis Antonio Mañeru. Published by Pedro Galende, OSA: Intramuros, Manila.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('San Antonio, Juan Francisco de. (1738-1744). '),
                ItalicRomanText(
                    'Cronicas de la apostolic provincial de S. Gregorio de religiosos de n.s.p. San Francisco en las islas Philipinas, China, Japon.'),
                RomanText(' Sampaloc: Juan del Sotillo.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Santiago, Luciano P.R. (1990a) The Houses of Lakandula, Matanda, and Soliman [1571-1898]: Genealogy and Group Identity. In '),
                ItalicRomanText(
                    'Philippine Quarterly of Culture and Society,'),
                RomanText(' Vol. 18, No. 1.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Scott, William Henry. (1984). '),
                ItalicRomanText(
                    'Prehispanic Source Materials for the Study of Philippine History.'),
                RomanText(' Quezon City: New Day Publishers.'),
              ],
            ),
            RomanText(
                'Scott, William Henry. (1994). Barangay: Sixteenth-Century Philippine Culture and Society, Quezon City: Ateneo de Manila University Press.'),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Tauchi Yonesaburo (田内米三郎). (1853). Toukikou (陶器考: Investigations of Pottery). '),
                ItalicRomanText('See'),
                RomanText(' English Translation in Cole, Fay–Cooper. (1912).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Tayag, Katoks (Renato). (1985). The Vanishing Pampango Nation. '),
                ItalicRomanText('Recollections & Digressions.'),
                RomanText(
                    ' Escolta, Manila: Philnabank Club c/o Philippine National Bank.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Wang, Teh-Ming (王徳明). (1989). '),
                ItalicRomanText(
                    'Sino Suluan Historical Relations in Ancient Texts.'),
                RomanText(
                    ' (Doctoral dissertation, University of the Philippines, Diliman, Quezon City, 2001). Unpublished typescript.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Wang, Zhenping. (2008). Reading Song-Ming Records on the Pre-colonial History of the Philippines. '),
                ItalicRomanText('東アジア文化交渉研究 創刊号.'),
                RomanText(' ['),
                ItalicRomanText('Higashi Ajia bunka kōshō kenkyū'),
                RomanText(', No.1] (2008): 249-260.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText(
                    'Wade, Geoff. [tr.] (2005) Southeast Asia in the Ming Shi-lu: an open access resource. Singapore: Asia Research Institute and the Singapore E-Press, National University of Singapore: '),
                RomanText(
                  'http://epress.nus.edu.sg/msl/place/1062',
                  TapGestureRecognizer()
                    ..onTap = () =>
                        _openURL('http://epress.nus.edu.sg/msl/place/1062'),
                ),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                RomanText('Zhang Xie (張燮). (1617). '),
                ItalicRomanText(
                    'Dong Xi Yang Gao [東西洋考] (A study of the Eastern and Western Oceans). '),
                RomanText(
                  'http://www.lib.kobe-u.ac.jp/directory/sumita/5A-161/index.html',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'http://www.lib.kobe-u.ac.jp/directory/sumita/5A-161/index.html'),
                ),
                RomanText(', Volume (分冊) 3:9.'),
              ],
            ),
          ],
        )
      ],
    );

    List<Widget> _pageStack = [
      Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              child: Column(
                children: <Widget>[
                  StickyHeading(
                    headingText: 'History',
                    showCredits: true,
                    content: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        _screenHorizontalPadding,
                        imageTopPadding - informationCreditsVerticalPadding,
                        _screenHorizontalPadding,
                        informationVerticalScreenPadding -
                            headerVerticalPadding +
                            8.0,
                      ),
                      child: _history,
                    ),
                  ),
                  StickyHeading(
                    headingText: 'References',
                    content: Padding(
                      padding: EdgeInsets.fromLTRB(
                        _screenHorizontalPadding,
                        informationSubtitleBottomPadding - headerVerticalPadding,
                        _screenHorizontalPadding,
                        informationVerticalScreenPadding,
                      ),
                      child: _references,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
