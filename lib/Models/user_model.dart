import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class User {
  final int id;
  final String email;
  final String password;
  final int mobile;
  User(this.id, this.email, this.password, this.mobile);

  Map<String, dynamic> toMap() {
    return {'id': id, 'email': email, 'password': password, 'mobile': mobile};
  }

  Future<Database> database() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'test_database.db');

    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE applications(id INTEGER PRIMARY KEY, representativeId INTEGER, tempsPlusId INTEGER, locationSubId INTEGER, submissionDate DATETIME, firstName TEXT, middleInitial TEXT, lastName TEXT, address1 TEXT, address2 TEXT, city TEXT, state TEXT, zip INTEGER, email TEXT, homePhone TEXT, mobilePhone TEXT, gender TEXT, race TEXT, dateOfBirth DATETIME, startDate DATETIME, requestedRate TEXT, veteranStatus TEXT, disabilityStatus TEXT, socialSecurityNumber TEXT, hearAboutUs TEXT, legalAuthorization TEXT, highSchoolName TEXT, highSchoolLocation TEXT, highSchoolGraduated TEXT, collegeName TEXT, collegeLocation TEXT, collegeMajor TEXT, collegeGraduated TEXT, i9Authorization TEXT, i9CitizenshipStatus TEXT, w4FilingType TEXT, w4NumberOfUnder17Dependants TEXT, w4NumberOfOherDependants TEXT, adminNotes TEXT, status TEXT, createdDate TEXT, createdBy TEXT, modifiedDate TEXT, modifiedBy TEXT)');
        await db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, mobile TEXT, password TEXT)');
        await db.execute(
            'CREATE TABLE workopportunities(Id INTEGER PRIMARY KEY, UserId INTEGER, NameOfBusiness TEXT, Address TEXT, City TEXT, Zip TEXT, JobTitle TEXT, Rate TEXT, StartTime DATETIME, EndTime DATETIME, Status TEXT)');
      },
    );
    return database;
  }

  insertUser(User user) async {
    final db = await database();
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List?> getUsers() async {
    final db = await database();
    List<Map> list = await db.query('users');
    if (list.isNotEmpty) {
      return list;
    }
    return null;
  }
}
