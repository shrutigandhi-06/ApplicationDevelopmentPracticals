import 'package:chat_app/Chat/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerification extends StatefulWidget {
  final String phoneNo;

  const OTPVerification({Key? key, required this.phoneNo}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  late String _verificationCode;
  late String otp;

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (value) {
              otp = value;
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: otp))
                  .then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.phoneNo)
                    .set({
                  'phone_no': widget.phoneNo,
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ChatRoom()),
                    (route) => false);
              });
            },
            child: const Text('Verify'),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNo,
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("2");
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ChatRoom()),
                (route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (verificationID, resendToken) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        setState(() {
          _verificationCode = verificationID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }
}
