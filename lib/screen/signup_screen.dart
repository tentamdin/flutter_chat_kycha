import 'package:flutter/material.dart';
import 'package:kycha/res/custom_colors.dart';
import 'package:kycha/screen/chat_screen.dart';
import 'package:kycha/utils/authentications.dart';
import 'package:kycha/utils/database.dart';
import 'package:kycha/utils/helper_functions.dart';
import 'package:kycha/widgets/custom_textfield.dart';
import 'package:kycha/widgets/google_signin_btn.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({this.toggle});
  final Function toggle;
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;
  // form validation method
  void signUp() {
    if (_formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "username": usernameTextEditingController.text,
        "email": emailTextEditingController.text,
      };

      HelperFunction.saveUsernameInSharePreference(
          usernameTextEditingController.text);
      HelperFunction.saveUserEmailSharePreference(
          emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      Authentication()
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunction.saveUserLoggedInSharePreference(true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: Image.asset(
                    'assets/firebase_logo.png',
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'FlutterFire',
                  style: TextStyle(
                    color: CustomColors.firebaseYellow,
                    fontSize: 40,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a username!';
                          } else if (value.length < 6) {
                            return "Please provide a username of 5+ character";
                          }
                          return null;
                        },
                        obscureText: false,
                        textEditingController: usernameTextEditingController,
                        hintText: "Username",
                        iconData: Icons.email_outlined,
                      ),
                      CustomTextField(
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)
                              ? null
                              : "Please Enter Correct Email";
                        },
                        obscureText: false,
                        textEditingController: emailTextEditingController,
                        hintText: "Email",
                        iconData: Icons.email_outlined,
                      ),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a password!';
                          } else if (value.length < 6) {
                            return "Please provide password of 5+ character ";
                          }
                          return null;
                        },
                        obscureText: true,
                        textEditingController: passwordTextEditingController,
                        hintText: "Password",
                        iconData: Icons.security,
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.green),
                            ),
                            onPressed: () {
                              signUp();
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                FutureBuilder(
                  future: Authentication().initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error initializing Firebase');
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return GoogleSignInButton();
                    }
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseOrange,
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
