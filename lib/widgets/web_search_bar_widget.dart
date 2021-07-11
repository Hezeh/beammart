import 'package:beammart/utils/search_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebSearchAppBarWidget extends StatelessWidget {
  const WebSearchAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => searchUtil(context),
      child: Container(
        width: 500,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(60),
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 100,
              ),
              child: Icon(
                Icons.search_outlined,
                size: 30,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              "What are you looking for?",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
