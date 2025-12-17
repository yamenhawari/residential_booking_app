import 'package:flutter/material.dart';
import 'package:residential_booking_app/features/auth/presentation/screens/login_register_screen.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Text('Introduction Screen'),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginRegisterScreen())),
            child: Text("Go to Login/Register Page"),
          )
        ],
      ),
    );
  }
}
