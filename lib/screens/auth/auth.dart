import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qismat/screens/auth/google_signin.dart';
import 'package:qismat/screens/auth/facebook_signin.dart';
import 'package:qismat/screens/auth/auth_navigator.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState!.save();

    try {
      final UserCredential userCredentials;
      if (_isLogin) {
        userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      }
      final User? user = userCredentials.user;
      if (user != null) {
        // User successfully signed in with Google
        // Navigate using AuthNavigator widget
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthNavigator(),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/qismat-logo.png'),
              ),
              Card(
                elevation: 0,
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                              labelStyle: TextStyle(
                                  color: Color(
                                      0xFFFF5858)), // Set the color of the email address string
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(
                                        0xFFFF5858)), // Set the color of the focused text box border
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(
                                        0xFFFF5858)), // Set the color of the enabled (idle) text box border
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: const Color(0xFFFF5858),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Color(
                                      0xFFFF5858)), // Set the color of the email address string
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(
                                        0xFFFF5858)), // Set the color of the focused text box border
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(
                                        0xFFFF5858)), // Set the color of the enabled (idle) text box border
                              ),
                            ),
                            obscureText: true,
                            cursorColor: const Color(
                                0xFFFF5858), // Set the color of the flashing cursor
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF5858),
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup',
                                style: TextStyle(color: Colors.white)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            borderRadius: BorderRadius.circular(
                                30.0), // Set to your desired border radius
                            child: TextButton(
                              onPressed: null, // or set to your logic
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Color(0xFFBAC1CE), // Text color
                              ),
                              child: Text(
                                _isLogin
                                    ? 'Create an account'
                                    : 'I already have an account',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                'Or continue with',
                style: TextStyle(
                  color: Color(0xFFBAC1CE),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0.10,
                ),
              ),
              Card(
                elevation: 0,
                color: Colors.transparent,
                // surfaceTintColor: Colors.transparent,
                child: SingleChildScrollView(
                    child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0), // Add desired padding
                        child: GoogleSignInButton(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16.0), // Add desired padding
                        child: FacebookSignInButton(),
                      )
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
