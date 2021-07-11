import 'package:beammart/providers/auth_provider.dart';
import 'package:beammart/providers/theme_provider.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/screens/login_screen.dart';
import 'package:beammart/widgets/web_app_bar.dart';
import 'package:beammart/widgets/web_map_widget.dart';
import 'package:beammart/widgets/web_more_from_this_merchant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class WebItemDetailScreen extends StatefulWidget {
  final String? itemId;
  final List<String>? imageUrl;
  final int? price;
  final String? itemTitle;
  final String? description;
  final LatLng? currentLocation;
  final LatLng? merchantLocation;
  final double? distance;
  final String? merchantName;
  final String? merchantId;
  final String? merchantDescription;
  final String? dateJoined;
  final String? merchantPhotoUrl;
  final String? phoneNumber;
  final String? locationDescription;
  final bool? isMondayOpen;
  final bool? isTuesdayOpen;
  final bool? isWednesdayOpen;
  final bool? isThursdayOpen;
  final bool? isFridayOpen;
  final bool? isSaturdayOpen;
  final bool? isSundayOpen;
  final String? mondayOpeningTime;
  final String? mondayClosingTime;
  final String? tuesdayOpeningTime;
  final String? tuesdayClosingTime;
  final String? wednesdayOpeningTime;
  final String? wednesdayClosingTime;
  final String? thursdayOpeningTime;
  final String? thursdayClosingTime;
  final String? fridayOpeningTime;
  final String? fridayClosingTime;
  final String? saturdayOpeningTime;
  final String? saturdayClosingTime;
  final String? sundayOpeningTime;
  final String? sundayClosingTime;
  const WebItemDetailScreen({
    Key? key,
    this.itemId,
    this.imageUrl,
    this.price,
    this.itemTitle,
    this.description,
    this.currentLocation,
    this.merchantLocation,
    this.distance,
    this.merchantName,
    this.merchantId,
    this.merchantDescription,
    this.dateJoined,
    this.merchantPhotoUrl,
    this.phoneNumber,
    this.locationDescription,
    this.isMondayOpen,
    this.isTuesdayOpen,
    this.isWednesdayOpen,
    this.isThursdayOpen,
    this.isFridayOpen,
    this.isSaturdayOpen,
    this.isSundayOpen,
    this.mondayOpeningTime,
    this.mondayClosingTime,
    this.tuesdayOpeningTime,
    this.tuesdayClosingTime,
    this.wednesdayOpeningTime,
    this.wednesdayClosingTime,
    this.thursdayOpeningTime,
    this.thursdayClosingTime,
    this.fridayOpeningTime,
    this.fridayClosingTime,
    this.saturdayOpeningTime,
    this.saturdayClosingTime,
    this.sundayOpeningTime,
    this.sundayClosingTime,
  }) : super(key: key);

  @override
  State<WebItemDetailScreen> createState() => _WebItemDetailScreenState();
}

class _WebItemDetailScreenState extends State<WebItemDetailScreen> {
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _authProvider = Provider.of<AuthenticationProvider>(context);
    final _themeProvider = Provider.of<ThemeProvider>(context);
    String? chatId;
    getChatId() async {
      if (_authProvider.user != null) {
        final _chatSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .where(
              'consumerId',
              isEqualTo: _authProvider.user!.uid,
            )
            .where(
              'businessId',
              isEqualTo: widget.merchantId,
            )
            .get();
        if (_chatSnapshot.docs.isNotEmpty) {
          chatId = _chatSnapshot.docs.first.id;
        }
      } else {
        chatId = _uuid.v4();
      }
    }

    getChatId();
    return Scaffold(
      appBar: buildAppBar(),
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Item Images in a GridView,
              Expanded(
                child: Container(
                  // height: 600,
                  // width: 600,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 350,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: widget.imageUrl!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            widget.imageUrl![index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Item Details
              Expanded(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Card(
                      child: ListTile(
                        title: Text("${widget.itemTitle}"),
                        subtitle: Text("${widget.description}"),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: (widget.merchantPhotoUrl != null)
                            ? CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink,
                                child: Image.network(widget.merchantPhotoUrl!),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.pink,
                                child: Icon(
                                  Icons.storefront_outlined,
                                ),
                              ),
                        title: Text("${widget.merchantName}"),
                        subtitle: Text("${widget.merchantDescription}"),
                      ),
                    ),

                    Card(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          (widget.phoneNumber != null)
                              ? Container(
                                  margin: EdgeInsets.all(10),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 200,
                                    ),
                                    child: ElevatedButton.icon(
                                      icon: Icon(Icons.call_outlined),
                                      onPressed: () {
                                        _makePhoneCall(
                                            'tel:${widget.phoneNumber}');
                                      },
                                      label: Text('Call'),
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 200,
                              ),
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.chat_bubble_outline_outlined,
                                ),
                                onPressed: () {
                                  if (_authProvider.user != null) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                          chatId: chatId,
                                          businessName: widget.merchantName,
                                          businessId: widget.merchantId,
                                          businessPhotoUrl:
                                              widget.merchantPhotoUrl,
                                          consumerDisplayName:
                                              _authProvider.user!.displayName,
                                          consumerId: _authProvider.user!.uid,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => LoginScreen(
                                          showCloseIcon: true,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                label: Text("Chat"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //  WebMapWidget(
                    //   merchantLocation: widget.merchantLocation,
                    //   merchantName: widget.merchantName,
                    // ),
                    Card(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String googleUrl =
                              'https://www.google.com/maps/dir/?api=1&destination=${widget.merchantLocation!.latitude},${widget.merchantLocation!.longitude}';
                          if (await canLaunch(googleUrl)) {
                            await launch(googleUrl);
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        icon: Icon(
                          Icons.directions_outlined,
                        ),
                        label: Text("Open in Google Maps"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: Center(
                        child: Text(
                          "More from this merchant",
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    WebMoreFromThisMerchant(
                      merchantId: widget.merchantId!,
                      itemId: widget.itemId!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
