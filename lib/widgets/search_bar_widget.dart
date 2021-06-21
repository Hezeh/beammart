import 'package:beammart/utils/search_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 100,
      borderRadius: BorderRadius.all(
        Radius.circular(60),
      ),
      child: InkWell(
        onTap: () => searchUtil(context),
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 50,
                ),
                child: Icon(
                  Icons.search_outlined,
                  size: 30,
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "What are you looking for?",
                style: GoogleFonts.roboto(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
