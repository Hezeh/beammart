import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/theme_provider.dart';
import 'package:beammart/screens/consumer_address_screen.dart';
import 'package:beammart/screens/consumer_orders.dart';
import 'package:beammart/screens/merchants/merchants_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileWidget extends StatefulWidget {
  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'customer.success@beammart.app',
    queryParameters: {
      'subject': 'Feedback',
    },
  );

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
    final _themeProvider = Provider.of<ThemeProvider>(context);
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 300, height: 40),
            child: ElevatedButton(
              onPressed: () {
                // _launchUrl(_merchantsAppUrl);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MerchantHomeScreen(),
                  ),
                );
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
        (_currentUser != null)
            ? InkWell(
                onTap: () {
                  // Log out
                  _authProvider.signOut();
                },
                child: ListTile(
                  title: Text("Sign out"),
                  trailing: Icon(Icons.logout),
                ),
              )
            : SizedBox.shrink(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConsumerAddressScreen(),
              ),
            );
          },
          child: ListTile(
            title: Text("Delivery Address"),
            trailing: Icon(
              Icons.local_shipping,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ConsumerOrders(),
              ),
            );
          },
          child: ListTile(
            title: Text("Your Orders"),
            trailing: Icon(
              Icons.receipt_long_outlined,
            ),
          ),
        ),
        MergeSemantics(
          child: ListTile(
            title: Text("Dark Theme"),
            trailing: CupertinoSwitch(
              activeColor: Colors.pink,
              value: !_themeProvider.isLightTheme!,
              onChanged: (bool value) {
                _themeProvider.toggleThemeData();
              },
            ),
            onTap: () {
              _themeProvider.toggleThemeData();
            },
          ),
        ),
      ],
    );
  }
}
