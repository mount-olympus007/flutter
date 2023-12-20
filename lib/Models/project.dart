import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:business_features/services/services.dart';

class Project {
  int id;
  String projectName;
  String projectType;
  String description;
  String creatorId;
  Project(this.id, this.projectName, this.projectType, this.description,
      this.creatorId);

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Project_Name': projectName,
      'ProjectType': projectType,
      'Description': description,
      'CreatorID': creatorId
    };
  }

  Future<List?> loadProject(int id) async {
    final db = await Services().database();
    List<Map> list =
        await db.query('project', where: "Id = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }

  insertProject(Project project) async {
    final db = await Services().database();
    List<Map> list = await db.query('project');
    project.creatorId = await Services().getServerUserId();
    project.id = list.length + 1;
    await db.insert(
      'project',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeProject(int id) async {
    final db = await Services().database();
    await db.delete('project', where: "Id = ?", whereArgs: [id]);
  }

  Future<List?> getProjects() async {
    //grab server projects and Union with local projects
    // then send back as one list

    final db = await Services().database();
    String id = await Services().getServerUserId();
    List<Map> list =
        await db.query('project', where: "creatorId = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }
}
