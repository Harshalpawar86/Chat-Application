import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/View/login_screen.dart';
import 'package:chat_app/View/select_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void loadDuration(BuildContext context) async {
    bool isLogin = await AuthController.checkLogin();

    log("isLogin : $isLogin");
    Future.delayed(const Duration(seconds: 4)).then((future) async {
      if (context.mounted) {
        if (isLogin) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SelectPageScreen()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    loadDuration(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              "assets/animations/splash_screen.json",
              height: height / 2,
              width: width,
            ),
            AnimatedTextKit(
              animatedTexts: <AnimatedText>[
                TyperAnimatedText("Chat Application",
                    textAlign: TextAlign.center,
                    textStyle: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.deepPurple),
                    speed: const Duration(milliseconds: 100))
              ],
              isRepeatingAnimation: false,
              repeatForever: false,
            )
          ],
        ));
  }
}
