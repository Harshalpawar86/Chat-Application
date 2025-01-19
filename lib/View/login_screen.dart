import "dart:developer";

import "package:chat_app/Controller/auth_controller.dart";
import "package:chat_app/View/chat_list_screen.dart";
import "package:chat_app/View/new_user_screen.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:lottie/lottie.dart";


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: globalKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "assets/animations/girl_avatar.json",
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter Email",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
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
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          height: 20,
                        ),
                        Text("Enter Password",
                            style: GoogleFonts.poppins(
                                fontSize: 14, color: Colors.deepPurple)),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Password";
                            } else {
                              return null;
                            }
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
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
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                if (globalKey.currentState!.validate()) {
                                  try {
                                    log("Login Started");
                                    await AuthController.loginUser(
                                        email: emailController.text.trim(),
                                        password: passwordController.text);
                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatListScreen()));
                                    }
                                  } catch (e) { 
                                    if (context.mounted) {
                                      log(e.toString());
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Something went wrong : ${e.toString()}"),
                                      ));
                                    }
                                  }
                                }
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
                                  : Text("Login",
                                      style: GoogleFonts.poppins(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Container(
                            height: 2,
                            width: width / 2,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => NewUserScreen()));
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
                              child: Text("Sign Up",
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
              GestureDetector(
                onTap: () {},
                child: Container(
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(
                            text: "Forgot Password ? ",
                            style: GoogleFonts.poppins(color: Colors.black),
                            children: <TextSpan>[
                          TextSpan(
                              text: "Click Here",
                              style: GoogleFonts.poppins(color: Colors.blue))
                        ]))),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}
