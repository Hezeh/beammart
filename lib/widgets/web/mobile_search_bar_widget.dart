import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MobileSearchBarWidget extends StatelessWidget {
  const MobileSearchBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      decoration: BoxDecoration(  
        color: Colors.pink,
        borderRadius: BorderRadius.circular(20)
      ),
      height: 200,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
            ),
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: TextField(
              autofocus: true,
              showCursor: true,
              cursorColor: Colors.pink,
              onChanged: (value) {
                // do something
              },
              enableInteractiveSelection: true,
              enabled: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                hintText: 'Laptop, iPhone',
                suffixIcon: Icon(
                  Icons.search_outlined,
                  color: Colors.black,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: Text(
                    "Search",
                    style: GoogleFonts.gelasio(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            padding: EdgeInsets.all(10),
            color: Colors.white,
            // height: 100,
            child: TextField(
              autofocus: true,
              showCursor: true,
              cursorColor: Colors.pink,
              onChanged: (value) {
                // do something
              },
              enableInteractiveSelection: true,
              enabled: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                hintText: 'Mountain View',
                enabled: true,
                suffixIcon: Icon(
                  Icons.place_outlined,
                  color: Colors.black,
                ),
                prefixIcon: Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                    // bottom: 1,
                  ),
                  child: Text(
                    "Nearby",
                    style: GoogleFonts.gelasio(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
