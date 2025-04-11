import 'package:ecosnap/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Firebase app
  if(kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(
      apiKey: "AIzaSyC_8M0WfqRxgtnxohrGEOPCEZsPJHc-6jo",
      authDomain: "ecosnapdb.firebaseapp.com",
      databaseURL: "https://ecosnapdb-default-rtdb.firebaseio.com",
      projectId: "ecosnapdb",
      storageBucket: "ecosnapdb.firebasestorage.app",
      messagingSenderId: "707813208000",
      appId: "1:707813208000:web:f165586c8c80e4dcd16225",
      measurementId: "G-7WT8V7XT0G"
    ));
  } else{
    await Firebase.initializeApp();
  }
  
  //await FirebaseAuth.instance.signInAnonymously();
  
  
  // Activate App Check using the Debug Provider.
  // No attestation is done—this is for development use only.
  await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoSnap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Set the home screen as the first screen
    );
  }
}
