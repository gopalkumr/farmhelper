import 'package:appwrite/enums.dart';
import 'package:farmhelp/screens/main_page.dart';
import 'package:farmhelp/screens/phone_sign_up.dart';
import 'package:farmhelp/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:farmhelp/widgets/horizontal_line.dart';
import 'package:farmhelp/widgets/signup_with_phone.dart';
import 'package:farmhelp/widgets/social_button.dart';
import 'package:appwrite/appwrite.dart';
// Import MainPage

class SignUp extends StatelessWidget {
  final Client client;

  const SignUp({super.key, required this.client});

  // Function to handle Google OAuth Sign-up
  Future<void> signUpWithGoogle(BuildContext context) async {
    try {
      final account = Account(client);

      // Trigger the OAuth2 flow with Appwrite for Google sign-up
      await account.createOAuth2Session(
        provider: OAuthProvider.google,
      );

      // If the user successfully signs up, navigate to the MainPage
      print("Google sign-up successful");

      // Navigate to the MainPage after successful sign-up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage(client: client)),
      );
    } on AppwriteException catch (e) {
      print('Appwrite error during Google sign-up: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign up with Google: ${e.message}')));
    } catch (e) {
      print('Unexpected error during Google sign-up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  "assets/images/signup-vector.svg",
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                SocialButton(
                  name: "Sign Up with Facebook",
                  icon: "assets/icons/facebook.svg",
                  onPressed: () {
                    // Implement Facebook sign-up
                  },
                ),
                SocialButton(
                  name: "Sign Up with Google",
                  icon: "assets/icons/google.svg",
                  onPressed: () => signUpWithGoogle(context),
                ),
                const SizedBox(height: 10),
                HorizontalLine(
                  name: "Or",
                  height: 0.5,
                ),
                const SizedBox(height: 19),
                SignupWithPhone(
                  name: "Sign Up with Phone Number",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneSignUp(client: client),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignIn(client: client), // Pass Client to SignUp
                          ),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
