import 'package:appwrite/appwrite.dart';
import 'package:farmhelp/screens/intro.dart';
import 'package:flutter/material.dart';
import 'package:farmhelp/theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env"); // Load the .env file
  // Load the .env file

  // Get the project ID and endpoint from the .env file
  String projectId = dotenv.env['APPWRITE_PROJECT_ID']!;
  String endpoint = dotenv.env['APPWRITE_ENDPOINT']!;

  // Initialize Appwrite Client
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint(endpoint) // Set the Appwrite endpoint
      .setProject(projectId) // Set the project ID
      .setSelfSigned(
          status:
              true); // For self-signed certificates, use only during development

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const IntroPage(), // You can set any page as the initial page here
      // home: MainPage(client: client),
    ),
  );
}
