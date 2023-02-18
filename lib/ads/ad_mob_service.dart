import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitTestId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }

    return null;
  }

  static String? get bannerAdUnitRealId {
    if (Platform.isIOS) {
      return 'ca-app-pub-5673747993774414/8340233834';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5673747993774414/4984546401';
    }

    return null;
  }

  static String? get interstitialAdUnitTestId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }

    return null;
  }

  static String? get interstitialAdUnitRealId {
    if (Platform.isIOS) {
      return 'ca-app-pub-5673747993774414/8258125746';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5673747993774414/8507754796';
    }

    return null;
  }

  static final BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad loaded.'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad failed to load: $error');
      });
}
