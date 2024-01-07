import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'text_themes.dart';

class AppTheme {
  // Light theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
      // accentColor: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.white)
      ),
      buttonTheme:const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
  );

  // Dark theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.normal,color: Colors.black)
    ),
    // fontFamily: 'Quicksand',
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 9, 64, 172),
  );
}
