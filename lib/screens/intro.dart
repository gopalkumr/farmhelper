import 'package:farmhelp/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart'; // Import Appwrite to initialize the Client
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv to load the .env file

String projectId = dotenv.env['APPWRITE_PROJECT_ID']!;
String endpoint = dotenv.env['APPWRITE_ENDPOINT']!;

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Client client; // Declare the Client object

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.forward();

    // Initialize the Appwrite client
    client = Client()
      ..setEndpoint(endpoint) // Your Appwrite endpoint
      ..setProject(projectId) // Your Appwrite project ID
      ..setSelfSigned(
          status:
              true); // Use this only for self-signed certificates in development
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the Farmhelp!',
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Get ready to explore the world of farming.',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Pass the Client when navigating to SignIn
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUp(client: client),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Let\'s Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
