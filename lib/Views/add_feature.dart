import 'package:business_features/Models/feature.dart';
import 'package:business_features/Models/project.dart';
import 'package:business_features/Views/project_details.dart';
import 'package:flutter/material.dart';
import '../Models/feature_model.dart';
import '../Models/text_field_model.dart';

class AddFeatureScreen extends StatefulWidget {
  const AddFeatureScreen({Key? key, required this.myprojectid})
      : super(key: key);
  final int myprojectid;
  @override
  State<StatefulWidget> createState() {
    return MyAddFeatureScreen(myprojectid);
  }
}

class MyAddFeatureScreen extends State<AddFeatureScreen> {
  final _formKey = GlobalKey<FormState>();
  final model = FeatureModel(0, '', '', 0);
  late int projectid;
  MyAddFeatureScreen(int myprojectid) {
    projectid = myprojectid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          const Text('Add a Feature',
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
                            labelText: "Feature Name",
                            hintText: "Chat room"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name for your feature';
                  }
                  return null;
                }, (value) {
                  model.featureName = value.toString();
                })),
                Expanded(
                    child: MyFormTextField(
                        false,
                        const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Description",
                            hintText: "Data store requirements"), (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                }, (value) {
                  model.featureDescription = value.toString();
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

                            Feature(0, model.featureDescription,
                                    model.featureName, projectid)
                                .insertFeature(Feature(
                                    0,
                                    model.featureDescription,
                                    model.featureName,
                                    projectid));

                            ScaffoldMessenger.of(_formKey.currentContext!)
                                .showSnackBar(const SnackBar(
                                    content: Text('Processing Data')));
                            List<dynamic>? p = await Project(
                              0,
                              '',
                              '',
                              '',
                              '',
                            ).loadProject(projectid);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProjectDetailsScreen(
                                        myproject: p![0])));
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
