import 'package:beammart/models/profile.dart';
import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/profile_provider.dart';
import 'package:beammart/screens/merchants/contacts_screen.dart';
import 'package:beammart/screens/merchants/merchant_all_chats_screen.dart';
import 'package:beammart/screens/merchants/merchant_analytics_screen.dart';
import 'package:beammart/screens/merchants/payments_subscriptions_screen.dart';
import 'package:beammart/screens/merchants/profile_screen.dart';
import 'package:beammart/screens/merchants/sms_marketing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuListTileWidget extends StatelessWidget {
  final _url =
      'https://play.google.com/store/apps/details?id=com.beammart.beammart';

  final double _fontSize = 15.0;

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'customer.success@beammart.app',
      queryParameters: {'subject': 'Feedback'});

  void _lauchEmail() async => await canLaunch(_emailLaunchUri.toString())
      ? await launch(_emailLaunchUri.toString())
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final currentUser = authProvider.user;
    final Profile? currentProfile =
        Provider.of<ProfileProvider>(context).profile;
    return Column(
      children: [
        (currentUser != null)
            ? Container(
                margin: EdgeInsets.all(20),
                child: Text("${currentUser.email}"),
              )
            : Container(),
        ListTile(
          leading: Icon(
            Icons.storefront_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Merchant Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  profile: currentProfile,
                ),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        ListTile(
          leading: Icon(
            Icons.chat_bubble_outline_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Chats',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MerchantAllChatsScreen(),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        ListTile(
          leading: Icon(
            Icons.analytics_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Analytics',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MerchantAnalyticsScreen(),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        ListTile(
          leading: Icon(
            Icons.payments_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Manage Subscriptions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PaymentsSubscriptionsScreen(),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        ListTile(
          leading: Icon(
            Icons.contacts_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Contacts',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ContactsScreen(),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        ListTile(
          leading: Icon(
            Icons.sms_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'SMS Marketing',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => SMSMarketingScreen(),
              ),
            );
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
        // ListTile(
        //   leading: Icon(
        //     Icons.share_outlined,
        //     color: Colors.pink,
        //   ),
        //   title: Text(
        //     'Share Merchant App',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 18.0,
        //     ),
        //   ),
        //   onTap: () {
        //     Share.share(
        //       'Get the Beammart Merchant App and let potential customers find your products for free: https://bit.ly/forMerchants',
        //     );
        //   },
        // ),
        // Divider(
        //   color: Colors.pink,
        //   indent: 10.0,
        //   endIndent: 10.0,
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.get_app_outlined,
        //     color: Colors.pink,
        //   ),
        //   title: Text(
        //     'Get Consumer App',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 18.0,
        //     ),
        //   ),
        //   onTap: () {
        //     _launchURL();
        //   },
        // ),
        // Divider(
        //   color: Colors.pink,
        //   indent: 10.0,
        //   endIndent: 10.0,
        // ),
        ListTile(
          leading: Icon(
            Icons.contact_support_outlined,
            color: Colors.pink,
          ),
          title: Text(
            'Help & Feedback',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
            ),
          ),
          onTap: () {
            _lauchEmail();
          },
        ),
        Divider(
          color: Colors.pink,
          indent: 10.0,
          endIndent: 10.0,
        ),
      ],
    );
  }
}
