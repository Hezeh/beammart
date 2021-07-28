import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/screens/arguments/item_named_screen_arguments.dart';
import 'package:beammart/screens/arguments/shop_named_screen_arguments.dart';
import 'package:beammart/screens/chat_screen.dart';
import 'package:beammart/widgets/all_chats_widget.dart';
import 'package:beammart/widgets/categories.dart';
import 'package:beammart/widgets/explore_widget.dart';
import 'package:beammart/widgets/profile_widget.dart';
import 'package:beammart/widgets/wishlist_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody({int currentIndex = 0}) {
    if (currentIndex == 1) {
      return Categories();
    }
    if (currentIndex == 2) {
      return WishlistWidget();
    }
    if (currentIndex == 3) {
      return AllChatsWidget();
    }
    if (currentIndex == 4) {
      return ProfileWidget();
    }
    return ExploreWidget();
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    notificationsHandler(context);
    // Get current location
    // Provider.of<LocationProvider>(context, listen: false).init();
    Provider.of<DeviceInfoProvider>(context, listen: false).onInit();
    // Provider.of<ConnectivityStatus>(context);
  }

  void initDynamicLinks() async {
    print("Intializing Dynamic Links");
    FirebaseDynamicLinks.instance.onLink(onSuccess: (dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      print("First One");
      if (deepLink != null) {
        print("Dynamic Link is Not Null");
        final _deepLinkPath = deepLink.path;
        print("Link: $_deepLinkPath");
        if (_deepLinkPath == 'shop') {
          print("Opening in Shop");
          if (deepLink.hasQuery) {
            final _shopQueryParams = deepLink.queryParameters;
            final _shopId = _shopQueryParams['id'];
            final _shopName = _shopQueryParams['name'];
            final _shopRef = _shopQueryParams['ref'];
            Navigator.pushNamed(
              context,
              // _deepLinkPath,
              'shop',
              arguments: ShopNamedScreenArguments(
                shopId: _shopId,
                shopName: _shopName,
                shopRef: _shopRef,
              ),
            );
          }
        } else if (_deepLinkPath == 'item') {
          print("Opening in Item");
          if (deepLink.hasQuery) {
            final _itemQueryParams = deepLink.queryParameters;
            final _itemId = _itemQueryParams['id'];
            final _itemName = _itemQueryParams['title'];
            final _shopId = _itemQueryParams['shop_id'];
            final _itemRef = _itemQueryParams['ref'];
            Navigator.pushNamed(
              context,
              // _deepLinkPath,
              'item',
              arguments: ItemNamedScreenArguments(
                itemId: _itemId,
                itemName: _itemName,
                shopId: _shopId,
                ref: _itemRef,
              ),
            );
          }
        }
      } else {
        print("No Link");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    print("Second One");

    if (deepLink != null) {
      print("Dynamic Link is Not Null");
      final _deepLinkPath = deepLink.path;
      print("Link: $_deepLinkPath");
      if (_deepLinkPath == 'shop') {
        print("Opening in Shop");
        if (deepLink.hasQuery) {
          final _shopQueryParams = deepLink.queryParameters;
          final _shopId = _shopQueryParams['id'];
          final _shopName = _shopQueryParams['name'];
          final _shopRef = _shopQueryParams['ref'];
          Navigator.pushNamed(
            context,
            _deepLinkPath,
            arguments: ShopNamedScreenArguments(
              shopId: _shopId,
              shopName: _shopName,
              shopRef: _shopRef,
            ),
          );
        }
      } else if (_deepLinkPath == 'item') {
        print("Opening in Item");
        if (deepLink.hasQuery) {
          final _itemQueryParams = deepLink.queryParameters;
          final _itemId = _itemQueryParams['id'];
          final _itemName = _itemQueryParams['title'];
          final _shopId = _itemQueryParams['shop_id'];
          final _itemRef = _itemQueryParams['ref'];
          Navigator.pushNamed(
            context,
            _deepLinkPath,
            arguments: ItemNamedScreenArguments(
              itemId: _itemId,
              itemName: _itemName,
              shopId: _shopId,
              ref: _itemRef,
            ),
          );
        }
      }
    } else {
      print("No Link");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.pink,
            label: 'Explore',
            icon: Icon(
              Icons.explore_outlined,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.teal,
            label: 'Categories',
            icon: Icon(
              Icons.category_outlined,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.cyan,
            label: 'Wishlist',
            icon: Icon(
              Icons.favorite_outline_outlined,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.purple,
            label: 'Chat',
            icon: Icon(
              Icons.chat_bubble_outline_outlined,
            ),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.more_horiz_outlined,
            ),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
      ),
      body: _buildBody(currentIndex: _selectedIndex),
    );
  }
}

Future<void> notificationsHandler(BuildContext context) async {
  String? token = await FirebaseMessaging.instance.getToken();

  // Save the initial token to the database
  await saveTokenToDatabase(token);

  // Any time the token refreshes, store this in the database too.
  FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);

  // Get any messages which caused the application to open from
  // a terminated state.
  // RemoteMessage? initialMessage =
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      if (message.data['type'] == 'chat') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              chatId: message.data['chatId'],
              businessName: message.data['businessName'],
              businessId: message.data['businessId'],
              consumerId: message.data['consumerId'],
            ),
          ),
        );
      }
    }
  });

  // print(initialMessage!.data);

  // // If the message also contains a data property with a "type" of "chat",
  // // navigate to a chat screen
  // if (initialMessage.data['type'] == 'chat') {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (_) => ChatScreen(
  //         chatId: initialMessage.data['chatId'],
  //         businessName: initialMessage.data['businessName'],
  //         businessId: initialMessage.data['businessId'],
  //         consumerId: initialMessage.data['consumerId'],
  //       ),
  //     ),
  //   );
  // }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      print(message.data);
      if (message.data['type'] == 'chat') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              chatId: message.data['chatId'],
              businessName: message.data['businessName'],
              businessId: message.data['businessId'],
              consumerId: message.data['consumerId'],
            ),
          ),
        );
      }
    },
  );
}

Future<void> saveTokenToDatabase(String? token) async {
  // Assume user is logged in for this example
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    await FirebaseFirestore.instance
        .collection('consumers')
        .doc(user.uid)
        .update({
      'notificationsTokens': FieldValue.arrayUnion([token]),
    });
  }
}
