import 'dart:async';

import 'package:expense_tracker/Authentication/login_screen.dart';
import 'package:expense_tracker/Database/db_helper.dart';
import 'package:expense_tracker/UI/chart_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController bcontroller = TextEditingController();
  TextEditingController money = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController moneyy = TextEditingController();
  TextEditingController namee = TextEditingController();
  String budget = '0';
  int total = 0;
  @override
  void initState() {
    // TODO: implement initState
    loadBudget();
    super.initState();
  }

  Future<void> loadBudget() async {
    var result = await DatabaseHelper.instance.query(1);
    setState(() {
      budget = result[0]['money'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Expense Tracker'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setBool('login', false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Budget: '),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(budget),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: DatabaseHelper.instance.queryAll(),
                        builder: (context, snapshot) {
                          List<Map<String, dynamic>> data = snapshot.data ?? [];
                          int cash = 0;
                          for (int i = 1; i < data.length; i++) {
                            cash =
                                cash + int.parse(data[i]['money'].toString());
                          }
                          total = cash;
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    itemCount: (data.length - 1) < 0
                                        ? 0
                                        : data.length - 1,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        data[index + 1]['name']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border:
                                                        Border.all(width: 1),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      data[index + 1]['money']
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    editExpenditure(
                                                        index,
                                                        int.parse(
                                                            data[index + 1]
                                                                    ['money']
                                                                .toString()),
                                                        data[index + 1]['name']
                                                            .toString());
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 1),
                                                ),
                                                child: IconButton(
                                                  onPressed: () async {
                                                    await DatabaseHelper
                                                        .instance
                                                        .delete(int.parse(
                                                            data[index + 1]
                                                                ['id']));
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Total',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                      ),
                                      child: Center(
                                        child: Text(
                                          cash.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ChartScreen()));
                                  },
                                  child: const Text('Show chart'),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await postBudget();
                        },
                        child: const Text('Add or Edit Budget'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await postExpenditure();
                        },
                        child: const Text('Add Expenditure'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postBudget() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          title: const Text('Add or Edit Budget'),
          content: TextFormField(
            controller: bcontroller,
            keyboardType:
                TextInputType.number, // Set the keyboard type to number
            decoration: InputDecoration(
              hintText: 'Add or Edit',
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1),
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
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (int.parse(budget) == 0) {
                      await DatabaseHelper.instance.insert({
                        DatabaseHelper.expenseName: 'Budget',
                        DatabaseHelper.expenseMoney:
                            int.parse(bcontroller.text),
                      });
                    } else {
                      DatabaseHelper.instance.update({
                        DatabaseHelper.Colid: 1,
                        DatabaseHelper.expenseMoney:
                            int.parse(bcontroller.text),
                      });
                    }

                    Navigator.pop(context);
                    await loadBudget();
                    setState(() {});
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> postExpenditure() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Expenditure'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter Expense Name',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: money,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount spent',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
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
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.insert({
                      DatabaseHelper.expenseName: name.text,
                      DatabaseHelper.expenseMoney: int.parse(money.text),
                    });

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> editExpenditure(int i, int expMoney, String expName) async {
    moneyy.text = expMoney.toString();
    namee.text = expName;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: Container(
            height: 150,
            child: Column(
              children: [
                TextFormField(
                  controller: namee,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: expName,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                TextFormField(
                  controller: moneyy,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: expMoney.toString(),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
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
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await DatabaseHelper.instance.update({
                      DatabaseHelper.Colid: i + 2,
                      DatabaseHelper.expenseName: namee.text,
                      DatabaseHelper.expenseMoney: int.parse(moneyy.text),
                    });

                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Edit'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
