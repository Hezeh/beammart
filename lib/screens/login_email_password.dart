import 'package:beammart/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginEmailPasswordScreen extends StatefulWidget {
  @override
  _LoginEmailPasswordScreenState createState() =>
      _LoginEmailPasswordScreenState();
}

class _LoginEmailPasswordScreenState extends State<LoginEmailPasswordScreen> {
  bool? _enabled = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _loginEmailPasswordFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Form(
          key: _loginEmailPasswordFormKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  controller: _emailController,
                  enabled: _enabled,
                  autocorrect: true,
                  enableSuggestions: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter and email";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                // padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  enabled: _enabled,
                  controller: _passwordController,
                  autocorrect: true,
                  enableSuggestions: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          height: 40,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () async {
                            if (_loginEmailPasswordFormKey.currentState!
                                .validate()) {
                              setState(() {
                                _enabled = false;
                              });
                              final String _message = await _authProvider
                                  .createUserWithEmailPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                              print(_message);
                              if (_message == 'Successful SignUp') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Successfully Signed Up",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );

                                Navigator.of(context).pop();
                              } else if (_message == 'invalid-email') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Invalid Email",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'email-already-in-use') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Email already in use. Try Signing In.",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'weak-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Weak Password.",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'operation-not-allowed') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Operation Not Allowed",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _enabled = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.pink,
                            onPrimary: Colors.white,
                            elevation: 16,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                          width: 100,
                          height: 40,
                        ),
                        child: ElevatedButton(
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () async {
                            if (_loginEmailPasswordFormKey.currentState!
                                .validate()) {
                              setState(() {
                                _enabled = false;
                              });
                              final String _message =
                                  await _authProvider.signInWithEmailPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (_message == 'Successful SignIn') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Successful Sign In",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                                // Navigator.of(context)
                                //     .popUntil(ModalRoute.withName('/home'));
                                Navigator.of(context).pop();
                              } else if (_message == 'invalid-email') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Invalid Email",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Wrong Password",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'user-disabled') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "User Disabled",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (_message == 'user-not-found') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "User Not Found. Try Signing Up.",
                                      style: GoogleFonts.gelasio(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              setState(() {
                                _enabled = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            elevation: 16,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
