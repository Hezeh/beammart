import 'package:beammart/widgets/web_search_bar_widget.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? buildAppBar() {
  return AppBar(
    title: Text("Beammart"),
    actions: [
      WebSearchAppBarWidget(),
    ],
  );
}