import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContactScreen();
  }
}

class ContactScreen extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Us")),
      body: Center(
          child: Column(
        children: const [
          ListTile(
              title: Text("Email Us:"),
              subtitle: Text("IncubateIQ@intranetiq.com")),
          ListTile(title: Text("Call Us:"), subtitle: Text("123-456-7890")),
        ],
      )),
    );
  }
}
