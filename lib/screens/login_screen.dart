import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/login_email_password.dart';
import 'package:beammart/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final bool? showCloseIcon;

  const LoginScreen({Key? key, this.showCloseIcon}) : super(key: key);

  Widget _body(bool showCloseIcon, BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent,
            Colors.purple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Column(
        children: [
          (showCloseIcon)
              ? Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      iconSize: 30,
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : Container(),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.5,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.only(
              top: 60,
              bottom: 30,
            ),
            child: Center(
              child: Text("Sign In to your account or create one",
                  style: GoogleFonts.gelasio(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              // heightFactor: 2,
              child: GoogleSignInButton(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Center(
              child: SignInButton(
                Buttons.FacebookNew,
                onPressed: () {
                  _authProvider.loginFacebook();
                },
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.all(15),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.only(
          //     top: 10,
          //     bottom: 10,
          //   ),
          //   child: Center(
          //     child: SignInButton(
          //       Buttons.Microsoft,
          //       onPressed: () {},
          //       elevation: 20,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(40),
          //       ),
          //       padding: EdgeInsets.all(15),
          //     ),
          //   ),
          // ),
          // Container(
          //   margin: EdgeInsets.only(
          //     top: 10,
          //     bottom: 10,
          //   ),
          //   child: Center(
          //     child: SignInButton(
          //       Buttons.Yahoo,
          //       onPressed: () {},
          //       elevation: 20,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(40),
          //       ),
          //       padding: EdgeInsets.all(15),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Center(
              child: SignInButton(
                Buttons.Email,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LoginEmailPasswordScreen(),
                    ),
                  );
                },
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.all(15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _body(showCloseIcon!, context),
      ),
    );
  }
}
