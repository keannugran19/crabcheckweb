// ignore_for_file: unused_field
import 'package:crabcheckweb1/constants/colors.dart';
import 'package:crabcheckweb1/pages/authentication/firebase_auth.dart';
import 'package:crabcheckweb1/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late TextEditingController textControllerEmail;
  late FocusNode textFocusNodeEmail;
  bool _isEditingEmail = false;

  late TextEditingController textControllerPassword;
  late FocusNode textFocusNodePassword;
  bool _isEditingPassword = false;

  final bool _isRegistering = false;
  bool _isLogginIn = false;

  String? loginStatus;
  String? _errorMessage;

  String? _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(
          RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+"))) {
        return "Enter a correct email address";
      }
    }
    return null;
  }

  String? _validatePassword(String value) {
    value = value.trim();

    if (textControllerPassword.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Password can\'t be empty';
      } else if (value.length < 6) {
        return 'Length of the password should be greater than 6';
      }
    }
    return null;
  }

  @override
  void initState() {
    textControllerEmail = TextEditingController();
    textControllerPassword = TextEditingController();
    textControllerEmail.text = '';
    textControllerPassword.text = '';
    textFocusNodeEmail = FocusNode();
    textFocusNodePassword = FocusNode();
    super.initState();
  }

  Future<void> _login() async {
    setState(() {
      _isLogginIn = true;
      textFocusNodeEmail.unfocus();
      textFocusNodePassword.unfocus();
    });

    if (_validateEmail(textControllerEmail.text) == null &&
        _validatePassword(textControllerPassword.text) == null) {
      await signInWithEmailPassword(
              textControllerEmail.text, textControllerPassword.text)
          .then((result) {
        if (result != null) {
          devtools.log(result.toString());

          Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => HomePage(),
            ),
          );

          setState(() {
            loginStatus = 'You have successfully logged in';
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = 'Incorrect email or password';
          });
        }
      }).catchError((error) {
        devtools.log('Login Error: $error');
        setState(() {
          loginStatus = 'Error occurred while logging in';
        });
      });
    } else {
      setState(() {
        loginStatus = 'Please enter email & password';
      });
    }

    setState(() {
      _isLogginIn = false;
      textControllerEmail.text = '';
      textControllerPassword.text = '';
      _isEditingEmail = false;
      _isEditingPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("lib/assets/images/loginbackground.png"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: colorScheme.surface.withOpacity(.85),
            ),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/assets/images/crabLogo.png",
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("LOGIN",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Welcome to the admin panel.",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  focusNode: textFocusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  controller: textControllerEmail,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      _isEditingEmail = true;
                    });
                  },
                  onSubmitted: (value) {
                    textFocusNodeEmail.unfocus();
                    FocusScope.of(context).requestFocus(textFocusNodePassword);
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  obscureText: true,
                  focusNode: textFocusNodePassword,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: textControllerPassword,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      _isEditingPassword = true;
                    });
                  },
                  onSubmitted: (value) {
                    textFocusNodePassword.unfocus();
                    _login();
                  },
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (_errorMessage != null)
                  Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(
                  height: 10,
                ),

                //* Login Button
                Container(
                  alignment: Alignment.center,
                  child: Material(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _login,
                      child: const SizedBox(
                        width: double
                            .maxFinite, // This makes the button expand to the max width
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign
                                .center, // Centers the text within the button
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(text: "Do not have admin credentials? "),
                  TextSpan(
                      text: "Request IT Support! ",
                      style: TextStyle(color: colorScheme.primary))
                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
