import 'package:business_features/Models/feature.dart';
import 'package:business_features/Models/task.dart';
import 'package:flutter/material.dart';
import '../Models/task_model.dart';
import '../Models/text_field_model.dart';
import 'feature_details.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key, required this.myfeatureid}) : super(key: key);
  final int myfeatureid;
  @override
  State<StatefulWidget> createState() {
    return MyAddTaskScreen(myfeatureid);
  }
}

class MyAddTaskScreen extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final model = TaskModel(0, '', '', 0);
  late int featureid;
  MyAddTaskScreen(int myfeatureid) {
    featureid = myfeatureid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text('Add a Task',
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
                            labelText: "Task Name",
                            hintText: "Create Database"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for your task';
                  }
                  return null;
                }, (value) {
                  model.taskName = value.toString();
                })),
                Expanded(
                    child: MyFormTextField(
                        false,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                            hintText: "Create Tables for business logic"),
                        (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                }, (value) {
                  model.taskDescription = value.toString();
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

                            Task(0, model.taskName, model.taskDescription,
                                    featureid, "", "", false)
                                .insertTask(Task(
                                    0,
                                    model.taskName,
                                    model.taskDescription,
                                    featureid,
                                    "",
                                    "",
                                    false));

                            ScaffoldMessenger.of(_formKey.currentContext!)
                                .showSnackBar(const SnackBar(
                                    content: Text('Processing Data')));
                            List<dynamic>? f = await Feature(
                              0,
                              '',
                              '',
                              0,
                            ).loadFeature(featureid);
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
          ))
        ],
      )),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final Function() onPressed;
  const SubmitButton(this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
            child: ElevatedButton(
              onPressed: onPressed,
              child: const Text('Save'),
            ),
            width: double.maxFinite));
  }
}
