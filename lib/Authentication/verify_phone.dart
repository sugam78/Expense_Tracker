import 'package:expense_tracker/Provider/loading_provider.dart';
import 'package:expense_tracker/UI/home_screen.dart';
import 'package:expense_tracker/Utilities/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/reusuable_button.dart';

class VerifyPhone extends StatefulWidget {
  String id;
  VerifyPhone({super.key,required this.id});

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  TextEditingController controller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Phone'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter Verification code',
              prefixIcon: Icon(Icons.code),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1),
              ),
            ),
            validator: (value){
              if(value!.isEmpty){
                return 'Enter Code';
              }
              else{
                return null;
              }
            },
          ),
          SizedBox(height: 20,),
          Consumer<LoadingProvider>(builder: (context,value,index){
            return ReusuableButton(
                title: 'Verify',loading: value.loading, onTap: (){
              loadingProvider.Change();
              final credential = PhoneAuthProvider.credential(
                  verificationId: widget.id, smsCode: controller.text);
              try{
                auth.signInWithCredential(credential).then((value) async{
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setBool('login', true);
                  loadingProvider.Change();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                }).onError((error, stackTrace) {
                  loadingProvider.Change();
                  Utilities().toastMesssage(error.toString());
                });
              }
              catch(e){
                loadingProvider.Change();
                Utilities().toastMesssage(e.toString());
              }
            }
            );
          }),
        ],
      ),
    );
  }
}
