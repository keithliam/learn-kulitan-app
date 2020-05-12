import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/ImageWithCaption.dart';
import '../../components/misc/Paragraphs.dart';
import '../../db/GameData.dart';

class ArtworksPage extends StatefulWidget {
  const ArtworksPage();
  @override
  _ArtworksPageState createState() => _ArtworksPageState();
}

class _ArtworksPageState extends State<ArtworksPage> {
  static final GameData _gameData = GameData();
  final ScrollController _scrollController = ScrollController();

  bool _showBackToStartFAB = false;

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

  @override
  void dispose() {
    _scrollController.dispose();
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
        timeInSecForIos: 3,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  ImageWithCaption _artwork({
    @required String filename,
    @required String title,
    @required String author,
    @required String link,
    @required String portfolioLink,
    @required double screenWidth,
    Axis orientation = Axis.horizontal,
    double borderRadius = 0.0,
  }) {
    return ImageWithCaption(
      filename: filename,
      orientation: orientation,
      captionAlignment: TextAlign.center,
      caption: TextSpan(
        style: _gameData.getStyle('textInfoImageCaption'),
        children: <TextSpan>[
          TextSpan(
            text: title,
            style: _gameData.getStyle('textInfoImageCaptionLinkLarge'),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openURL(link)
          ),
          TextSpan(text: '\nby '),
          TextSpan(
            text: author,
            style: _gameData.getStyle('textInfoImageCaptionLink'),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _openURL(portfolioLink)
          ),
        ],
      ),
      imageLink: link,
      screenWidth: screenWidth,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenWidth = _mediaQuery.size.width;
    final double _screenHorizontalPadding =
        _screenWidth > maxPageWidth ? 0.0 : aboutHorizontalScreenPadding;
    final double _width = _mediaQuery.size.width > maxPageWidth
        ? maxPageWidth
        : _mediaQuery.size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final Widget _artworks = Column(
      children: <Widget>[
        Paragraphs(
          padding: 0.0,
          paragraphs: <TextSpan>[
            RomanText('To view a full-quality version of an artwork, tap on its photo or title.'),
          ],
        ),
        _artwork(
          filename: 'art_mabiasa_kang_manaya.jpg',
          title: 'mabiása kang manáya',
          author: 'Calvin Concepcion',
          link: 'https://www.facebook.com/photo?fbid=2712766308818463&set=g.267202316630290',
          portfolioLink: 'https://www.facebook.com/clvncncpcn/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_aslag.jpg',
          title: 'Aslag',
          author: 'Sachi Liwag',
          link: 'https://www.facebook.com/CarisuSachi25/posts/3292517730777769',
          portfolioLink: 'https://www.behance.net/SachiLiwag',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_painawa.jpg',
          title: 'Paináwa',
          author: 'Sachi Liwag',
          link: 'https://www.facebook.com/CarisuSachi25/posts/3292517730777769',
          portfolioLink: 'https://www.behance.net/SachiLiwag',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_sulapo.jpg',
          title: 'Sulápo',
          author: 'Sachi Liwag',
          link: 'https://www.facebook.com/CarisuSachi25/posts/3292517730777769',
          portfolioLink: 'https://www.behance.net/SachiLiwag',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_sampernandu.jpg',
          title: 'Sampernandu',
          author: 'Jayvie Aboyme',
          link: 'https://www.facebook.com/jayviesuasiaboyme',
          portfolioLink: 'https://www.facebook.com/jayviesuasiaboyme',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_salangi_ko_pu.jpg',
          title: 'Sálángî Kó Pû',
          author: 'Dacayánan Lloyd',
          link: 'https://www.facebook.com/photo?fbid=2602575863395368&set=g.267202316630290',
          portfolioLink: 'https://www.facebook.com/profile.php?id=100009289392118',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_manyaman.jpg',
          title: 'Manyáman ku',
          author: 'Gabriel Gatbonton',
          link: 'https://www.facebook.com/gabriel.gatbonton.26',
          portfolioLink: 'https://imgur.com/79O2WO9',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_sunlag.jpg',
          title: 'Sunlag/Buklúran ning Amánung Sísuan',
          author: 'Linguistics Society Club',
          link: 'https://www.facebook.com/LinguisticsSoc/photos/a.124568129004431/124568102337767/?type=3&eid=ARBf3bjWymKOf95d79LD2ME2IHu4e6NmQGVCghu7o_01KyHbCku2dUNVU5WjK8wI5JU5ut7Js6O4s-aq&__xts__%5B0%5D=68.ARB5kD1CYBASCq0E0EBrjxHPD6zoo5YIZS5y8w4EUeY8ayNzCrfRLcafnRBKozJxxH03FA7LErkjAfLK4_w0TzOorLi2Fdq9skktdGwujcphXgmiBHWLGLRxfJYM7nghYyMblfVQ78s95-6iBMgV6e4U4pwedw_l_3-V26Vjn29c_iQ6yBXIBRdsjQ5QUauwbIk9sZeKEe-2V5D0EBypILp341jWZCgWS2aW1AT795Dd4j65M_m3TLKdatlghrzWJDKDVFXLrkONf-wH6hwJDcOLTtqXrERPL0YFFNQVi22AZXsM6v1DQlncKCRRjKsI63Qau9X6W8AM2bcZdvpmbyk&__tn__=EEHH-R',
          portfolioLink: 'https://www.facebook.com/LinguisticsSoc/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_snellen.jpg',
          title: 'Kulitan Snellen Chart',
          author: 'Keith Liam Manaloto',
          link: 'https://www.facebook.com/masakeith/posts/10156548236876009',
          portfolioLink: 'https://www.behance.net/keithliam',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_kaluguran.jpg',
          title: 'Kaluguran',
          author: 'Lovely Pearl Vitocruz',
          link: 'https://www.facebook.com/photo.php?fbid=661017137996250&set=pb.100022639095270.-2207520000..&type=3',
          portfolioLink: 'https://www.facebook.com/lesser.lessen/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_kapampangan_kami.png',
          title: 'Kapampangan Kami Keti',
          author: 'Jervin Enriquez / Jayken Nucum',
          link: 'https://drive.google.com/drive/folders/1dAcLNUBhsDo3NouTYOJHsdQlWIptL7qY',
          portfolioLink: 'https://www.facebook.com/Jervin070394',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_lords_prayer.jpg',
          title: 'The Lord\'s Prayer',
          author: 'Raymond Bondoc Figueroa',
          link: 'https://www.facebook.com/story.php?story_fbid=1171033989896658&id=100009702047712',
          portfolioLink: 'https://www.facebook.com/raymond.figueroa.1048',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_bulan.jpg',
          title: 'Bápûng Búlan a Maliári',
          author: 'Raphael Aguipo',
          link: 'https://www.facebook.com/photo?fbid=3128342403867246&set=a.555695087798670',
          portfolioLink: 'https://www.facebook.com/raphael.aguipo17/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_atin_ku_pung_singsing.jpg',
          title: 'Atin Ku Pûng Singsing at Clark Marriott Hotel',
          author: 'Mike Pangilinan',
          link: 'http://siuala.com/kulitan-the-indigenous-kapampangan-script/',
          portfolioLink: 'http://siuala.com',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_indu_logo.jpg',
          title: 'INDÛ',
          author: 'INDÛ',
          link: 'https://www.facebook.com/photo/?fbid=1154949988020480&set=a.441161659399320',
          portfolioLink: 'https://www.facebook.com/indulifestyle/',
          screenWidth: _width,
          borderRadius: 0.1,
        ),
        _artwork(
          filename: 'art_indu_shirt.jpg',
          title: 'Sicluban Shirt',
          author: 'INDÛ',
          link: 'https://www.facebook.com/photo/?fbid=1280310968817714&set=a.441161659399320',
          portfolioLink: 'https://www.facebook.com/indulifestyle/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_salangi_ko_pu_wall.jpg',
          title: 'Sálángî kó pû',
          author: 'Newpoint Mall / Bruno Tiotuico',
          link: 'https://www.instagram.com/p/BJ0TULsDW20/',
          portfolioLink: 'https://www.facebook.com/newpointmall',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_salangi_mag_1.jpg',
          title: 'Sálángî Kó Pû Magazine',
          author: 'Angeles City Tourism Office / Bruno Tiotuico',
          link: 'https://www.imgur.com/a/ZiSCsZB',
          portfolioLink: 'http://brunotiotuico.daportfolio.com/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_salangi_mag_2.jpg',
          title: 'Sálángî Kó Pû Magazine',
          author: 'Angeles City Tourism Office / Bruno Tiotuico',
          link: 'https://www.imgur.com/a/ZiSCsZB',
          portfolioLink: 'http://brunotiotuico.daportfolio.com/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_himno.jpg',
          title: 'Imno ning Kapampángan',
          author: 'Krist John Lalic',
          link: 'https://www.facebook.com/photo.php?fbid=2878335122200729&set=g.267202316630290&type=1&theater&ifg=1',
          portfolioLink: 'https://www.facebook.com/Cyrix09',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_batak.jpg',
          title: 'Batak',
          author: 'Line of Seven',
          link: 'https://www.facebook.com/lineofseven/photos/a.1505805869463626/1505806246130255/?type=3/',
          portfolioLink: 'https://www.facebook.com/lineofseven/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_bayani.jpg',
          title: 'Bayánî',
          author: 'Line of Seven',
          link: 'https://www.facebook.com/lineofseven/photos/a.1211925312185018/2928242480553284/?type=3',
          portfolioLink: 'https://www.facebook.com/lineofseven/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_babo_libutad_lalam.jpg',
          title: 'Babo. Libutad. Lalam.',
          author: 'Wear Kapampangan',
          link: 'https://www.facebook.com/photo/?fbid=1186900614704245&set=a.158236357570681',
          portfolioLink: 'https://www.facebook.com/wearkapampangan',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_sikluban.jpg',
          title: 'Siklúban Wallpaper',
          author: 'Jayken Figueroa Nucum',
          link: 'https://drive.google.com/folderview?id=1dAcLNUBhsDo3NouTYOJHsdQlWIptL7qY',
          portfolioLink: 'https://www.facebook.com/jaykenfnucum/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_taram_kalis.jpg',
          title: 'Taram Kalis Brand',
          author: 'Eugene David Ngo',
          link: 'https://kapampangan.org/taram-kalis/',
          portfolioLink: 'https://www.facebook.com/eugene.a.ngo',
          screenWidth: _width,
          borderRadius: 1.0,
        ),
        _artwork(
          filename: 'art_banners.jpg',
          title: 'Guinú ning labuad Kapampángan',
          author: 'Linguistics Society Club',
          link: 'https://www.facebook.com/media/set/?set=a.140720707389173&type=3&__xts__%5B0%5D=68.ARDB6WxI1ae3vec5LDn7LJ_S88YvnuGL0EhVi43SZghMqfOsh901IxV2xVTe4F6CvMIV9JiUltpCTj1yaUVpERJWkS6kWDFsTLEpJoJEIWSOA0QdtR2L2SDmHBU6AMonYaoKW1j4ChCekgc3ao_fnwpMimrt7CRWX92DOnCLJ6wLEbpayJn7VIf6P0wOPLnNC8-ibHNo9hf4fuQX8Op5yD-67gA9bJHDVwkuwvNipn6nGE56tXEWk45U0GsYppMiFDJVc_epUO-FnkK-WLQHZDgzkKBeJuK4cMS81vUTXXtiPH4MaRv1OjX8JgqntvX9PMkM0ehfIioOajJkpiDa3ii4hPHjLi6nM7ompL6_C-R9V4M9TB-vVdiLyHJ7ei7CmQHp0LbUZRn8yhNplY5gbexmEpKwpZ45PmdFM5awy9vxuS6phBm5Tz71k74K-2PsmHk9TT_J12Gc1QJgVA&__tn__=-UC-R',
          portfolioLink: 'https://www.facebook.com/LinguisticsSoc/',
          screenWidth: _width,
        ),
        _artwork(
          filename: 'art_banners1.jpg',
          title: 'Guinú ning labuad Kapampángan',
          author: 'Linguistics Society Club',
          link: 'https://www.facebook.com/media/set/?set=a.140720707389173&type=3&__xts__%5B0%5D=68.ARDB6WxI1ae3vec5LDn7LJ_S88YvnuGL0EhVi43SZghMqfOsh901IxV2xVTe4F6CvMIV9JiUltpCTj1yaUVpERJWkS6kWDFsTLEpJoJEIWSOA0QdtR2L2SDmHBU6AMonYaoKW1j4ChCekgc3ao_fnwpMimrt7CRWX92DOnCLJ6wLEbpayJn7VIf6P0wOPLnNC8-ibHNo9hf4fuQX8Op5yD-67gA9bJHDVwkuwvNipn6nGE56tXEWk45U0GsYppMiFDJVc_epUO-FnkK-WLQHZDgzkKBeJuK4cMS81vUTXXtiPH4MaRv1OjX8JgqntvX9PMkM0ehfIioOajJkpiDa3ii4hPHjLi6nM7ompL6_C-R9V4M9TB-vVdiLyHJ7ei7CmQHp0LbUZRn8yhNplY5gbexmEpKwpZ45PmdFM5awy9vxuS6phBm5Tz71k74K-2PsmHk9TT_J12Gc1QJgVA&__tn__=-UC-R',
          portfolioLink: 'https://www.facebook.com/LinguisticsSoc/',
          screenWidth: _width,
        ),
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
                    headingText: 'Kalalangan',
                    content: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding,
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding - headerVerticalPadding + 8.0,
                      ),
                      child: _artworks,
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
