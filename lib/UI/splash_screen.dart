import 'dart:async';

import 'package:expense_tracker/Authentication/login_screen.dart';
import 'package:expense_tracker/UI/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4), () {
      isLogin();
    });
  }
  void isLogin()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isLogin = sp.getBool('login')?? false;
    if(isLogin){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image(
        image: AssetImage('image/splash.jpg'),
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}

