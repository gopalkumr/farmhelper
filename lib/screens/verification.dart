import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:farmhelp/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:farmhelp/helper/colors.dart';
import 'package:farmhelp/screens/phone_login.dart';
import 'package:farmhelp/widgets/signup_with_phone.dart';
import 'package:pinput/pinput.dart';

class Verification extends StatefulWidget {
  final Client client; // client is passed through the widget

  const Verification({super.key, required this.client});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late TextEditingController _verification;
  late Timer timer;
  int secondsRemaining = 30;
  bool enableResend = false;

  @override
  void initState() {
    _verification = TextEditingController();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _verification.dispose();
    timer.cancel();
    super.dispose();
  }

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
                builder: (context) =>
                    PhoneLogin(client: widget.client), // Use widget.client
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Code has been sent to +91 *********1245",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                pinAnimationType: PinAnimationType.slide,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  decoration: BoxDecoration(
                    color: ColorSys.kSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 50,
                  width: 50,
                ),
                onCompleted: (pin) {
                  // VerifyPin logic
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !enableResend ? const Text("Resend code in") : Container(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      !enableResend
                          ? secondsRemaining.toString()
                          : "Resend code",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SignupWithPhone(
                name: "Verify",
                onPressed: () {
                  // Handle verification logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(client: widget.client),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
