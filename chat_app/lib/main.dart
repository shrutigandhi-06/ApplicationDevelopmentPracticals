import 'package:chat_app/Authentication/userRegistration.dart';
import 'package:chat_app/Chat/ChatRoom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FirebaseAuth.instance.currentUser?.uid == null
          ? const UserRegistration()
          : ChatRoom(),
      debugShowCheckedModeBanner: false,
    );
  }
}
