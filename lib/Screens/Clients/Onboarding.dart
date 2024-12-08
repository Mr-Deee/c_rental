import 'package:flutter/material.dart';
import 'package:c_rental/Screens/SignUpScreen.dart';

class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Welcome to Benji's  Rental",
      "body": "Your trusted partner for all your car rental needs. Experience quality service and convenience like never before",
      "image": "assets/images/esc.png",
    },
    {
      "title": "Wide Range of Cars",
      "body": "Choose from a variety of vehicles to suit your needs, whether it's for business, travel, or leisure",
      "image": "assets/images/all.png",
    },
    {
      "title": "Luxury Fleets",
      "body": "Enjoy the best deals at the best rates with our premium selection of luxury vehicles.",
      "image": "assets/images/luxury.png",
    },
    {
      "title": "Smooth Payment",
      "body": "Conveniently pay rental fees through our secure in-app payment system."
          "for short-term or long-term rentals.",
      "image": "assets/images/Payment.png",
    },
  ];

  void _onSkip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void _onNext() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onSkip();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0047AB), Color(0xFF2D97FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return _buildPage(
                    title: data["title"]!,
                    body: data["body"]!,
                    image: data["image"]!,
                    isLastPage: index == _onboardingData.length - 1,
                  );
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String body,
    required String image,
    required bool isLastPage,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          height: MediaQuery.of(context).size.height * 0.4,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 30),
        Text(
          title,
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            body,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (isLastPage)
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              onPressed: _onSkip,
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF0047AB), backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 30.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _onSkip,
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Row(
            children: List.generate(
              _onboardingData.length,
                  (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: _currentPage == index ? 12.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: _onNext,
            child: Text(
              _currentPage == _onboardingData.length - 1 ? "Done" : "Next",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
