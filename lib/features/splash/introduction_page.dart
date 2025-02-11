import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_example/generated/assets.dart';
import 'package:training_example/main.dart';

import '../../constants/fonts.dart';
import 'introduction_page_view.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  bool isFirstPage = true;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Visibility(
            visible: !isFirstPage,
            child: GestureDetector(
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.grey),
              onTap: () {
                _controller.animateToPage(currentIndex - 1,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 400));
              },
            )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => goLoginPage(),
              child: const Text(
                'Skip',
                style: TextStyle(
                    color: Colors.grey, fontSize: 20, fontFamily: Fonts.muktaBold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) => setState(() {
                currentIndex = index;
                isLastPage = index == 3;
                isFirstPage = index == 0;
              }),
              children: const [
                IntroductionPageView(
                  title: 'Variety Products For Everyone',
                  subTitle:
                  'Full range of fruits according to each region. Choose your favorite fruit now!',
                  image: Assets.assetsVarietyFruits,
                ),
                IntroductionPageView(
                  title: 'Quality Assurance',
                  subTitle:
                  'All fruits are guaranteed absolute quality, no pesticides, no stimulants and no preservatives.',
                  image: Assets.assetsFreshFruits,
                ),
                IntroductionPageView(
                  title: 'Easy Ordering',
                  subTitle:
                      'Now you can order fruits any time right from your mobile.\nSearch and order easily with just a few basic steps.',
                  image: Assets.assetsOrderAnimated,
                ),
                IntroductionPageView(
                  title: 'Quick Delivery',
                  subTitle:
                      'Orders your favorite fruits will be immediately deliver. We are always ready to serve!',
                  image: Assets.assetsShipping,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              alignment: const Alignment(-1, 0.9),
              child: SmoothPageIndicator(
                effect: const JumpingDotEffect(dotWidth: 10, dotHeight: 10, verticalOffset: 10),
                controller: _controller,
                count: 4,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              alignment: const Alignment(1, 0.94),
              child: ElevatedButton(
                  onPressed: () {
                    if (currentIndex == 3) {
                      goLoginPage();
                    } else {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo.shade800,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20.0),
                  ),
                  child: Text(
                    isLastPage ? 'Start' : 'Next',
                    style: const TextStyle(
                        fontSize: 20, fontFamily: Fonts.muktaMedium),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void changeFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
  }

  void goLoginPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MyApp()));
    changeFirstTime();
  }
}
