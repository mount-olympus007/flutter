import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:business_features/services/services.dart';

class Task {
  int id;
  String taskName;
  String taskDescription;
  int featureId;
  String assignedEmployeeId;
  String estimatedTime;
  bool openIssue;
  Task(this.id, this.taskName, this.taskDescription, this.featureId,
      this.assignedEmployeeId, this.estimatedTime, this.openIssue);
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Task_Name': taskName,
      'Task_Description': taskDescription,
      'Feature_Id': featureId,
      'Assigned_Employee_Id': assignedEmployeeId,
      'Estimated_Time': estimatedTime,
      'Open_Issue': openIssue
    };
  }

  updateTask(Task task) async {
    final db = await Services().database();
    var result = await db
        .update("task", task.toMap(), where: "Id = ?", whereArgs: [task.id]);
    return result;
  }

  insertTask(Task task) async {
    final db = await Services().database();

    List<Map> list = await db.query('task');
    task.id = list.length + 1;
    await db.insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List?> loadTask(int id) async {
    final db = await Services().database();
    List<Map> list = await db.query('task', where: "Id = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }

  removeTask(int id) async {
    final db = await Services().database();
    await db.delete('task', where: "Id = ?", whereArgs: [id]);
  }

  Future<List?> getTasks(int featureId) async {
    //grab server projects and Union with local projects
    // then send back as one list

    final db = await Services().database();
    List<Map> list =
        await db.query('task', where: "Feature_Id = ?", whereArgs: [featureId]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }
}
