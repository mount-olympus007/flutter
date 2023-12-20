import 'package:business_features/Models/project.dart';
import 'package:business_features/Views/project_listing.dart';
import 'package:flutter/material.dart';
import '../Models/project_model.dart';
import '../Models/text_field_model.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyAddProjectScreen();
  }
}

class MyAddProjectScreen extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final model = ProjectModel('0', '', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text('Add a Project',
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
                            labelText: "Project Name",
                            hintText: "My Shopify Store"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for your project';
                  }
                  return null;
                }, (value) {
                  model.projectName = value.toString();
                })),
                Expanded(
                    child: MyFormTextField(
                        false,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Project Type",
                            hintText: "Ecommerce"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a project type';
                  }
                  return null;
                }, (value) {
                  model.projectType = value.toString();
                })),
                Expanded(
                    child: MyFormTextField(
                        false,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                            hintText: "Decribe your project"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a short description';
                  }
                  return null;
                }, (value) {
                  model.description = value.toString();
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

                            Project(0, model.projectName, model.projectType,
                                    model.description, "")
                                .insertProject(Project(0, model.projectName,
                                    model.projectType, model.description, ""));

                            ScaffoldMessenger.of(_formKey.currentContext!)
                                .showSnackBar(const SnackBar(
                                    content: Text('Processing Data')));

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProjectListScreen()));
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
