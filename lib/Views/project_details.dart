import 'package:flutter/material.dart';
import '../Models/feature.dart';
import 'add_feature.dart';
import 'feature_details.dart';
import 'settings.dart';

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({Key? key, project, required this.myproject})
      : super(key: key);
  final dynamic myproject;

  @override
  State<StatefulWidget> createState() {
    return MyProjectDetailsScreen(myproject);
  }
}

class MyProjectDetailsScreen extends State<ProjectDetailsScreen> {
  late dynamic data;
  MyProjectDetailsScreen(dynamic myproject) {
    data = myproject;
  }

  Future<List<Feature>> getFeatures() async {
    final Future<List?> serverFeatureList =
        Feature(0, "", "", data['Id']).getFeatures(data['Id']);
    List<Feature> features = [];
    final List? featureList = await serverFeatureList;
    if (featureList != null) {
      for (var f in featureList) {
        Feature pro = Feature((f["Id"]), f["Feature_Description"],
            f["Feature_Name"], (f["Project_Id"]));
        features.add(pro);
      }
      return features;
    } else {
      Feature pro = Feature(0, "No Features", "No Features", data['Id']);
      features.add(pro);
      return features;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data["Project_Name"]),
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
          children: <Widget>[
            ListTile(
              title: const Text("Project Type"),
              subtitle: Text(data["ProjectType"]),
            ),
            ListTile(
              title: const Text("Project Description"),
              subtitle: Text(data["Description"]),
            ),
            ListTile(
                title: const Text("Features:"),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddFeatureScreen(myprojectid: data['Id'])));
                    },
                    icon: const Icon(Icons.plus_one))),
            Expanded(
                child: FutureBuilder(
                    future: getFeatures(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (!snapshot.data[0].featureName
                            .toString()
                            .contains('No Features')) {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, index) => ListTile(
                                  title: Text(snapshot.data[index].featureName
                                      .toString()),
                                  leading: const Icon(Icons.book_online_sharp),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.delete)),
                                      IconButton(
                                          onPressed: () async {
                                            var f = await Feature(0, '', '', 0)
                                                .loadFeature(
                                                    snapshot.data[index].id);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FeatureDetailsScreen(
                                                            feature: f![0])));
                                          },
                                          icon: const Icon(Icons.list)),
                                    ],
                                  )));
                        } else {
                          return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (ctx, index) => ListTile(
                                  title: Text(snapshot.data[index].featureName
                                      .toString()),
                                  leading: const Icon(Icons.book_online_sharp),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddFeatureScreen(
                                                        myprojectid: data[0]
                                                            ['Id'])));
                                      },
                                      icon: const Icon(Icons.plus_one))));
                        }
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
