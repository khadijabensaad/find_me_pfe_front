import 'dart:convert';

import 'package:find_me/Auth/forgotPassword.dart';
import 'package:find_me/Auth/signUp.dart';
import 'package:find_me/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailcntrl;
  late TextEditingController _passwordcntrl;
  bool isObscured = true;
  String _emailErrorText = "";
  String _passwordErrorText = "";
  bool _hasErrorEmail = false;
  bool _hasErrorPassword = false;
  int _counterTesterError = 0;
  String message = '';
  late SharedPreferences prefs;

  //tsirelha exec 9bal ma l'app tbuildi
  @override
  void initState() {
    _emailcntrl = TextEditingController();
    _passwordcntrl = TextEditingController();
    initSharedPref();
    super.initState();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    var reqBody = jsonEncode(
        {"email": _emailcntrl.text, "password": _passwordcntrl.text});
    String url = 'http://192.168.43.28:5000/auth/login';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: reqBody);
    var jsonResponse = jsonDecode(response.body);
    setState(() {
      message = jsonResponse["message"];
    });
    print(message);
    if (jsonResponse["status"]) {
      var userToken = jsonResponse['token'];
      prefs.setString("userToken", userToken);
      prefs.setBool("activated", true);
      //bech nbadlou .push ba3d ma na3mlou les tests
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const MainScreenPage()),
          (route) => false);
    }
    //Fluttertoast.showToast(msg: message,);
  }

  //libere l'espace memoire
  @override
  void dispose() {
    _emailcntrl.dispose();
    _passwordcntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color((0xFFFDF1E1)),
        body: SafeArea(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login.png",
                height: 250,
              ),
              Image.asset(
                "assets/images/welcome_back.png",
                width: 230,
              ),
              const Divider(
                indent: 80,
                endIndent: 80,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  "Login with your Email and Password for personalized shopping experiences just for you",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 129, 129, 129),
                      fontFamily: 'Poppins',
                      fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 5, top: 5),
                child: TextField(
                  controller: _emailcntrl,
                  cursorColor: const Color(0xFFDF9A4F),
                  style: const TextStyle(
                      fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    errorText: _emailErrorText,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: _hasErrorEmail
                                ? Colors.red
                                : const Color(0xFFDF9A4F),
                            width: 2),
                        gapPadding: 10),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: _hasErrorEmail
                                ? Colors.red
                                : const Color(0xFFDF9A4F),
                            width: 2),
                        gapPadding: 10),
                    labelText: "Email",
                    hintText: "Enter your email",
                    labelStyle: const TextStyle(
                        color: Color(0xFFDF9A4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins'),
                    prefixIcon: const Icon(CupertinoIcons.mail,
                        size: 25, color: Color.fromARGB(255, 97, 84, 72)),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFFDF9A4F), width: 2),
                        gapPadding: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFFDF9A4F), width: 2),
                        gapPadding: 10),
                    errorStyle: const TextStyle(
                        color: Colors.red, fontSize: 11, fontFamily: 'Poppins'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (_counterTesterError != 0) {
                        if (value.isEmpty) {
                          _emailErrorText = "This field cannot be empty!";
                          _hasErrorEmail = true;
                        } else if (!value.contains('@') ||
                            !value.contains('.')) {
                          _emailErrorText = "Email is not valid!";
                          _hasErrorEmail = true;
                        } else {
                          _emailErrorText = '';
                          _hasErrorEmail = false;
                        }
                      }
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (_counterTesterError != 0) {
                        if (_emailcntrl.text.isEmpty) {
                          _emailErrorText = "This field cannot be empty!";
                          _hasErrorEmail = true;
                        } else if (!_emailcntrl.text.contains('@') ||
                            !_emailcntrl.text.contains('.')) {
                          _emailErrorText = "Email is not valid!";
                          _hasErrorEmail = true;
                        } else {
                          _emailErrorText = '';
                          _hasErrorEmail = false;
                        }
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextField(
                  controller: _passwordcntrl,
                  cursorColor: const Color(0xFFDF9A4F),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                  obscureText: isObscured,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    errorText: _passwordErrorText,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: _hasErrorPassword
                                ? Colors.red
                                : const Color(0xFFDF9A4F),
                            width: 2),
                        gapPadding: 10),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: _hasErrorPassword
                                ? Colors.red
                                : const Color(0xFFDF9A4F),
                            width: 2),
                        gapPadding: 10),
                    errorStyle: const TextStyle(
                        color: Colors.red, fontSize: 11, fontFamily: 'Poppins'),
                    labelStyle: const TextStyle(
                        color: Color(0xFFDF9A4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins'),
                    prefixIcon: const Icon(CupertinoIcons.lock_fill,
                        size: 25, color: Color.fromARGB(255, 97, 84, 72)),
                    suffix: IconButton(
                      icon: isObscured
                          ? const Icon(
                              CupertinoIcons.eye_slash_fill,
                              size: 23,
                              color: Color.fromARGB(255, 97, 84, 72),
                            )
                          : const Icon(
                              CupertinoIcons.eye_fill,
                              size: 23,
                              color: Color.fromARGB(255, 97, 84, 72),
                            ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    contentPadding: const EdgeInsets.fromLTRB(50, 5, 5, 10),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFFDF9A4F), width: 2),
                        gapPadding: 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFFDF9A4F), width: 2),
                        gapPadding: 10),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (_counterTesterError != 0) {
                        if (value.length < 8) {
                          _passwordErrorText =
                              "Password should at least contain 8 characters!";
                          _hasErrorPassword = true;
                        } else {
                          _passwordErrorText = "";
                          _hasErrorPassword = false;
                        }
                      }
                    });
                  },
                  onTap: () {
                    setState(() {
                      if (_counterTesterError != 0) {
                        if (_passwordcntrl.text.length < 8) {
                          _passwordErrorText =
                              "Password should at least contain 8 characters!";
                          _hasErrorPassword = true;
                        } else {
                          _passwordErrorText = "";
                          _hasErrorPassword = false;
                        }
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 255, 237, 211)),
                        ),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Color(0xFF965D1A),
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const ForgotPassword(),
                              ));
                          //Navigator.push(context, CupertinoPageRoute(builder:(context) => const ForgotPassword(),));
                        },
                        /*bech nsal7ou les diagrammes de cas d'utilisation lkol w bech nkamlou les autres parties de rapport w bech nchofou hkeyet sign in w sign up w kif yitna7aw bech yitbadlou maahom hajet fi diagramme de classe */
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor:
                            const Color(0xFFDF9A4F), // background color
                      ),
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                            color: Color(0xFF965D1A),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins'),
                      ),
                      onPressed: () {
                        if (_emailcntrl.text.isNotEmpty &&
                            (_emailcntrl.text.contains('@') &&
                                _emailcntrl.text.contains('.')) &&
                            (_passwordcntrl.text.length > 7)) {
                          //lenna win bech nekhdmou
                          loginUser().whenComplete(() => Fluttertoast.showToast(
                                msg: message,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.black.withOpacity(0.7),
                              ));
                          //Navigator.push(context, CupertinoPageRoute(builder: (context)=>const  MainScreenPage()));
                          //_authCallAPi.login();
                        }
                        setState(() {
                          _counterTesterError += 1;
                          if (_emailcntrl.text.isEmpty) {
                            _emailErrorText = "This field cannot be empty!";
                            _hasErrorEmail = true;
                          } else if (!_emailcntrl.text.contains('@') ||
                              !_emailcntrl.text.contains('.')) {
                            _emailErrorText = "Email is not valid!";
                            _hasErrorEmail = true;
                          }
                          if (_passwordcntrl.text.length < 8) {
                            _passwordErrorText =
                                "Password should at least contain 8 characters!";
                            _hasErrorPassword = true;
                          }
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You don't have an account?",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 255, 237, 211)),
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFF965D1A),
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const SignUp(),
                              ));
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        )));
  }
}
