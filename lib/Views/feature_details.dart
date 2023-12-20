import 'package:flutter/material.dart';
import '../Models/task.dart';
import 'add_task.dart';
import 'settings.dart';
import 'task_details.dart';

class FeatureDetailsScreen extends StatefulWidget {
  const FeatureDetailsScreen({Key? key, required this.feature})
      : super(key: key);
  final dynamic feature;

  @override
  State<StatefulWidget> createState() {
    return MyFeatureDetailsScreen(feature);
  }
}

class MyFeatureDetailsScreen extends State<FeatureDetailsScreen> {
  late dynamic data;

  MyFeatureDetailsScreen(dynamic feature) {
    data = feature;
  }

  Future<List<Task>> getTasks() async {
    final Future<List?> serverTaskList =
        Task(0, "", "", data["Id"], "", "", false).getTasks(data["Id"]);
    List<Task> tasks = [];
    final List? taskList = await serverTaskList;
    if (taskList != null) {
      for (var f in taskList) {
        Task t = Task(
            (f["Id"]),
            f["Task_Name"],
            f["Task_Description"],
            (f["Feature_Id"]),
            f["Assigned_Employee_Id"],
            f["Estimated_Time"],
            (f["Open_Issue"] == 0 ? false : true));
        tasks.add(t);
      }
      return tasks;
    } else {
      Task t = Task(
          0, "No Tasks", "No Tasks", data['Id'], "No Tasks", "No Tasks", false);
      tasks.add(t);
      return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(data["Feature_Name"]), actions: <Widget>[
        IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('My Account Settings')));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            })
      ]),
      body: Center(
          child: Column(
        children: <Widget>[
          ListTile(
            title: const Text("Feature Name"),
            subtitle: Text(data["Feature_Name"]),
          ),
          ListTile(
            title: const Text("Feature Description"),
            subtitle: Text(data["Feature_Description"]),
          ),
          ListTile(
              title: const Text("Tasks:"),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddTaskScreen(myfeatureid: data["Id"])));
                  },
                  icon: const Icon(Icons.plus_one))),
          Expanded(
              child: FutureBuilder(
            future: getTasks(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.data[0].taskName
                    .toString()
                    .contains("No Tasks")) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) => ListTile(
                          tileColor: snapshot.data[index].openIssue
                              ? Colors.red
                              : Colors.white,
                          title: Text(snapshot.data[index].taskName.toString()),
                          leading: const Icon(Icons.book_online_sharp),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete)),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TaskDetailsScreen(
                                                    task:
                                                        snapshot.data[index])));
                                  },
                                  icon: const Icon(Icons.list)),
                            ],
                          )));
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) => ListTile(
                          title:
                              Text(snapshot.data[index].Task_Name.toString()),
                          leading: const Icon(Icons.book_online_sharp)));
                }
              }
            },
          ))
        ],
      )),
    );
  }
}
