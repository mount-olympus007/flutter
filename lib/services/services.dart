import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/user_model.dart';
import 'dart:async';

class Services {
  Future<Database> database() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'local_database.db');

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE applicationuser(Id TEXT PRIMARY KEY, email TEXT, email_confimed INTEGER, mobile TEXT, mobile_confirmed INTEGER, password TEXT)');
        await db.execute(
            'CREATE TABLE feature(Id INTEGER auto increment PRIMARY KEY, Feature_Name TEXT, Feature_Description TEXT, Project_Id INTEGER)');
        await db.execute(
            'CREATE TABLE project(Id INTEGER auto increment PRIMARY KEY, Project_Name TEXT, ProjectType TEXT, Description TEXT, CreatorID TEXT)');
        await db.execute(
            'CREATE TABLE task(Id INTEGER auto increment PRIMARY KEY, Task_Name TEXT, Task_Description TEXT, Feature_Id INTEGER, Assigned_Employee_Id TEXT, Estimated_Time TEXT, Open_Issue BOOL)');
        await db.execute(
            'CREATE TABLE ticket(Id INTEGER auto increment PRIMARY KEY, Task_Id INTEGER, Creator_Id TEXT, Message TEXT, Response TEXT, IsOpen BOOL)');
      },
    );
    return database;
  }

  insertUser(User user) async {
    final db = await database();
    await db.insert(
      'applicationuser',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List?> getUsers() async {
    final db = await database();
    List<Map> list = await db.query('applicationuser');
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }

  Future<String> getServerUserId() async {
    final localUser = await getUsers();
    if (localUser == null) {
      return "noUser";
    } else {
      String url = "http://10.0.2.2/businessbackend/api/getUser?email=" +
          localUser[0]['email'];
      final response = await http.get(Uri.parse(url));
      var responseData = convert.json.decode(response.body);
      return responseData[0]['Id'].toString();
    }
  }
}
