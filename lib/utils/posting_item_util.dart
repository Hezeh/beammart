import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

postingItemErrorUtils(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        "😥 There is some error(s). Fix them and retry.",
        style: GoogleFonts.oswald(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}
