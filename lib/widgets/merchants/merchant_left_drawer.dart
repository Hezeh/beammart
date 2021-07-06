import 'package:beammart/widgets/merchants/merchant_menu_list.dart';
import 'package:flutter/material.dart';

class LeftDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          MenuListTileWidget(),
        ],
      ),
    );
  }
}
