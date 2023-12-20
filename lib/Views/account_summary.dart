import 'package:business_features/Models/project.dart';
import 'package:business_features/Models/service_ticket.dart';
import 'package:business_features/Views/project_listing.dart';
import 'package:flutter/material.dart';

import 'contact.dart';
import 'settings.dart';

class AccountMetrics extends StatefulWidget {
  const AccountMetrics({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyAccountMetrics();
  }
}

class MyAccountMetrics extends State<AccountMetrics> {
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

  Future<List<ServiceTicket>> getTickets() async {
    final Future<List?> serverList =
        ServiceTicket(0, 0, "", "", "", false).getTickets();
    List<ServiceTicket> tixs = [];
    final List? tixList = await serverList;
    if (tixList != null) {
      for (var p in tixList) {
        ServiceTicket pro = ServiceTicket(
            (p["Id"]),
            p["Task_Id"],
            p["Creator_Id"],
            p["Message"],
            p["Response"],
            (p["IsOpen"] == 0 ? true : false));
        tixs.add(pro);
      }
      return tixs;
    } else {
      ServiceTicket pro =
          ServiceTicket(0, 0, "No Issues", "No Issues", "No Issues", false);
      tixs.add(pro);
      return tixs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
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
      bottomNavigationBar: ListTile(
          title: const Text("To Projects"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProjectListScreen()));
          }),
      body: Center(
          child: Column(
        children: [
          FutureBuilder(
              future: getProjects(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  if (!snapshot.data[0].description
                      .toString()
                      .contains('No Projects')) {
                    return ListTile(
                      title: Text(snapshot.data.length.toString()),
                      subtitle: const Text("Number of Projects"),
                    );
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) => ListTile(
                                title: Text(snapshot.data[index].projectName
                                    .toString()),
                                leading: const Icon(Icons.book_online_sharp))));
                  }
                }
              }),
          FutureBuilder(
              future: getTickets(),
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  if (snapshot.data.length > 0) {
                    return ListTile(
                      title: Text(snapshot.data.length.toString()),
                      subtitle: const Text("Number of Open Service Tickets"),
                    );
                  } else {
                    return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) => ListTile(
                                title: Text(snapshot.data[index].projectName
                                    .toString()),
                                leading: const Icon(Icons.book_online_sharp))));
                  }
                }
              })
        ],
      )),
    );
  }
}
