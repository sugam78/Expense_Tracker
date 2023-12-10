import 'package:expense_tracker/Authentication/forgot_password.dart';

import 'package:expense_tracker/Authentication/phone_login.dart';
import 'package:expense_tracker/Authentication/signup_screen.dart';
import 'package:expense_tracker/UI/home_screen.dart';
import 'package:expense_tracker/Widgets/reusuable_button.dart';
import 'package:expense_tracker/Provider/loading_provider.dart';
import 'package:expense_tracker/Utilities/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth auth  = FirebaseAuth.instance;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: pass,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Consumer<LoadingProvider>(builder: (context,value,index){
                return ReusuableButton(
                    title: 'Login',loading: value.loading, onTap: (){
                  loadingProvider.Change();
                  auth.signInWithEmailAndPassword(
                      email: email.text.toString(), password: pass.text.toString()
                  ).then((value) async{
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    sp.setBool('login', true);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                    loadingProvider.Change();
                  }).onError((error, stackTrace) {
                    loadingProvider.Change();
                    Utilities().toastMesssage(error.toString());
                  });
                }
                );
              }),
              SizedBox(height: 30,),
              ReusuableButton(
                  title: 'Login with Phone number',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneLogin()));
                  }
              ),
              SizedBox(height: 30,),
              Text('or login with'),
              SizedBox(height: 30,),
              InkWell(
                onTap: ()async{






                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.google),
                      SizedBox(width: 30,),
                      Text('Login with google'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Dont have an account?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                      child: Text('Sign Up')
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                    },
                    child: Text('Forgot password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
