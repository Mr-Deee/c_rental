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

  Widget buildVideoWithOverlay(VideoPlayerController controller) {
    return Stack(

      children: [
        controller.value.isInitialized
            ? SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover, // Cover entire available space
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        )
            : CircularProgressIndicator(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.black54],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 15.0, color: Colors.black87); // White text for better contrast
    const pageDecoration = PageDecoration(
      pageColor: Colors.black, // Dark background to blend with the video
      titleTextStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyTextStyle: bodyStyle,
      imageFlex: 4, // Increased imageFlex to make video larger
      bodyPadding: EdgeInsets.fromLTRB(10.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.only(top: 10),
    );

    return IntroductionScreen(
globalBackgroundColor: Colors.black,
      key: introKey,
      pages: [
        PageViewModel(
          title: "",
          body: '.',
          image: buildVideoWithOverlay(_controller1),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          body: "",
          image: buildVideoWithOverlay(_controller2),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "",
          body: "",
          image: buildVideoWithOverlay(_controller3),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Delivered to your doorstep.",
          body: "Conveniently delivered right to you.",
          image: buildVideoWithOverlay(_controller4),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text('Skip', style: TextStyle(color: Colors.white70)),
      next: const Icon(Icons.arrow_forward, color: Colors.white70),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
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
