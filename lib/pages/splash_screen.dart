import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:remainder_app/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => Navigator.pushReplacement(context, PageTransition(child: const HomePage(), type: PageTransitionType.rightToLeft )));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(child: Image.asset("assets/logo.png", height: 150,)),
            const Center(child: SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                color: Color(0xff3475db),
                backgroundColor: Colors.lightBlueAccent,
                strokeWidth: 8,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
