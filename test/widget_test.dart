// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:appwrite/appwrite.dart';
import 'package:farmhelp/screens/intro.dart';
import 'package:farmhelp/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String projectId = dotenv.env['APPWRITE_PROJECT_ID']!;
String endpoint = dotenv.env['APPWRITE_ENDPOINT']!;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Client client = Client();
  client
      .setEndpoint(endpoint) // Set the Appwrite endpoint
      .setProject(projectId) // Your project ID
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
