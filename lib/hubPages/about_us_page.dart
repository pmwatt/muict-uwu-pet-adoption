import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({
    super.key,
    required this.textStyleH1,
    required this.textStyleH2,
  });

  final TextStyle textStyleH1;
  final TextStyle textStyleH2;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'About Us',
          style: textStyleH1,
          textAlign: TextAlign.center,
        ),
        Text(
            '6488038 Kanyavee Likitwattanakij\n6488053 Krittanai Peanjaroen\n6488160 Prachnachai Meakpaiboonwattana\n6488221 Thai Mekratanavorakul')
      ],
    );
  }
}
