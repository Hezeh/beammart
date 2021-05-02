import 'package:beammart/widgets/google_sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final bool? showCloseIcon;

  const LoginScreen({Key? key, this.showCloseIcon}) : super(key: key);

  Widget _body(bool showCloseIcon, BuildContext context) {
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
          Center(
            heightFactor: 10,
            child: GoogleSignInButton(),
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
