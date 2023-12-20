import 'dart:async';
import 'package:business_features/Models/task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:business_features/services/services.dart';

class ServiceTicket {
  int id;
  int taskId;
  String creatorId;
  String message;
  String response;
  bool isOpen;
  ServiceTicket(this.id, this.taskId, this.creatorId, this.message,
      this.response, this.isOpen);

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Task_Id': taskId,
      'Creator_Id': creatorId,
      'Message': message,
      'Response': response,
      'IsOpen': isOpen
    };
  }

  Future<List?> loadTicket(int id) async {
    final db = await Services().database();
    List<Map> list = await db.query('ticket', where: "Id = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }

  insertTicket(ServiceTicket ticket) async {
    final db = await Services().database();

    List<Map> list = await db.query('ticket');
    ticket.id = list.length + 1;
    ticket.creatorId = await Services().getServerUserId();
    List<dynamic>? t =
        await Task(0, "", "", 0, "", "", false).loadTask(ticket.taskId);

    Task newTask = Task(
        t![0]["Id"],
        t[0]["Task_Name"],
        t[0]["Task_Description"],
        t[0]["Feature_Id"],
        t[0]["Assigned_Employee_Id"],
        t[0]["Estimated_Time"],
        true);
    Task(0, "", "", 0, "", "", false).updateTask(newTask);
    await db.insert(
      'ticket',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeTicket(int id) async {
    final db = await Services().database();
    await db.delete('ticket', where: "Id = ?", whereArgs: [id]);
  }

  Future<List?> getTickets() async {
    //grab server projects and Union with local projects
    // then send back as one list

    final db = await Services().database();
    String id = await Services().getServerUserId();
    List<Map> list =
        await db.query('ticket', where: "Creator_Id = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }
}
