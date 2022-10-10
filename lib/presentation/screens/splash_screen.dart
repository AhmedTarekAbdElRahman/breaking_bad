import 'dart:async';
import 'package:flutter/material.dart';

import '../../constants/app_router.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;

  _startDelay(){
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext(){
    Navigator.pushReplacementNamed(context,Routes.charactersRoute);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image(image:AssetImage('assets/images/splash.gif'),fit: BoxFit.cover,)),
    );
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
