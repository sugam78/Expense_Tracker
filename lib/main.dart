
import 'package:expense_tracker/Provider/loading_provider.dart';
import 'package:expense_tracker/UI/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyBfrPv9SplHLVU5R1n96aA0HEqGbtNAIm0',
        appId: ':75078929925:android:d0e592cd99e28d2c82966c',
        messagingSenderId: '75078929925',
        projectId: 'expense-tracker-1a695'
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_)=>LoadingProvider())
        ],
      child: const MaterialApp(
        title: 'Expense Tracker',
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

