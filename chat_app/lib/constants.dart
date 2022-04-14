import 'package:firebase_auth/firebase_auth.dart';

class Constants {
  static String? myNumber =
      FirebaseAuth.instance.currentUser?.phoneNumber.toString();
}
