import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/IconButtonNew.dart';
import '../../../components/misc/StaticHeader.dart';
import '../../../components/misc/StickyHeading.dart';
import './components.dart';

class HistoryPage extends StatelessWidget {
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
          onPressed: () => Navigator.of(context).pop(),
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
      padding: const EdgeInsets.fromLTRB(
        informationVerticalScreenPadding,
        3.0,
        informationVerticalScreenPadding,
        0.0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: RichText(
            text: TextSpan(
              style: textInfoCredits,
              children: [
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

    final Widget _history = Column(
      children: <Widget>[
        ImageWithCaption(
          filename: 'history_kulitan.png',
          caption: TextSpan(text: 'KASALÉSAYAN'),
          subcaption: 'HISTORY',
          screenWidth: _width,
          hasPadding: false,
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Long before the idea of a Filipino nation was even conceived, the Kapampangan, Butuanon, Tausug, Magindanau, Hiligaynon, Sugbuanon, Waray, Iloko, Sambal and many other ethnolinguistic groups within the archipelago, already existed as '),
                TextSpan(text: 'bangsâ', style: textInfoTextItalic),
                TextSpan(
                    text:
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
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 1.',
                  style: textInfoImageCaption.copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' The Kingdom of Luzon (呂宋國) as it appears on a Japanese map during the Ming dynasty (1368 to 1644). From “A look at history based on Ming dynasty maps” (從大明坤輿萬國 圖看歷史) posted by zhaijia1987 in '),
              TextSpan(
                  text: 'Baidu Tieba (百度贴吧)',
                  style: textInfoImageCaption.copyWith(
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
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 2.',
                  style: textInfoImageCaption.copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text: ' Map of Pampanga from Pedro Murillo Velarde’s 1744 '),
              TextSpan(
                  text: 'Mapa de las Islas Filipinas.',
                  style: textInfoImageCaption.copyWith(
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
                TextSpan(
                    text:
                        'The Kapampangan nation was once a part of the Kingdom of Luzon [Fig. 1]. They were one of the '),
                TextSpan(text: 'Luçoes'),
                TextSpan(
                    text:
                        ', ‘people of Luzon’, encountered by Portuguese explorers during their initial ventures into Southeast Asia in the early 16th century (Scott, 1994). The Kapampangan homeland, '),
                TextSpan(text: 'Indûng Kapampángan'),
                TextSpan(
                    text:
                        ' (Pampanga), became the first province carved out of the Kingdom of Luzon when the Spaniards conquered it in 1571 C.E. (Cavada, 1876 and Henson, 1965). Indûng Kapampángan’s political boundaries once encompassed a large portion of the central plains of Luzon, stretching from the eastern coastline of the Bataan Peninsula in the Southwest, all the way to Casiguran Bay in the Northeast (Murillo Velarde, 1744; San Antonio, 1744; Beyer, 1918; Henson, 1965; Larkin, 1972 and Tayag, 1985) [Fig 2.]. It was said to be the most populated region in Luzon at that time, with an established agricultural base that can support a huge population (Loarca, 1583; San Agustin, 1699; Mallat, 1846; B&R, 1905; Henson, 1965 and Larkin, 1972). It also has a highly advanced material culture where Chinese porcelain is used extensively and where firearms and bronze cannons were manufactured (Morga, 1609; Mas, 1843; B&R, 1905; Beyer, 1947; Larkin, 1972; Santiago, 1990b and Dizon, 1999). The old capital of the Kingdom of Luzon, Tondo (東都: “Eastern Capital”), once spoke one language with the rest of Indûng Kapampángan that is different from the language spoken in Manila (Loarca, 1583; B&R, 1905 and Tayag, 1985). Jose Villa Panganiban, the former commissioner of the Institute of National Language, once thought the Pasig River that divides Tondo and Manila to be the same dividing line between Kapampangan and Tagalog (Tayag, 1985). The descendants of the old rulers of the Kingdom of Luzon, namely those of Salalílâ, Lakandúlâ and Suliman, can still be found all over Indûng Kapampángan (Beyer, 1918; Beyer, 1943; Henson, 1965 and Santiago, 1990a).'),
              ],
            ),
          ],
        ),
        ImageWithCaption(
          filename: 'luzon_jar.jpeg',
          screenWidth: _width,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 3.',
                  style: textInfoImageCaption.copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' A typical brown-glazed four-eared Luzon jar (呂宋壷 [褐釉 四耳壷]) exported to Japan by the Kingdom of Luzon in the mid-16th century. Photo courtesy of Hikone Castle Museum (彦根城博物館) Newsletter, Vol. 13, 1991 May 1.Figure 3. A typical brown-glazed four-eared Luzon jar (呂宋壷 [褐釉 四耳壷]) exported to Japan by the Kingdom of Luzon in the mid-16th century. Photo courtesy of Hikone Castle Museum (彦根城博物館) Newsletter, Vol. 13, 1991 May 1.'),
            ],
          ),
        ),
        ImageWithCaption(
          filename: 'tokiko.jpeg',
          screenWidth: _width,
          caption: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'Figure 4.',
                  style: textInfoImageCaption.copyWith(
                      fontStyle: FontStyle.italic)),
              TextSpan(
                  text:
                      ' A page in Faye-Cooper Cole’s English translation of Tauchi Yonesaburo’s '),
              TextSpan(
                  text: 'Tokiko',
                  style: textInfoImageCaption.copyWith(
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
                TextSpan(
                    text:
                        'If the Kapampangan nation made up the bulk of the population of the Kingdom of Luzon, then perhaps the oldest evidence of Kapampangan writing can be found in the jars (呂宋壺) exported to Japan prior to the arrival of the Spaniards in the 16th century C.E. [Fig. 3]. In his book '),
                TextSpan(text: 'Tokiko', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (陶器考) or “Investigations of Pottery” published in 1853 C.E., Tauchi Yonesaburo (田内米三郎) presents several jars marked with the '),
                TextSpan(text: 'ruson koku ji', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (呂宋國字) or the “writing of the Kingdom of Luzon” (Tauchi [田内], 1853 and Cole, 1912). The marks that looked like the Chinese character '),
                TextSpan(text: 'ting', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (丁) found in several Luzon jars might have been the indigenous Kapampangan script '),
                TextSpan(text: 'la', style: textInfoTextItalic),
                TextSpan(text: ' ('),
                TextSpan(text: 'la', style: kulitanInfoText),
                TextSpan(
                    text:
                        '), the first syllable in the name “Luzon” [Fig. 4].'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Writing has always been a testament to civilization among the great nations. The Chinese write ‘civilization’ as '),
                TextSpan(text: 'wénmíng', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (文明) or ‘enlightenment through writing’, combining the characters '),
                TextSpan(text: 'wén', style: textInfoTextItalic),
                TextSpan(text: ' (文) ‘writing’ and '),
                TextSpan(text: 'míng', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (明) ‘brightness’. Sadly, the Kapampangan nation, a once proud civilization with a long established literature has now become a tribe of confused barbarians. Although many Kapampangans can read and write fluently in foreign languages, namely Filipino and English, they are strangely illiterate in their own native Kapampangan language.'),
              ],
            ),
            TextSpan(
                text:
                    'The Kapampangan language currently does not possess a standard written orthography. The dispute on which orthography to use when writing the Kapampangan language in the Latin Script ~ whether to retain the old Spanish style orthography a.k.a. Súlat Bacúlud or implement the indigenized Súlat Wáwâ which replaced the Q and C with the letter K, remains unsettled. This unending battle on orthography has taken its toll on the development of Kapampangan literature and the literacy of the Kapampangan speaking majority (Pangilinan, 2006 and 2009b). No written masterpiece that could rival the works of the Kapampangan literary giants of the late 19th and early 20th centuries has yet been written. The few poems that earned a number of contemporary poets the title of Poet Laureate no longer have the same impact that would immortalize them in the people’s collective memory. Worse, the Kapampangan language is now even showing signs of decay and endangerment (Del Corro, 2000 and Pangilinan, 2009b).'),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'While the old literary elite continue to bicker endlessly which Latinized attitudinal procedure to follow, a small yet growing number of Kapampangan youth have become frustrated and disillusioned with the current state of Kapampangan language and culture. They see the old Spanish style orthography that still uses the letters C & Q as a perpetuation of Spain’s hold into the intellectual expressions of the Kapampangan people. The new orthography that has replaced the letters C and Q with K is also viewed to be foreign since they identify it with the Tagalog '),
                TextSpan(text: 'w', style: textInfoTextItalic),
                TextSpan(
                    text:
                        '. Instead of being forced to choose which orthography to use in writing Kapampangan, they chose to forego the use of the Latin script altogether. They decided instead to go back to writing in the indigenous '),
                TextSpan(
                    text: 'Súlat Kapampángan', style: textInfoTextItalic),
                TextSpan(text: ' or '),
                TextSpan(text: 'Kulitan.', style: textInfoTextItalic),
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
                TextSpan(
                    text:
                        'Avila, Bobit. (2007 August 24). Ethnic cleansing our own Filipino brethren? In '),
                TextSpan(
                    text: 'The Philippine Star.', style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' Retrieved 2012 March 16 from http://www.philstar.com/Article.aspx?articleId=15037.',
                    style: textInfoText.copyWith(color: linksColor)),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Beyer, Henry Otley. (1918). '),
                TextSpan(
                    text:
                        'Ethnography of the Pampangan People: A Comprehensive Collection of Original Sources.',
                    style: textInfoTextItalic),
                TextSpan(text: ' Vol. 1& 2. Manila, Philippines. [Microfilm].'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Beyer, Henry Otley. (1943). '),
                TextSpan(
                    text: 'A Brief History of Fort Santiago.',
                    style: textInfoTextItalic),
                TextSpan(text: ' Manila (no publisher).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Cavada, Agustin de la. (1876). '),
                TextSpan(
                    text:
                        'Historia geográfica, geológica y estadistica de Filipinas.',
                    style: textInfoTextItalic),
                TextSpan(text: ' 2 vols. Manila: Ramirez y Giraudier.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Cole, Fay–Cooper. (1912) '),
                TextSpan(
                    text: 'Chinese Pottery in the Philippines.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' Field Museum of Natural History Anthropological Series,Vol. 12 (1), Chicago.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Constitution of the Republic of the Philippines (1987). In '),
                TextSpan(
                    text: 'Chan Robles Virtual Law Library. ',
                    style: textInfoTextItalic),
                TextSpan(text: ' Retrieved June 6, 2009 from '),
                TextSpan(
                  text: 'http://www.chanrobles.com/article14language.htm',
                  style: textInfoText.copyWith(color: linksColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'http://www.chanrobles.com/article14language.htm'),
                ),
                TextSpan(text: '.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Defenders of the Indigenous Languages of the Archipelago (DILA). (2007). '),
                TextSpan(
                    text: 'Filipino is not our language.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' Angeles City, Pampanga: Defenders of the Indigenous Languages of the Archipelago (DILA).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Del Corro, Anicia. (2000). '),
                TextSpan(
                    text: 'Language Endangerment and Bible Translation.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' Malaga, Spain: Universal Bible Society Triennial Translation Workshop.'),
              ],
            ),
            TextSpan(
                text:
                    'Dizon, Eusebio et al. (5 October 1999).  Southeast Asian Protohistoric Archaeology at Porac, Pampanga, Central Luzon, Philippines. Mid-Year Progress Report. Archaeological Studies Program. University of the Philippines at Diliman, Quezon City, Philippines.'),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Henson, Mariano A. (1965). '),
                TextSpan(
                    text:
                        'The Province of Pampanga and Its Towns: A.D. 1300-1965.',
                    style: textInfoTextItalic),
                TextSpan(
                    text: ' 4th ed. revised. Angeles City: Mariano A. Henson.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Larkin, John A. (1972). '),
                TextSpan(
                    text:
                        'The Pampangans: Colonial Society in a Philippine Province.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' 1993 Philippine Edition. Quezon City: New Day Publishers.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Loarca, Miguel de. (1583) Relacion de las Yslas Filipinas. In E. Blair and J. Robertson, eds. and trans. '),
                TextSpan(
                    text: 'The Philippine Islands, 1493-1898',
                    style: textInfoTextItalic),
                TextSpan(text: ', volume 5, page 34 – 187.'),
              ],
            ),
            TextSpan(
                text:
                    'Mallat, Jean. (1846). Les Philippines: histoire, geographie, mœurs, agriculture, industrie, commerce des colonies Espagnoles dans l’Oceanie. Paris: Arthus Bertrand. [English ed. 1998] Santillan, P. and Castrence, L. (Transl.), Manila: National Historical Institute.'),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Mantawe, Herb. (1998). '),
                TextSpan(
                    text: 'Ethnic Cleansing in the Philippines.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' [2012 March 11 ed.]. Retrieved March 23, 2012 from '),
                TextSpan(
                  text: 'http://dila.ph/ethnic.pdf',
                  style: textInfoText.copyWith(color: linksColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL('http://dila.ph/ethnic.pdf'),
                ),
                TextSpan(text: '.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Martinez, David C. (2004). '),
                TextSpan(
                    text: 'A Country of Our Own: Partitioning the Philippines.',
                    style: textInfoTextItalic),
                TextSpan(text: ' Los Angeles, California, USA: Bisaya Books.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Mas, Sinibaldo de (1843). '),
                TextSpan(
                  text:
                      'Informe sobre el estado de las Islas Filipinas en 1842',
                  style: textInfoText.copyWith(
                      color: linksColor, fontStyle: FontStyle.italic),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://books.google.com.ph/books?id=rbM9AAAAIAAJ&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false'),
                ),
                TextSpan(text: '. Madrid. '),
                TextSpan(text: 'Vol 1'),
                TextSpan(text: '.'),
              ],
            ),
            TextSpan(
                text:
                    'Morga, Antonio de. (1609) Sucesos de las Islas Filipinas. Obra publicada en Mejico el año de 1609 nuevamente sacada a luz y anotada por Jose Rizal y precedida de un prologo del Prof. Fernando Blumentritt, Impresion al offset de la Edicion Anotada por Rizal, Paris 1890. [Reprinted 1991] Manila, Philippines: National Historical Institute.'),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Murillo Velarde, Pedro. (1744). Mapa de las islas Filipinas. In '),
                TextSpan(
                    text:
                        'The Norman B. Leventhal Map Center at the Boston Public Library.',
                    style: textInfoTextItalic),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Pangilinan, Michael R.M. (2006a) '),
                TextSpan(
                  text:
                      'Kapampángan or Capampáñgan: Settling the Dispute on the Kapampángan Romanized Orthography',
                  style: textInfoText.copyWith(
                      color: linksColor, fontStyle: FontStyle.italic),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://sil-philippines-languages.org/ical/papers/pangilinan-Dispute%20on%20Orthography.pdf'),
                ),
                TextSpan(text: '.'),
                TextSpan(
                    text:
                        ' A paper presented at the 10th International Conference on Austronesian Linguistiics, Puerto Princesa, Palawan, Philippines. January 2006.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Pangilinan, Michael R.M. (2009b). '),
                TextSpan(
                  text:
                      'Kapampangan lexical borrowing from Tagalog: endangerment rather than enrichment',
                  style: textInfoText.copyWith(
                      color: linksColor, fontStyle: FontStyle.italic),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://www.academia.edu/5419261/Kapampangan_Lexical_Borrowing_from_Tagalog_Endangerment_rather_than_Enrichment'),
                ),
                TextSpan(text: '.'),
                TextSpan(
                    text:
                        ' A paper presented at the 11th International Conference on Austronesian Linguistics, June 21 – 25, 2009, Aussois, France.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'San Agustin, Gaspar de. (1699). '),
                TextSpan(
                    text: 'Conquistas de las Islas Philipinas 1565-1615.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' [1998 Bilingual Ed.: Spanish & English] Translated by Luis Antonio Mañeru. Published by Pedro Galende, OSA: Intramuros, Manila.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'San Antonio, Juan Francisco de. (1738-1744). '),
                TextSpan(
                    text:
                        'Cronicas de la apostolic provincial de S. Gregorio de religiosos de n.s.p. San Francisco en las islas Philipinas, China, Japon.',
                    style: textInfoTextItalic),
                TextSpan(text: ' Sampaloc: Juan del Sotillo.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Santiago, Luciano P.R. (1990a) The Houses of Lakandula, Matanda, and Soliman [1571-1898]: Genealogy and Group Identity. In '),
                TextSpan(
                    text: 'Philippine Quarterly of Culture and Society,',
                    style: textInfoTextItalic),
                TextSpan(text: ' Vol. 18, No. 1.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Scott, William Henry. (1984). '),
                TextSpan(
                    text:
                        'Prehispanic Source Materials for the Study of Philippine History.',
                    style: textInfoTextItalic),
                TextSpan(text: ' Quezon City: New Day Publishers.'),
              ],
            ),
            TextSpan(
                text:
                    'Scott, William Henry. (1994). Barangay: Sixteenth-Century Philippine Culture and Society, Quezon City: Ateneo de Manila University Press.'),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Tauchi Yonesaburo (田内米三郎). (1853). Toukikou (陶器考: Investigations of Pottery). '),
                TextSpan(text: 'See', style: textInfoTextItalic),
                TextSpan(
                    text: ' English Translation in Cole, Fay–Cooper. (1912).'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Tayag, Katoks (Renato). (1985). The Vanishing Pampango Nation. '),
                TextSpan(
                    text: 'Recollections & Digressions.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' Escolta, Manila: Philnabank Club c/o Philippine National Bank.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Wang, Teh-Ming (王徳明). (1989). '),
                TextSpan(
                    text: 'Sino Suluan Historical Relations in Ancient Texts.',
                    style: textInfoTextItalic),
                TextSpan(
                    text:
                        ' (Doctoral dissertation, University of the Philippines, Diliman, Quezon City, 2001). Unpublished typescript.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Wang, Zhenping. (2008). Reading Song-Ming Records on the Pre-colonial History of the Philippines. '),
                TextSpan(text: '東アジア文化交渉研究 創刊号.', style: textInfoTextItalic),
                TextSpan(text: ' ['),
                TextSpan(
                    text: 'Higashi Ajia bunka kōshō kenkyū',
                    style: textInfoTextItalic),
                TextSpan(text: ', No.1] (2008): 249-260.'),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Wade, Geoff. [tr.] (2005) Southeast Asia in the Ming Shi-lu: an open access resource. Singapore: Asia Research Institute and the Singapore E-Press, National University of Singapore: '),
                TextSpan(
                  text: 'http://epress.nus.edu.sg/msl/place/1062',
                  style: textInfoText.copyWith(color: linksColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        _openURL('http://epress.nus.edu.sg/msl/place/1062'),
                ),
              ],
            ),
            TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Zhang Xie (張燮). (1617). '),
                TextSpan(
                    text:
                        'Dong Xi Yang Gao [東西洋考] (A study of the Eastern and Western Oceans). ',
                    style: textInfoTextItalic),
                TextSpan(
                  text:
                      'http://www.lib.kobe-u.ac.jp/directory/sumita/5A-161/index.html',
                  style: textInfoText.copyWith(color: linksColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'http://www.lib.kobe-u.ac.jp/directory/sumita/5A-161/index.html'),
                ),
                TextSpan(text: ', Volume (分冊) 3:9.'),
              ],
            ),
          ],
        )
      ],
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: <Widget>[
            Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    StickyHeading(
                      headingText: 'History',
                      content: Column(
                        children: <Widget>[
                          _pageCredits,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(
                              informationHorizontalScreenPadding,
                              imageTopPadding,
                              informationHorizontalScreenPadding,
                              informationVerticalScreenPadding -
                                  headerVerticalPadding +
                                  8.0,
                            ),
                            child: _history,
                          ),
                        ],
                      ),
                    ),
                    StickyHeading(
                      headingText: 'References',
                      content: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          informationHorizontalScreenPadding,
                          informationSubtitleBottomPadding -
                              headerVerticalPadding,
                          informationHorizontalScreenPadding,
                          informationVerticalScreenPadding,
                        ),
                        child: _references,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _header,
          ],
        ),
      ),
    );
  }
}
