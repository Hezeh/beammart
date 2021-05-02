import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileWidget extends StatelessWidget {
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'customer.success@beammart.app',
      queryParameters: {'subject': 'Feedback'});

  final String _privacyPolicyUrl = 'https://policies.beammart.app';
  final String _merchantsAppUrl =
      'https://play.google.com/store/apps/details?id=com.beammart.merchants';
  final String _appUrl =
      'https://play.google.com/store/apps/details?id=com.beammart.beammart';

  void _lauchHelpFeedback() async => await canLaunch(_emailLaunchUri.toString())
      ? await launch(_emailLaunchUri.toString())
      : throw 'Could not launch $_emailLaunchUri';

  void _launchUrl(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    final _currentUser = _authProvider.user;
    return ListView(
      children: [
        // ListTile(
        //   title: Text("User Name"),
        //   trailing: Icon(Icons.edit_outlined),
        // ),
        InkWell(
          onTap: () {
            _lauchHelpFeedback();
          },
          child: ListTile(
            title: Text("Help & Feedback"),
            trailing: Icon(
              Icons.contact_support_outlined,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _launchUrl(_privacyPolicyUrl);
          },
          child: ListTile(
            title: Text("Privacy & Data Policy"),
            trailing: Icon(Icons.policy_outlined),
          ),
        ),
        InkWell(
          onTap: () {
            Share.share(
              'Get the Beammart App and discover products sold nearby: https://bit.ly/beammart',
            );
          },
          child: ListTile(
            title: Text("Share"),
            trailing: Icon(
              Icons.share_outlined,
            ),
          ),
        ),

        InkWell(
          onTap: () {
            _launchUrl(_appUrl);
          },
          child: ListTile(
            title: Text("Rate & Review"),
            trailing: Icon(
              Icons.rate_review_outlined,
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 300, height: 40),
            child: ElevatedButton(
              onPressed: () {
                _launchUrl(_merchantsAppUrl);
              },
              child: Text(
                'List your products',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        (_currentUser != null)
            ? InkWell(
                onTap: () {
                  // Log out
                  _authProvider.signOut();
                },
                child: ListTile(
                  title: Text("Logout"),
                  trailing: Icon(Icons.logout),
                ),
              )
            : Container(
                margin: EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 300, height: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(
                            showCloseIcon: true,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}
