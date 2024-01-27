import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/default_color/default_color.dart';
import 'package:whatsapp_web_clone/provider/chat_provider.dart';
import 'package:whatsapp_web_clone/routes_web_pages.dart';

String firstRoute="/";

Future <void> main()async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAHzVKo65Wgm44zUT0KjC-GLhzKLzDrx10",
        authDomain: "whatsapp-b9990.firebaseapp.com",
        projectId: "whatsapp-b9990",
        storageBucket: "whatsapp-b9990.appspot.com",
        messagingSenderId: "364199676618",
        appId: "1:364199676618:web:bd192a7b03852b4a904233",
        measurementId: "G-E8JVFBPGM3"
    )
  );

  User? currentFirebaseUser=FirebaseAuth.instance.currentUser;

  if(currentFirebaseUser !=null){
    firstRoute="/home";
  }

  runApp(ChangeNotifierProvider(
      create: (context)=>ProviderChat(),
      child: const MyApp(),
    ),
  );
}

final ThemeData defaultThemeOfWebApp=ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: DefaultColor.primaryColor)
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web App Clone',
      theme: defaultThemeOfWebApp,
      debugShowCheckedModeBanner: false,
      initialRoute: firstRoute,
      onGenerateRoute: RoutesForWebPages.createRoutes,
    );
  }
}
