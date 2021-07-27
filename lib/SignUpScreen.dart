import 'package:flutter/material.dart';
import 'package:onetoonechatapp/Authentication.dart';
import 'package:onetoonechatapp/SignInScreen.dart';
import 'HomeScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isloading = false;

  validator() {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      print("Validate");
      setState(() {
        isloading = true;
      });
      createAccount(
              usernameTextEditingController.text,
              emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((user) {
        if (user != null) {
          print("Created  Successfully");
          setState(() {
            isloading = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          print("Account registeration Failed");
          setState(() {
            isloading = false;
          });
        }
      });
    } else {
      print("Not validate");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('SignUpScreen')),
        body: isloading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please provide a valid email-id";
                          },
                          controller: emailTextEditingController,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Enter your e-mail',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (val) {
                            return val!.isEmpty || val.length < 4
                                ? "Please provide username"
                                : null;
                          },
                          controller: usernameTextEditingController,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              labelText: 'Enter your username',
                              labelStyle: TextStyle(
                                color: Colors.grey[600],
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          validator: (val) {
                            return val!.length > 6
                                ? null
                                : "Please provide password";
                          },
                          controller: passwordTextEditingController,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            labelText: 'Enter your password',
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: () {
                              validator();
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "OR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              side: BorderSide(color: Colors.blue, width: 2.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            icon: Icon(
                              Icons.coronavirus,
                              size: 28,
                            ),
                            label: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account ? ",
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            GestureDetector(
                              onTap: () {
                                SignInScreen();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text("Sign in Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline,
                                    )),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ));
  }
}
