import 'package:chat_app/Controller/user_controller.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/View/user_chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> fullUsersList = [];
  List<UserModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterUsers);
  }

  void filterUsers() {
    String searchData = searchController.text.toLowerCase();
    setState(() {
      filteredList = fullUsersList.where((UserModel user) {
        return user.name.toLowerCase().contains(searchData) ||
            user.userName.toLowerCase().contains(searchData);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Container(
              height: height / 12,
              width: width,
              padding: EdgeInsets.only(
                top: (height / 12) / 7,
                bottom: 7,
                left: 10,
                right: 10,
              ),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(191, 113, 247, 1),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1,
                    spreadRadius: 1,
                  )
                ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 5,
                      width: 5,
                      child: SvgPicture.asset(
                        "assets/svgs/search_svg.svg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  fillColor: Colors.white,
                  hintText: "Search Your Friends...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // User List with Search Functionality
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: UserController.getChatFriends(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(191, 113, 247, 1),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error while retrieving chat friends.."),
                    );
                  }

                  // Assign full user list and filter based on search
                  fullUsersList = snapshot.data ?? [];
                  filteredList = searchController.text.isEmpty
                      ? fullUsersList
                      : fullUsersList.where((UserModel user) {
                          return user.name.toLowerCase().contains(
                                    searchController.text.toLowerCase(),
                                  ) ||
                              user.userName.toLowerCase().contains(
                                    searchController.text.toLowerCase(),
                                  );
                        }).toList();

                  return filteredList.isEmpty
                      ? const SizedBox()
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return UserChatTile(userModel: filteredList[index]);
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
