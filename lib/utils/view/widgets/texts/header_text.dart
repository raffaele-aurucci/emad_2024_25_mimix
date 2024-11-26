import 'package:flutter/material.dart';

// aggiungere costanti per la definizione della size del font

class HeaderText extends StatelessWidget {

  static const double H3 = 32; // For page header
  static const double H4 = 24; // For page sub-header

  final String text;
  final double size;

  const HeaderText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF003659),
      ),
    );
  }
}

//  CREATION EXAMPLE
//  HeaderText(text: 'title', size: CardTitleText.H3),

// This snippet of code creates a header text. You can choose between two types of text: H3 and H4.