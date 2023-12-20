import 'package:business_features/services/services.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../Models/text_field_model.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';
import 'project_listing.dart';
import 'reset_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyLogScreen();
  }
}

class MyLogScreen extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final model = LoginModel('', '');
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('images/marvel.jpg'),
          const Text('Access Your Account',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: MyFormTextField(
                        false,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Email Address",
                            hintText: "me@abc.com"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!_emailRegExp.hasMatch(value)) {
                    return 'Invalid email address!';
                  }
                  return null;
                }, (value) {
                  model.email = value.toString();
                })),
                Expanded(
                    child: MyFormTextField(
                        true,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Password",
                            hintText: "my password"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                }, (value) {
                  model.password = value.toString();
                })),
                Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(''),
                    ),
                    const Expanded(
                      child: Text(''),
                    ),
                    Expanded(
                      child: LogInButton(
                        () async {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final response = await http.get(Uri.parse(
                                "http://10.0.2.2/businessbackend/api/login?USER_NAME=" +
                                    model.email +
                                    "&PASSWORD=" +
                                    model.password));

                            ScaffoldMessenger.of(_formKey.currentContext!)
                                .showSnackBar(const SnackBar(
                                    content: Text('Processing Data')));
                            var responseData =
                                convert.json.decode(response.body);

                            if (responseData[0]["user_id"] ==
                                "Invalid Login Attempt") {
                              ScaffoldMessenger.of(_formKey.currentContext!)
                                  .showSnackBar(const SnackBar(
                                      content: Text('Invalid Login Attempt')));
                            } else {
                              // Add lines from here...
                              User u = User(
                                  responseData[0]["Id"],
                                  responseData[0]["Email"],
                                  responseData[0]["Password"],
                                  0);
                              await Services().insertUser(u);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProjectListScreen()));
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(child: Text('')),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Forgot Password'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPasswordScreen()));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(width: 8)
        ],
      )),
    );
  }
}

class LogInButton extends StatelessWidget {
  final Function() onPressed;
  const LogInButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
            child: ElevatedButton(
              onPressed: onPressed,
              child: const Text('Sign In'),
            ),
            width: double.maxFinite));
  }
}
