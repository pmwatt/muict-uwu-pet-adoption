import 'package:flutter/material.dart';
import 'hubPages/homePage.dart';
import 'hubPages/chatbotPage.dart';
import 'hubPages/aboutusPage.dart';
import 'searchPage.dart';

class Hub extends StatefulWidget {
  const Hub({super.key});

  @override
  State<Hub> createState() => _HubState();
}

class _HubState extends State<Hub> {
  int _selectedIndex = 0;
  static const TextStyle textStyleH2 = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 170, 89, 89));

  static const TextStyle textStyleH1 = TextStyle(
      fontSize: 50,
      fontWeight: FontWeight.normal,
      color: Color.fromARGB(255, 100, 50, 50));

  static List<Widget> _widgetOptions = <Widget>[
    // HomePage(
    //   textStyleH1: textStyleH1,
    //   textStyleH2: textStyleH2,
    // ),
    SearchPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
    ChatbotPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
    AboutUsPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UWU', style: textStyleH2),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavBarBottom(),
    );
  }

  BottomNavigationBar NavBarBottom() {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_rounded),
          label: 'Chatbot Trainer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.question_mark_rounded),
          label: 'About Us',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
