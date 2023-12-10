import 'package:expense_tracker/Authentication/login_screen.dart';
import 'package:expense_tracker/Provider/loading_provider.dart';
import 'package:expense_tracker/Utilities/toast_message.dart';
import 'package:expense_tracker/Widgets/reusuable_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
          title: Text('Sign Up'),
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
                    title: 'Sign Up',loading: value.loading, onTap: (){
                  loadingProvider.Change();
                  auth.createUserWithEmailAndPassword(
                      email: email.text.toString(), password: pass.text.toString()
                  ).then((value) {
                    loadingProvider.Change();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  }).onError((error, stackTrace) {
                    loadingProvider.Change();
                    Utilities().toastMesssage(error.toString());
                  });
                }
                );
              }),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?'),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                  },
                      child: Text('Login')
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
