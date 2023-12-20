import 'package:business_features/Models/project.dart';
import 'package:business_features/Views/account_summary.dart';
import 'package:business_features/Views/project_details.dart';
import 'package:flutter/material.dart';
import 'add_project.dart';
import 'contact.dart';
import 'settings.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyProjectListScreen();
  }
}

class MyProjectListScreen extends State<ProjectListScreen>
    with TickerProviderStateMixin {
  void _delete(BuildContext context, int id) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to delete the project?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      //remove from database
                      Project(0, "", "", "", "").removeProject(id);
                      //then updatelist
                      getProjects();
                    });

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Future<List<Project>> getProjects() async {
    final Future<List?> serverProjectList =
        Project(0, "", "", "", "").getProjects();
    List<Project> projects = [];
    final List? projectList = await serverProjectList;
    if (projectList != null) {
      for (var p in projectList) {
        Project pro = Project((p["Id"]), p["Project_Name"], p["ProjectType"],
            p["Description"], p["CreatorID"]);
        projects.add(pro);
      }
      return projects;
    } else {
      Project pro = Project(
          0, "No Projects", "No Projects", "No Projects", "No Projects");
      projects.add(pro);
      return projects;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Help',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Contact')));
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Contact()));
              }),
          IconButton(
              icon: const Icon(Icons.auto_graph_outlined),
              tooltip: 'Metrics',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Metrics')));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountMetrics()));
              }),
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
        child: Column(children: [
          ListTile(
            title: const Text("Projects: "),
            trailing: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProjectScreen()));
                },
                icon: const Icon(Icons.plus_one)),
          ),
          Expanded(
              child: FutureBuilder(
                  future: getProjects(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.data[0].description
                          .toString()
                          .contains('No Projects')) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) => ListTile(
                                title: Text(snapshot.data[index].projectName
                                    .toString()),
                                leading: const Icon(Icons.book_online_sharp),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _delete(
                                              context, snapshot.data[index].id);
                                        },
                                        icon: const Icon(Icons.delete)),
                                    IconButton(
                                        onPressed: () async {
                                          List<dynamic>? p = await Project(
                                            0,
                                            '',
                                            '',
                                            '',
                                            '',
                                          ).loadProject(
                                              snapshot.data[index].id);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProjectDetailsScreen(
                                                          myproject: p![0])));
                                        },
                                        icon: const Icon(Icons.list)),
                                  ],
                                )));
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) => ListTile(
                                title: Text(snapshot.data[index].projectName
                                    .toString()),
                                leading: const Icon(Icons.book_online_sharp)));
                      }
                    }
                  })),
          const Expanded(child: BottomAppBar()),
        ]),
      ),
    );
  }
}
