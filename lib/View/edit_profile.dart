import "dart:developer";
import "dart:io";

import "package:delightful_toast/delight_toast.dart";
import "package:delightful_toast/toast/components/toast_card.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:image_picker/image_picker.dart";

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
  });
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  Future showConfirmImageDialog(File file) async {
    await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text("Confirm Photo ?",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(image: FileImage(file))),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          //  await MyFirebaseFirestore.saveProfileImage(file);
                          Navigator.of(dialogContext).pop();
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
                          "Yes",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
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
                          "No",
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future openAlertBox() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Proile Photo",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          content: Row(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (image != null) {
                      await showConfirmImageDialog(File(image.path));
                      log("${File(image.path)}");
                    }
                  },
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      elevation: const WidgetStatePropertyAll(10),
                      shadowColor: const WidgetStatePropertyAll(Colors.grey),
                      overlayColor:
                          const WidgetStatePropertyAll(Colors.deepPurple),
                      backgroundColor: WidgetStatePropertyAll(
                          Colors.deepPurpleAccent.shade100)),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 25,
                  )),
              const Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    XFile? image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      await showConfirmImageDialog(File(image.path));
                      log("${File(image.path)}");
                    }
                  },
                  style: ButtonStyle(
                      alignment: Alignment.center,
                      elevation: const WidgetStatePropertyAll(10),
                      shadowColor: const WidgetStatePropertyAll(Colors.grey),
                      overlayColor:
                          const WidgetStatePropertyAll(Colors.deepPurple),
                      backgroundColor: WidgetStatePropertyAll(
                          Colors.deepPurpleAccent.shade100)),
                  child: const Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 25,
                  )),
            ],
          ),
        );
      },
    );
  }

  void showToast(
    String message,
    BuildContext context,
  ) {
    DelightToastBar(
      autoDismiss: true,
      builder: (context) {
        return ToastCard(
            color: Colors.white,
            title: Text(
              message,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ));
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        height: height,
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 1.5,
                        spreadRadius: 1.5)
                  ],
                  color: Color.fromRGBO(191, 113, 247, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                "Update Information",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: // (widget.profileURL == "")
                              const AssetImage("assets/photos/profile_pic.jpg")
                          //  : NetworkImage(widget.profileURL)
                          )),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black)),
                      child: IconButton(
                        onPressed: () async {
                          await openAlertBox();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 33,
                        ),
                        color: const Color.fromRGBO(191, 113, 247, 1),
                      ),
                    ))
              ],
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
                        Text("Update Name",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
                          controller: nameController,
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
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Update Username",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
                          controller: userNameController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter username";
                            } else if (RegExp(r'\d').hasMatch(value) == false) {
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
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Update Email",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
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
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Update Password",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
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
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
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
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide:
                                    const BorderSide(color: Colors.deepPurple)),
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
                                // try {
                                //   if (_key.currentState!.validate()) {
                                //     await MyFirebaseFirestore
                                //         .updateCurrentUserInformation(
                                //             name: nameController.text,
                                //             userName:
                                //                 userNameController.text.trim(),
                                //             email: emailController.text.trim(),
                                //             password:
                                //                 passwordController.text.trim());
                                //   }
                                // } catch (e) {
                                //   showToast(e.toString(), context);
                                // }
                                setState(() {
                                  isLoading = false;
                                });
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
                              child: (isLoading)
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text("Update",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              "*A verification link will be sent\nto your new Email if changed..",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(191, 113, 247, 1),
              ),
            )
          ],
        ),
      )),
    );
  }
}
