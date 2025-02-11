import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroductionPageView extends StatelessWidget {
  final String image, title, subTitle;

  const IntroductionPageView({Key? key, required this.image, required this.title, required this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Mukta-Bold',
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
                height: 1.2
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, right: 20, bottom: 50),
            alignment: Alignment.topLeft,
            child: Text(
              subTitle,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Mukta-Regular',
              ),
            ),
          ),
          Lottie.asset(
            image,
          )
        ],
      ),
    );
  }
}
