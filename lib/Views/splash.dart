import 'dart:async';
import 'package:business_features/Views/account_summary.dart';
import 'package:flutter/material.dart';
import '../services/services.dart';
import 'login.dart';
import 'project_listing.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const duration = Duration(seconds: 3);
  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Features',
      home: Scaffold(
        body: Center(
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.white,
              ),
              Image.asset('images/marvel.jpg'),
              const Text('Business Features',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> authenticate() async {
    final auth = await Services().getServerUserId();

    //auth user
    if (auth == 'noUser') {
      Timer(
          duration,
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      Timer(
          duration,
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AccountMetrics())));
    }
  }
}
