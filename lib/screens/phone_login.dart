import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:farmhelp/screens/sign_in.dart';
import 'package:farmhelp/screens/verification.dart';
import 'package:farmhelp/widgets/phone_number_field.dart';
import 'package:farmhelp/widgets/remember_me.dart';
import 'package:farmhelp/widgets/signup_with_phone.dart';
import 'package:appwrite/appwrite.dart'; // Import Appwrite to initialize the Client

class PhoneLogin extends StatelessWidget {
  final Client client; // Add Client as a required parameter

  const PhoneLogin({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            // Pass the Client when navigating back to SignIn
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
              "Login to your Account",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 24.0),
            ),
            const PhoneNumberField(),
            const RememberMe(),
            SignupWithPhone(
              name: "Sign in",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Verification(client: client),
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    // Handle sign-up button logic here
                  },
                  child: Text(
                    "Sign up",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).primaryColor),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
