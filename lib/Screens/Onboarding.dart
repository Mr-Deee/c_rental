import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:c_rental/Screens/SignUpScreen.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key? key}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignUpScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Widget buildImage(String assetPath, double height) {
    return Center(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover,
        height: height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0047AB), Color(0xFF2D97FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: IntroductionScreen(
        globalBackgroundColor: Colors.transparent,
        key: introKey,
        pages: [
          PageViewModel(
            title: "Welcome to Car Rental",
            body: "Easily find and rent cars near you.",
            image: buildImage('assets/images/esc.png', 300.0),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                  fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
              bodyTextStyle: TextStyle(fontSize: 18.0, color: Colors.white70),
              imageFlex: 3,
            ),
          ),
          PageViewModel(
            title: "Wide Range of Cars",
            body: "Choose from a variety of vehicles to suit your needs.",
            image: buildImage('assets/images/onboarding2.png', 250.0),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                  fontSize: 26.0, fontWeight: FontWeight.w600, color: Colors.amber),
              bodyTextStyle: TextStyle(fontSize: 16.0, color: Colors.white70),
              imageFlex: 4,
            ),
          ),
          PageViewModel(
            title: "Affordable Prices",
            body: "Enjoy the best deals at the best rates.",
            image: buildImage('assets/images/onboarding3.png', 220.0),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              bodyTextStyle: TextStyle(fontSize: 15.0, color: Colors.white70),
              imageFlex: 5,
            ),
          ),
          PageViewModel(
            title: "Delivered to Your Doorstep",
            body: "Conveniently delivered right to you.",
            image: buildImage('assets/images/onboarding4.png', 280.0),
            decoration: PageDecoration(
              titleTextStyle: TextStyle(
                  fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.redAccent),
              bodyTextStyle: TextStyle(fontSize: 20.0, color: Colors.white),
              imageFlex: 2,
            ),
          ),
        ],
        onDone: () => _onIntroEnd(context),
        showSkipButton: true,
        skip: const Text('Skip', style: TextStyle(color: Colors.white70)),
        next: const Icon(Icons.arrow_forward, color: Colors.white70),
        done: const Text('Done',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
