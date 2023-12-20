import 'package:business_features/Models/feature.dart';
import 'package:business_features/Models/service_ticket.dart';
import 'package:business_features/Views/feature_details.dart';
import 'package:flutter/material.dart';
import '../Models/service_ticket_model.dart';
import '../Models/text_field_model.dart';
import 'add_feature.dart';
import 'settings.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key, required this.task}) : super(key: key);
  final dynamic task;

  @override
  State<StatefulWidget> createState() {
    return MyTaskDetailsScreen(task);
  }
}

class MyTaskDetailsScreen extends State<TaskDetailsScreen> {
  late dynamic data;
  final _formKey = GlobalKey<FormState>();
  final model = ServiceTicketModel('');
  late Widget serviceModel;

  MyTaskDetailsScreen(dynamic task) {
    data = task;
  }

  @override
  Widget build(BuildContext context) {
    if (data.openIssue) {
      serviceModel = const ListTile(
        title: Text("Pending Service Ticket..."),
        tileColor: Colors.red,
      );
    } else {
      serviceModel = Expanded(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
                child: MyFormTextField(
                    false,
                    const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Service Issue",
                        hintText: "Describe the service needed"), (value) {
              if (value!.isEmpty) {
                return 'Please enter a message';
              }
              return null;
            }, (value) {
              model.message = value.toString();
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
                  child: SubmitButton(
                    () async {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Map<String, dynamic> jsonMap = {
                        //   'Data': {
                        //     'USER_NAME': model.email,
                        //     'PASSWORD': model.password
                        //   }
                        // };
                        // the model object at this point can be POSTed
                        // to an API or persisted for further use
                        // final response = await http.post(
                        //     Uri.parse('http://10.0.2.2/flexapp/api/login'),
                        //    body: convert.jsonEncode(jsonMap),
                        //    headers: {"Content-type": "application/json"});

                        // final response = await http.get(Uri.parse(
                        //     "http://10.0.2.2/businessfeaturesbackend/api/login?USER_NAME=" +
                        //         model.email +
                        //         "&PASSWORD=" +
                        //         model.password));

                        ScaffoldMessenger.of(_formKey.currentContext!)
                            .showSnackBar(const SnackBar(
                                content: Text('Processing Data')));
                        // var responseData =
                        //     convert.json.decode(response.body);
                        ServiceTicket(0, data.Id, "", model.message, "", true)
                            .insertTicket(ServiceTicket(
                                0, data.Id, "", model.message, "", true));
                        List<dynamic>? f = await Feature(0, "", "", 0)
                            .loadFeature(data.Feature_Id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FeatureDetailsScreen(feature: f![0])));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(data.taskName),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('My Account Settings')));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Settings()));
              })
        ],
      ),
      body: Center(
          child: Column(
        children: [
          ListTile(
            title: const Text("Task Name"),
            subtitle: Text(data.taskName),
          ),
          ListTile(
            title: const Text("Task Description"),
            subtitle: Text(data.taskDescription),
          ),
          ListTile(
            title: const Text("Assigned to:"),
            subtitle: Text(data.assignedEmployeeId),
          ),
          ListTile(
            title: const Text("Estimated Time: "),
            subtitle: Text(data.estimatedTime),
          ),
          const Text("Submit a service ticket:"),
          serviceModel
        ],
      )),
    );
  }
}
