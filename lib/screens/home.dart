import 'package:beammart/providers/device_info_provider.dart';
import 'package:beammart/providers/location_provider.dart';
import 'package:beammart/widgets/explore_widget.dart';
import 'package:beammart/widgets/profile_widget.dart';
import 'package:beammart/widgets/wishlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      return WishlistWidget();
    }
    if (currentIndex == 2) {
      return ProfileWidget();
    }
    return ExploreWidget();
  }

  @override
  void initState() {
    super.initState();
    // Get current location
    Provider.of<LocationProvider>(context, listen: false).init();
    Provider.of<DeviceInfoProvider>(context, listen: false).onInit();
    // Provider.of<ConnectivityStatus>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Explore',
            icon: Icon(
              Icons.explore_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Wishlist',
            icon: Icon(
              Icons.favorite_outline_outlined,
            ),
          ),
          BottomNavigationBarItem(
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
