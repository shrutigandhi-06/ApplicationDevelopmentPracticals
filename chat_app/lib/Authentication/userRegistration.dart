import 'package:chat_app/Authentication/otp_verification.dart';
import 'package:flutter/material.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({Key? key}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController phoneNoController = TextEditingController();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                label: Text('Phone Number'),
              ),
              controller: phoneNoController,
              validator: (value) {
                if (phoneNoController.value.text.isNotEmpty &&
                    phoneNoController.value.text.length == 10) {
                  return null;
                }
                return 'Enter valid Phone Number';
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                print('onPressed: ' + phoneNoController.value.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPVerification(
                      phoneNo: '+91' + phoneNoController.value.text,
                    ),
                  ),
                );
              }
            },
            child: const Text('Get OTP'),
          )
        ],
      ),
    );
  }
}
