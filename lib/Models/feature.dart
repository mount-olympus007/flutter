import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:business_features/services/services.dart';

class Feature {
  int id;
  String featureName;
  String featureDescription;
  int projectId;
  Feature(this.id, this.featureDescription, this.featureName, this.projectId);
  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Feature_Name': featureName,
      'Feature_Description': featureDescription,
      'Project_Id': projectId
    };
  }

  Future<List?> loadFeature(int id) async {
    final db = await Services().database();
    List<Map> list =
        await db.query('feature', where: "Id = ?", whereArgs: [id]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }

  insertFeature(Feature feature) async {
    final db = await Services().database();

    List<Map> list = await db.query('feature');
    feature.id = list.length + 1;
    await db.insert(
      'feature',
      feature.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  removeFeature(int id) async {
    final db = await Services().database();
    await db.delete('feature', where: "Id = ?", whereArgs: [id]);
  }

  Future<List?> getFeatures(int projectId) async {
    //grab server projects and Union with local projects
    // then send back as one list

    final db = await Services().database();
    List<Map> list = await db
        .query('feature', where: "Project_Id = ?", whereArgs: [projectId]);
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }
}
