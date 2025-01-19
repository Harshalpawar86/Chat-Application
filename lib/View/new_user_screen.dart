import "dart:developer";
import "dart:io";

import "package:chat_app/Controller/auth_controller.dart";
import "package:chat_app/View/chat_list_screen.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:image_picker/image_picker.dart";
import "package:lottie/lottie.dart";

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});
  @override
  State createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isLoading = false;
  void clearControllers() {
    nameController.clear();
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          child: Column(
            children: [
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  width: width,
                  height: height / 3,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: LottieBuilder.asset(
                    "assets/animations/boy_avatar.json",
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.only(left: width / 8, right: width / 8),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Enter Name",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.deepPurple)),
                          TextFormField(
                            controller: nameController,
                            readOnly: isLoading,
                            keyboardType: TextInputType.name,
                            style: GoogleFonts.poppins(height: 1, fontSize: 17),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "First Last",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Enter Username",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.deepPurple)),
                          TextFormField(
                            controller: userNameController,
                            readOnly: isLoading,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter username";
                              } else if (RegExp(r'\d').hasMatch(value) ==
                                  false) {
                                return "Username must include atleast one number";
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.poppins(height: 1, fontSize: 17),
                            decoration: InputDecoration(
                              hintText: "Username",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Enter Email",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.deepPurple)),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            readOnly: isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email";
                              } else if (RegExp(
                                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value) ==
                                  false) {
                                return "Please enter valid email";
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.poppins(height: 1, fontSize: 17),
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Enter Password",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.deepPurple)),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            readOnly: isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter password";
                              } else if (RegExp(
                                          r'^(?=.*[0-9])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$')
                                      .hasMatch(value) ==
                                  false) {
                                return "Password must contain at least one number, one special character, and be at least 6 characters long.";
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.poppins(height: 1, fontSize: 17),
                            decoration: InputDecoration(
                              errorMaxLines: 5,
                              hintText: "Password",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Confirm Password",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.deepPurple)),
                          TextFormField(
                            controller: confirmPasswordController,
                            readOnly: isLoading,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm password";
                              } else if (passwordController.text != value) {
                                return "Passwords donot match";
                              } else {
                                return null;
                              }
                            },
                            style: GoogleFonts.poppins(height: 1, fontSize: 17),
                            decoration: InputDecoration(
                              hintText: "Confirm Password",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.grey.shade500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: const BorderSide(
                                      color: Colors.deepPurple)),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (_key.currentState!.validate()) {
                                    File? profilePic = await getProfilePic();
                                    await AuthController.signUpUser(
                                        email: emailController.text.trim(),
                                        password: passwordController.text,
                                        name: nameController.text,
                                        profilePic: profilePic,
                                        userName: userNameController.text);
                                    if (context.mounted) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatListScreen()));
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                style: ButtonStyle(
                                    alignment: Alignment.center,
                                    elevation: const WidgetStatePropertyAll(10),
                                    shadowColor: const WidgetStatePropertyAll(
                                        Colors.grey),
                                    overlayColor: const WidgetStatePropertyAll(
                                        Colors.deepPurple),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.deepPurpleAccent.shade100)),
                                child: (isLoading)
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text("Sign Up",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white))),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> getProfilePic() async {
    File? profilePic;
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Choose Later",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red),
                  ))
            ],
            backgroundColor: Colors.white,
            title: Text(
              "Select Profile Picture",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            contentPadding: EdgeInsets.all(10),
            content: StatefulBuilder(builder: (context, dialogState) {
              return Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: Color.fromRGBO(49, 49, 49, 0.5)),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: (profilePic == null)
                                ? AssetImage("assets/photos/profile_pic.jpg")
                                : FileImage(profilePic!),
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.camera);
                                if (image != null) {
                                  dialogState(() {
                                    profilePic = File(image.path);
                                    log("${File(image.path)}");
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  alignment: Alignment.center,
                                  elevation: const WidgetStatePropertyAll(10),
                                  shadowColor:
                                      const WidgetStatePropertyAll(Colors.grey),
                                  overlayColor: const WidgetStatePropertyAll(
                                      Colors.deepPurple),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.deepPurpleAccent.shade100)),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 25,
                              )),
                          Text(
                            "Camera",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                XFile? image = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  dialogState(() {
                                    profilePic = File(image.path);
                                  });
                                  log("${File(image.path)}");
                                }
                              },
                              style: ButtonStyle(
                                  alignment: Alignment.center,
                                  elevation: const WidgetStatePropertyAll(10),
                                  shadowColor:
                                      const WidgetStatePropertyAll(Colors.grey),
                                  overlayColor: const WidgetStatePropertyAll(
                                      Colors.deepPurple),
                                  backgroundColor: WidgetStatePropertyAll(
                                      Colors.deepPurpleAccent.shade100)),
                              child: const Icon(
                                Icons.image_outlined,
                                color: Colors.white,
                                size: 25,
                              )),
                          Text(
                            "Gallery",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 1.5,
                    width: 175,
                    color: Color.fromRGBO(49, 49, 49, 0.5),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (profilePic != null) {
                          Navigator.maybePop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Select Image"),
                          ));
                        }
                      },
                      style: ButtonStyle(
                          alignment: Alignment.center,
                          elevation: const WidgetStatePropertyAll(10),
                          shadowColor:
                              const WidgetStatePropertyAll(Colors.grey),
                          overlayColor:
                              const WidgetStatePropertyAll(Colors.deepPurple),
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.deepPurpleAccent.shade100)),
                      child: Text(
                        "Done",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ))
                ],
              );
            }),
          );
        });
    return profilePic;
  }
}
