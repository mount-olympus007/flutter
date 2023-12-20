import 'package:business_features/services/services.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsScreen();
  }
}

class SettingsScreen extends State<Settings> {
  Future<List?> getUser() async {
    var y = await Services().getUsers();
    return y;
  }

  late Future<List?> z = Services().getUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: FutureBuilder(
          future: z,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Scaffold(
              body: Center(
                  child: Column(
                children: [
                  ListTile(
                    title: const Text("Change Email"),
                    subtitle: snapshot.data["Email"],
                    trailing: const Icon(Icons.arrow_circle_right),
                  ),
                  ListTile(
                    title: const Text("Change Mobile"),
                    subtitle: snapshot.data["Mobile"],
                    trailing: const Icon(Icons.arrow_circle_right),
                  ),
                  const ListTile(
                    title: Text("Reset Password"),
                    trailing: Icon(Icons.arrow_circle_right),
                  )
                ],
              )),
            );
          }),
    );
  }
}
