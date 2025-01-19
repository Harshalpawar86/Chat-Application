import "dart:developer";

import "package:chat_app/Controller/user_controller.dart";
import "package:chat_app/Model/user_model.dart";
import "package:chat_app/View/message_list_container.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  const ChatScreen({super.key, required this.userModel});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messsageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    log(widget.userModel.name);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
            top: 5,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 5),
        child: TextFormField(
          controller: _messsageController,
          decoration: InputDecoration(
            filled: true,
            prefixIcon:
                IconButton(onPressed: () {}, icon: const Icon(Icons.image)),
            suffixIcon: IconButton(
                onPressed: () async {
                  if (_messsageController.text.isNotEmpty) {
                    await UserController.sendMessage(
                        friendUid: widget.userModel.userUid,
                        message: _messsageController.text);
                    _messsageController.clear();
                  }
                },
                icon: const Icon(Icons.send)),
            fillColor: Colors.white,
            hintText: "Message",
            hintStyle:
                GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade500),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.deepPurple)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.deepPurple)),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(49, 49, 49, 0.5)),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                              image: (widget.userModel.profileURL == "")
                                  ? AssetImage("assets/photos/profile_pic.jpg")
                                  : NetworkImage(widget.userModel.profileURL))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userModel.name,
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ),
                          StreamBuilder<bool>(
                              stream: UserController.checkOnlineStatus(
                                  widget.userModel.userUid),
                              builder: (context, snapshot) {
                                return Text(
                                  (snapshot.data ?? false)
                                      ? "Online"
                                      : "Offline",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: (snapshot.data ?? false)
                                          ? Colors.green[600]
                                          : Colors.red,
                                      fontWeight: FontWeight.w500),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: UserController.getMessages(
                    friendUid: widget.userModel.userUid),
                builder: (context, snapshot) {
                  String myUID = FirebaseAuth.instance.currentUser!.uid;
                  List<QueryDocumentSnapshot> dataMap = [];
                  if (snapshot.data != null) {
                    dataMap = snapshot.data!.docs;
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Something went wrong"),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(191, 113, 247, 1),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          reverse: true,
                          itemCount: dataMap.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Timestamp? timestamp =
                                dataMap[index]["timestamp"] as Timestamp?;
                            String formattedTime = timestamp != null
                                ? DateFormat('hh:mm a')
                                    .format(timestamp.toDate())
                                : "";
                            bool isSent = dataMap[index]['sender'] == myUID;
                            return MessageListContainer(
                                message: dataMap[index]['message'],
                                time: formattedTime,
                                alignContainer: isSent);
                          });
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
