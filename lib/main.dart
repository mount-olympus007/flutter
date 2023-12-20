import 'package:business_features/Views/splash.dart';
import 'package:flutter/material.dart';
import 'Views/login.dart';
import 'Views/project_listing.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final materialApp = MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
        // '/register': (context) => const RegisterScreen(),
        // '/settings': (context) => const SettingsScreen(),
        // '/resetPassword': (context) => const ResetPasswordScreen(),
        // '/metrics': (context) => const MetricsScreen(),
        // '/contact': (context) => const ContactScreen(),
        // '/about': (context) => const AboutScreen(),
        '/dashboard': (context) => const ProjectListScreen(),
        // '/features': (context) => const FeatureListScreen(),
        // '/requirements': (context) => const DataRequirementScreen(),
        // '/tasks': (context) => const TasksScreen(),
        // '/inqueries': (context) => const InqueryScreen(),
      },
      title: 'Invest In People',
      home: const SplashPage(),
      debugShowCheckedModeBanner: false);
  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
