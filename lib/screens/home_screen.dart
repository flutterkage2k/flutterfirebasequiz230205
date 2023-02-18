import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebasequiz230205/ads/ad_mob_service.dart';
import 'package:flutterfirebasequiz230205/screens/play_quiz_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitRealId!,
      listener: AdMobService.bannerListener,
      request: const AdRequest(),
    )..load();
  }

  final CollectionReference quizStream1 =
      FirebaseFirestore.instance.collection("Quiz");

  Widget quizList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream1.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (streamSnapshot.connectionState == ConnectionState.done ||
              streamSnapshot.connectionState == ConnectionState.active) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return QuizTile(
                    imgUrl: documentSnapshot['quizImgUrl'],
                    title: documentSnapshot['quizTitle'],
                    desc: documentSnapshot['quizDesc'],
                    quizId: documentSnapshot['quizId'],
                  );
                },
              );
            } else {
              return Container();
            }
          } else {
            return Center(
              child: Text('State: ${streamSnapshot.connectionState}'),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => const CreateScreen()));
        //   },
        //   child: const Icon(Icons.add),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        body: quizList(),
        bottomNavigationBar: _bannerAd == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(
                  ad: _bannerAd!,
                ),
              ),
      ),
    );
  }
}

class QuizTile extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;
  const QuizTile({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.desc,
    required this.quizId,
  }) : super(key: key);

  @override
  State<QuizTile> createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  InterstitialAd? _interstitialAd;
  bool isAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    createInterstitialAd();
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobService.interstitialAdUnitRealId!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              print("interstitialAd Loaded");
              setState(() {
                _interstitialAd = ad;
                isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isAdLoaded) {
          showInterstitialAd();
        } else {
          createInterstitialAd();
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayQuiz(
              quizId: widget.quizId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 9),
        height: MediaQuery.of(context).size.height / 4.7,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Opacity(
                opacity: 0.6,
                child: Image.network(
                  widget.imgUrl,
                  width: MediaQuery.of(context).size.width - 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
