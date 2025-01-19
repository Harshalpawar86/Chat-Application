import 'dart:developer';
import 'dart:io';

import 'package:chat_app/Model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserController extends ChangeNotifier {
  static Future<void> addUserToDatabase(
      {required String email,
      required String password,
      required File? profilepic,
      required String uid,
      required String name,
      required String userName}) async {
    String profileURL = "";
    if (profilepic != null) {
      profileURL = await storeProfileImage(uid, profilepic);
    }
    await FirebaseFirestore.instance
        .collection("allusers")
        .doc(uid)
        .collection("UserData")
        .add({
      "email": email,
      "name": name,
      "password": password,
      "username": userName,
      "useruid": uid,
      "profilepic": profileURL
    });
  }

  static Future<String> storeProfileImage(String uid, File profilepic) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("$uid/profile_image/pfp");
    UploadTask uploadTask = storageReference.putFile(profilepic);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadedUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadedUrl;
  }

  static Future<List<UserModel>> getAllUserData() async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    List<String> uidList = [];
    List<UserModel> usersList = [];
    QuerySnapshot<Map<String, dynamic>> uidData =
        await FirebaseFirestore.instance.collection("allusers").get();
    for (var doc in uidData.docs) {
      if (doc.data()['uid'] != null) {
        uidList.add(doc.data()['uid']);
      }
    }
    for (int i = 0; i < uidData.docs.length; i++) {
      QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection("allusers")
          .doc(uidList[i])
          .collection("UserData")
          .get();

      for (var doc in userData.docs) {
     //   log("${userData.docs.first.data()}");
        if (myUid != doc.data()['useruid']) {
          UserModel userModel = UserModel(
              email: doc.data()['email'],
              name: doc.data()['name'],
              profileURL: doc.data()['profilepic'] ?? "",
              password: doc.data()['password'],
              userName: doc.data()['username'],
              userUid: doc.data()['useruid']);
          usersList.add(userModel);
        }
      }
    }
    log("${usersList.first}");
    return usersList;
  }

  static Future<UserModel> getUserDetails(String uid) async {
    QuerySnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
        .instance
        .collection("allusers")
        .doc(uid)
        .collection("UserData")
        .get();
    log("${userData.docs.first.data()}");
    UserModel userModel = UserModel(
      email: userData.docs.first.data()['email'],
      name: userData.docs.first.data()['name'],
      password: userData.docs.first.data()['password'],
      userName: userData.docs.first.data()['username'],
      profileURL: userData.docs.first.data()['profileurl'] ?? "",
      userUid: userData.docs.first.data()['useruid'],
    );
    return userModel;
  }

  static Stream<List<UserModel>> getChatFriends() {
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection("allusers")
        .doc(myUid)
        .collection("friends")
        .snapshots()
        .asyncMap((QuerySnapshot<Map<String, dynamic>> qs) async {
      List<UserModel> friendsList = [];

      for (var doc in qs.docs) {
        String? friendUid = doc.data()['uid'];
        if (friendUid != null) {
          List<String> list = [myUid, friendUid]..sort();
          String chatRoomId = list.join('__');

          DocumentSnapshot<Map<String, dynamic>> chatRoomDoc =
              await FirebaseFirestore.instance
                  .collection("chatrooms")
                  .doc(chatRoomId)
                  .get();

          UserModel friend = await getUserDetails(friendUid);
          if (chatRoomDoc.exists) {
            Map<String, dynamic>? chatRoomData = chatRoomDoc.data();
            friend.lastMessage = chatRoomData?['lastmessage'] ?? '';
            friend.time = chatRoomData?['timestamp'] != null
                ? DateFormat('hh:mm a')
                    .format(chatRoomData?['timestamp'].toDate())
                : "";
          }

          friendsList.add(friend);
        }
      }

      return friendsList;
    });
  }

  static Future<void> sendMessage(
      {required String friendUid, required String message}) async {
    log("Before sent");
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    List list = [myUid, friendUid]..sort();
    String chatRoomId = list.join('__');
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .add({
      "sender": myUid,
      "reciever": friendUid,
      "message": message,
      "timestamp": FieldValue.serverTimestamp()
    });
    await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .set({
      "senderUID": myUid,
      "recieverUID": friendUid,
      "lastmessage": message,
      "timestamp": FieldValue.serverTimestamp()
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("allusers")
        .doc(myUid)
        .collection("friends")
        .doc(friendUid)
        .set({"uid": friendUid});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required String friendUid}) {
    String myUID = FirebaseAuth.instance.currentUser!.uid;
    List<String> sortedUids = [myUID, friendUid]..sort();
    String chatRoomId = sortedUids.join('__');
    Stream<QuerySnapshot<Map<String, dynamic>>> documentSnapshot =
        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomId)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .snapshots();
    return documentSnapshot;
  }

  static Future getTimeAndMessage(String friendUid) async {
    String myUID = FirebaseAuth.instance.currentUser!.uid;
    List<String> sortedUids = [myUID, friendUid]..sort();
    String chatRoomId = sortedUids.join('__');
    return await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
  }

  static Stream<bool> checkOnlineStatus(String friendUid) {
    return FirebaseFirestore.instance
        .collection("allusers")
        .doc(friendUid)
        .snapshots()
        .map((snapshot) {
      log("Data from Firestore: ${snapshot.data()}");
      return (snapshot.data()?["isOnline"] ?? false);
    });
  }

  static void updateUserStatus(bool value) async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("allusers")
        .doc(myUid)
        .set({"isOnline": value});
  }

  static Future<void> addPost(
      {required File imageFile, String? caption}) async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    String postId = FirebaseFirestore.instance.collection("chatrooms").doc().id;
    FirebaseFirestore.instance
        .collection("allusers")
        .doc(myUid)
        .collection("posts")
        .doc(postId)
        .set({});
  }
}
