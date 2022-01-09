import 'dart:io';

import 'package:baoiam/login_page.dart';
import 'package:baoiam/onboarding_page.dart';
import 'package:flutter/material.dart';

import 'modals/onboarding_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<OnboardingModel> onboardingPages;
  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  GestureDetector pageIndexIndicator(int page, bool isCurrPage) {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(page,
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        height: isCurrPage ? 10 : 6,
        width: isCurrPage ? 10 : 6,
        decoration: BoxDecoration(
          color: isCurrPage ? Colors.grey : Colors.grey[300],
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    onboardingPages = getOnboardingPages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PageView.builder(
          itemCount: onboardingPages.length,
          controller: pageController,
          onPageChanged: (val) {
            setState(() {
              pageIndex = val;
            });
          },
          itemBuilder: (context, index) => OnboardingPage(
            image: onboardingPages[index].image,
            desc: onboardingPages[index].desc,
          ),
        ),
      ),
      bottomSheet: pageIndex != onboardingPages.length - 1
          ? Container(
              height: Platform.isIOS ? 70 : 60,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: GestureDetector(
                      onTap: () {
                        pageController.animateToPage(onboardingPages.length - 1,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeInOut);
                      },
                      child: Text(
                        'SKIP',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < onboardingPages.length; i++)
                        pageIndexIndicator(i, pageIndex == i),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(pageIndex + 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      "NEXT",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Container(
                height: Platform.isIOS ? 70 : 60,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Center(
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
