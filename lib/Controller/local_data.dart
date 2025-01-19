import 'dart:developer';

import 'package:chat_app/Controller/user_controller.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalData {
  static dynamic _database;
  static String path = '';
  static Future<void> startDatabase() async {
    _database = await openDatabase(
      path = join(await getDatabasesPath(), "MySocialMediaDatabase"),
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE UserInfo(
            uid TEXT PRIMARY KEY,
            name TEXT,
            email TEXT,
            password TEXT,
            username TEXT,
            profilepic TEXT
          )
        ''');
      },
    );
    log(path);
    log("Databse isOpen : ${_database.isOpen}");
  }

  static Future<void> insertUserData(UserModel userModel) async {
    log("Before start");
    await startDatabase();
    dynamic localDB = await _database;
    int ans = await localDB.insert("UserInfo", userModel.userMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    log("$ans");
  }

  static Future<void> deleteUserData(String useruid) async {
    final localDB = await _database;
    await localDB.delete(
      "UserInfo",
      where: "uid = ?",
      whereArgs: useruid,
    );
  }

  static Future<UserModel> getUserData() async {
    Database localDB = await _database;
    log("In getUserData before getting data");
    List<Map<String, dynamic>> mapEntry = await localDB.query("UserInfo");

    UserModel userModel = UserModel(
      email: mapEntry.first['email'],
      name: mapEntry.first['name'],
      password: mapEntry.first['password'],
      userName: mapEntry.first['username'],
      profileURL: mapEntry.first['profilepic'] ?? "",
      userUid: mapEntry.first['uid'],
    );
    log("${mapEntry.first['email']}");
    log("${mapEntry.first['name']}");
    log("${mapEntry.first['password']}");
    log("${mapEntry.first['username']}");
    log("${mapEntry.first['profilepic']}");
    log("${mapEntry.first['uid']}");
    return userModel;
  }

  static Future<void> saveLocalData(String uid) async {
    UserModel userModel = await UserController.getUserDetails(uid);
    await insertUserData(userModel);
    log("Inserted Locally");
  }
}
