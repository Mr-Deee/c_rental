import 'package:c_rental/Screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:video_player/video_player.dart';

class OnBoardingPage extends StatefulWidget {
  static const String idScreen = "Onboard";

  OnBoardingPage({Key? key}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  late VideoPlayerController _controller3;
  late VideoPlayerController _controller4;

  @override
  void initState() {
    super.initState();
    _controller1 = VideoPlayerController.asset('assets/videos/onboarding1.mp4')
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();

    _controller2 = VideoPlayerController.asset('assets/videos/onboarding2.mp4')
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();

    _controller3 = VideoPlayerController.asset('assets/videos/onboarding3.mp4')
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();

    _controller4 = VideoPlayerController.asset('assets/videos/onboarding4.mp4')
      ..initialize().then((_) => setState(() {}))
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    super.dispose();
  }

  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SignUpScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 15.0);
    const pageDecoration = PageDecoration(
      pageColor: Colors.white,
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      imageFlex: 4, // Increased imageFlex to make video larger
      bodyPadding: EdgeInsets.fromLTRB(10.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.only(top: 10),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Choose your cylinder size",
          body: 'Pick a maximum of two cylinders.',
          image: _controller1.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover, // Cover entire available space
              child: SizedBox(
                width: _controller1.value.size.width,
                height: _controller1.value.size.height,
                child: VideoPlayer(_controller1),
              ),
            ),
          )
              : CircularProgressIndicator(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Select LPG Station",
          body: "Select from our database your nearest \nLPG station.",
          image: _controller2.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller2.value.size.width,
                height: _controller2.value.size.height,
                child: VideoPlayer(_controller2),
              ),
            ),
          )
              : CircularProgressIndicator(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Secure in-app payments",
          body: "Pay via mobile money or credit card after\ndelivery guy arrives.",
          image: _controller3.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller3.value.size.width,
                height: _controller3.value.size.height,
                child: VideoPlayer(_controller3),
              ),
            ),
          )
              : CircularProgressIndicator(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Delivered to your doorstep.",
          body: "Conveniently delivered right to you.",
          image: _controller4.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller4.value.size.width,
                height: _controller4.value.size.height,
                child: VideoPlayer(_controller4),
              ),
            ),
          )
              : CircularProgressIndicator(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
