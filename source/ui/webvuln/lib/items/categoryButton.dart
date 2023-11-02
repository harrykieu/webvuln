import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class categoryButton extends StatefulWidget {
  const categoryButton({super.key});

  @override
  State<categoryButton> createState() => _categoryButtonState();
}

class _categoryButtonState extends State<categoryButton> {
  @override
  Color colorButton = Color(0xFF78D6C6);
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [button(), button()],
      ),
    );
  }
}

class button extends StatefulWidget {
  const button({super.key});

  @override
  State<button> createState() => _buttonState();
}

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    Color colorButton = Color(0xFFD9D9D9);
    return Container(
      width: 150,
      height: 50,
      margin: EdgeInsetsDirectional.symmetric(horizontal: 10),
      // padding: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: (){}, 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.error,
              color: Colors.black,
            ),
            Text(
              'XSS error',
              style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )),
    );
  }
}
