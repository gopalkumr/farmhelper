import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:farmhelp/screens/sign_in.dart';
import 'package:farmhelp/screens/verification.dart';
import 'package:farmhelp/widgets/phone_number_field.dart';
import 'package:farmhelp/widgets/remember_me.dart';
import 'package:farmhelp/widgets/signup_with_phone.dart';

class PhoneSignUp extends StatelessWidget {
  final Client client;

  const PhoneSignUp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(client: client),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              "assets/images/signup-vector.svg",
              height: MediaQuery.of(context).size.height / 2,
            ),
            Text(
              "Create your Account",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 24.0),
            ),
            const PhoneNumberField(),
            const RememberMe(),
            SignupWithPhone(
              name: "Sign Up",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Verification(client: client)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
