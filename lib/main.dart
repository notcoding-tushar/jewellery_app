import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/nav_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for either Web or Mobile platforms
  try {
    if (GetPlatform.isWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCdvS6AaXn-J3aOsQHTp5EB7_E8iFKgVBI",
            authDomain: "jwellery-app-b62fb.firebaseapp.com",
            projectId: "jwellery-app-b62fb",
            storageBucket: "jwellery-app-b62fb.firebasestorage.app",
            messagingSenderId: "981741721937",
            appId: "1:981741721937:web:064ece927f1f0404691b70"
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(const JewelleryApp());
}

class JewelleryApp extends StatelessWidget {
  const JewelleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jewellery Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const NavScreen(), // Main navigation entry point
    );
  }
}
