import 'dart:async';
import 'dart:convert';

import 'package:expense_tracker/Authentication/login_screen.dart';
import 'package:expense_tracker/Database/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController bcontroller = TextEditingController();
  String budget = '0';
  @override
  void initState() {
    // TODO: implement initState
     loadBudget();
    super.initState();
  }
  Future<void> loadBudget()async {
    var result =  await DatabaseHelper.instance.query(1);
    setState(() {
      budget = result[0]['money'].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    debugPrint(budget);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Expense Tracker'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: ()async{
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool('login', false);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },
              icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text('Budget: '),

               Expanded(
                 child: SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Text (
                       budget
                   ),
                 ),
               ),

            ],
          ),
          TextButton(onPressed: ()async{
            List<Map<String,dynamic>> queryRows = await DatabaseHelper.instance.queryAll();
            debugPrint(queryRows.toString());

          },
            child: const Text('Query'),

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: ()async{
                    postBudget('Add or edit');
                  },
                  child: Text('Add Budget'),
              ),
              TextButton(
                  onPressed: (){

                  },
                  child: Text('Add Expenditure'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> postBudget(String title) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add or Edit Budget'),
          content: TextFormField(
            controller: bcontroller,
            keyboardType: TextInputType.number, // Set the keyboard type to number
            decoration: InputDecoration(
              hintText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                        int i = await DatabaseHelper.instance.insert({
                          DatabaseHelper.expenseName: title,
                          DatabaseHelper.expenseMoney: int.parse(bcontroller.text),
                        });

                      Navigator.pop(context);
                      await loadBudget();
                      setState(() {

                      });
                  },
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}


