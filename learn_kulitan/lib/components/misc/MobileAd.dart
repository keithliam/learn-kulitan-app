import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AdMob {
  static final AdMob _instance = AdMob._internal();
  factory AdMob() => _instance;
  AdMob._internal();

  static MobileAdTargetingInfo _info = MobileAdTargetingInfo(
    keywords: <String>[
      'games',
      'learning',
      'education',
      'philippines',
      'filipino',
      'kapampangan',
      'kulitan',
      'language'
    ],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>['LHS7N18C25019181'],
  );

  BannerAd _banner;
  MobileAdEvent _bannerStatus;
  bool _showBanner = false;
  bool _bannerFailed = false;
  void Function() _adjustScreen;

  InterstitialAd _interstitial;
  MobileAdEvent _interstitialStatus;
  bool _showInterstitial = false;

  RewardedVideoAd _video;

  Future<void> initialize() async {
    FirebaseAdMob.instance.initialize(appId: 'FirebaseAdMob.testAppId');
    _createBanner();
    _createInterstitial();
  }

  void _createBanner() {
    _banner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: _info,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          if (!_bannerFailed) {
            _bannerFailed = true;
            _bannerStatus = event;
            Timer.periodic(const Duration(seconds: 5), (Timer timer) {
              if (_bannerStatus == MobileAdEvent.loaded && _showBanner)
                timer.cancel();
              else if (_showBanner) _createBanner();
            });
          }
        } else if (event == MobileAdEvent.loaded) {
          _bannerFailed = false;
          _bannerStatus = event;
          if (_showBanner) {
            _adjustScreen();
            _banner.show();
          }
        } else if (event == MobileAdEvent.closed) {
          _bannerFailed = false;
          _bannerStatus = event;
          if (_showBanner) _createBanner();
        }
      },
    )..load();
  }

  void _createInterstitial() {
    _interstitial = InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: _info,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          _interstitialStatus = event;
        } else if (event == MobileAdEvent.loaded) {
          _interstitialStatus = event;
          if (_showInterstitial) _interstitial.show();
        } else if (event == MobileAdEvent.closed) {
          _interstitialStatus = event;
          if (_showInterstitial) _createInterstitial();
        }
      },
    )..load();
  }

  void showBanner({void Function() adjustScreen}) {
    if (!_showBanner) {
      _showBanner = true;
      _adjustScreen = adjustScreen;
      if (_bannerStatus == MobileAdEvent.loaded) {
        _adjustScreen();
        _banner.show();
      }
    }
  }

  void closeBanner() async {
    if (_showBanner) {
      _showBanner = false;
      if (_bannerStatus == MobileAdEvent.loaded) _banner?.dispose();
      _adjustScreen = null;
      _bannerStatus = null;
      _createBanner();
    }
  }

  void showInterstitial() {
    if (!_showInterstitial) {
      _showInterstitial = true;
      if (_interstitialStatus == MobileAdEvent.loaded) _interstitial.show();
    }
  }

  get bannerExists => _showBanner && _bannerStatus == MobileAdEvent.loaded;
  get bannerSize => _showBanner ? _banner.size : Size(0.0, 0.0);

  void dispose() {
    closeBanner();
    _interstitial?.dispose();
  }

  static double getSmartBannerHeight(MediaQueryData mediaQuery) {
    if (Platform.isAndroid) {
      if (mediaQuery.size.height > 720) return 90.0;
      if (mediaQuery.size.height > 400) return 50.0;
      return 32.0;
    }
    if (Platform.isIOS) {
      if (mediaQuery.size.height >= 800) return 90.0;
      if (mediaQuery.orientation == Orientation.portrait) return 50.0;
      return 32.0;
    }
    return 50.0;
  }
}

class MobileBannerAd extends StatefulWidget {
  const MobileBannerAd({
    @required this.child,
    this.padding = 0.0,
    this.showBannerStream,
  });

  final Widget child;
  final double padding;
  final Stream showBannerStream;

  @override
  MobileBannerAdState createState() => MobileBannerAdState();
}

class MobileBannerAdState extends State<MobileBannerAd> {
  static final AdMob _ads = AdMob();
  double _bottomPadding = 0.0;

  StreamSubscription _showBannerStreamSubscription;

  void _showBanner() {
    _ads.showBanner(adjustScreen: () {
      setState(
        () =>
            _bottomPadding = AdMob.getSmartBannerHeight(MediaQuery.of(context)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.showBannerStream != null)
      _showBannerStreamSubscription = widget.showBannerStream.listen((_) {
        _showBanner();
      });
    if (!_ads.bannerExists) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBanner();
      });
    }
    _bottomPadding = widget.padding;
  }

  @override
  void didUpdateWidget(MobileBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBannerStream != oldWidget.showBannerStream) {
      _showBannerStreamSubscription = widget.showBannerStream.listen((_) {
        _showBanner();
      });
    }
  }

  @override
  void dispose() {
    _showBannerStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: _bottomPadding),
      child: widget.child,
    );
  }
}
