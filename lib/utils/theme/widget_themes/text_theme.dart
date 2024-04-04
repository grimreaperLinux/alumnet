import 'package:alumnet/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline2: GoogleFonts.montserrat(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline3: GoogleFonts.montserrat(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline4: GoogleFonts.montserrat(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline5: GoogleFonts.montserrat(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: tDarkColor),
    headline6: GoogleFonts.montserrat(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: tDarkColor),
    bodyText1: GoogleFonts.poppins(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: tDarkColor),
    bodyText2: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: tDarkColor),
  );

  static TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.montserrat(
        fontSize: 28.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline2: GoogleFonts.montserrat(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline3: GoogleFonts.montserrat(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline4: GoogleFonts.montserrat(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline5: GoogleFonts.montserrat(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    headline6: GoogleFonts.montserrat(
        fontSize: 14.0, fontWeight: FontWeight.bold, color: tWhiteColor),
    bodyText1: GoogleFonts.poppins(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: tWhiteColor),
    bodyText2: GoogleFonts.poppins(
        fontSize: 14.0, fontWeight: FontWeight.normal, color: tWhiteColor),
  );
}
