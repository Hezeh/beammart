import 'package:beammart/enums/size.dart';
import 'package:beammart/widgets/web/desktop_search_bar_widget.dart';
import 'package:beammart/widgets/web/mobile_search_bar_widget.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScreenType _screenType = getFormFactor(context);
    if (_screenType == ScreenType.Handset) {
      return MobileSearchBarWidget();
    }
    return DesktopSearchBarWidget();
  }
}
