import 'package:flutter/material.dart';
import 'package:smartwin/components/button_animated.dart';
import 'package:smartwin/screens/welcome_screen/contant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({
    super.key,
  });
  var pageController =
      PageController(initialPage: 0, viewportFraction: 1, keepPage: false);
  var currentIndex = 0;
  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                pageController.animateToPage(2,
                    duration: const Duration(seconds: 2),
                    curve: Curves.fastOutSlowIn);
              },
              child: const Text(
                "تخطي",
                style: TextStyle(color: Colors.amber, fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: contents.length,
              controller: pageController,
              onPageChanged: (value) {
                currentIndex = value;
              },
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${contents[i].title}",
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      Center(
                          child:
                              Image(image: AssetImage("${contents[i].image}")))
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SmoothPageIndicator(
              textDirection: TextDirection.rtl,
              controller: pageController,
              count: contents.length,
              onDotClicked: (i) {
                pageController.animateToPage(i,
                    duration: const Duration(
                      seconds: 1,
                    ),
                    curve: Curves.fastOutSlowIn);
              },
              effect: const ExpandingDotsEffect(
                dotColor: Colors.amber,
                activeDotColor: Colors.green,
              ),
            ),
          ),
          AnimatedButton(
              margin: const EdgeInsets.all(12),
              scaleAnimation: true,
              translateAnimation: true,
              overlayColor: Colors.green,
              onTap: () {
                pageController.animateToPage(currentIndex + 1,
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn);
              },
              child: const Center(
                child: Text(
                  'التالي',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
