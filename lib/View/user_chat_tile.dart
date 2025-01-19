import 'dart:developer';

import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/View/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserChatTile extends StatelessWidget {
  final UserModel userModel;

  const UserChatTile({
    super.key,
    required this.userModel,
  });
  @override
  Widget build(BuildContext context) {
    log("Last Message : ${userModel.lastMessage}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChatScreen(userModel: userModel);
          }));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(offset: Offset(0, 1), blurRadius: 1, spreadRadius: 1)
              ]),
          child: Row(
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: (userModel.profileURL == "")
                            ? const AssetImage("assets/photos/profile_pic.jpg")
                            : NetworkImage(userModel.profileURL),
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover),
                    border: Border.all(
                        color: (userModel.profileURL == "")
                            ? const Color.fromRGBO(191, 113, 247, 1)
                            : Colors.black),
                    color: Colors.white,
                    shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          userModel.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${userModel.time}",
                          maxLines: 3,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade900),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${userModel.lastMessage}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade900),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
