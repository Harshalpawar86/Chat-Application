import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Controller/local_data.dart';
import 'package:chat_app/Controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite/sqlite_api.dart';

class AuthController {
  static Future<bool> checkLogin() async {
    SharedPreferencesAsync asyncPref = SharedPreferencesAsync();
    bool isLogin = await asyncPref.getBool("isLogin") ?? false;
    return isLogin;
  }

  static Future<void> loginUser(
      {required String email, required String password}) async {
    UserCredential usercredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    SharedPreferencesAsync asyncPref = SharedPreferencesAsync();
    await asyncPref.setBool("isLogin", true);
    String uid = usercredential.user!.uid;
    log("Login Done " "\n" "Here uid after login --------$uid");
    await LocalData.saveLocalData(uid);
  }

  static Future<void> signUpUser(
      {required String email,
      required String password,
      required String name,
      required File? profilePic,
      required String userName}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    String uid = userCredential.user!.uid;
    await UserController.addUserToDatabase(
        email: email,
        name: name,
        profilepic: profilePic,
        password: password,
        userName: userName,
        uid: uid);

    await loginUser(email: email, password: password);
  }

  static Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferencesAsync asyncPref = SharedPreferencesAsync();
    await asyncPref.setBool("isLogin", false);
    String path =
        join(await sqflite.getDatabasesPath(), "MySocialMediaDatabase");
    Database database = await sqflite.openDatabase(path);
    await database.execute('DELETE FROM UserInfo');
  }

  static Future<void> forgotPassword({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
