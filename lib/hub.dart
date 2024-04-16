import 'package:flutter/material.dart';
import 'hubPages/chatbot_page.dart';
import 'hubPages/about_us_page.dart';
import 'hubPages/search_page.dart';
import 'hubPages/setting_page.dart';

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

  static final List<Widget> _widgetOptions = <Widget>[
    const SearchPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
    const ChatbotPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
    const AboutUsPage(
      textStyleH1: textStyleH1,
      textStyleH2: textStyleH2,
    ),
    const SettingsPage(
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
      // search / chatbot / aboutus / setting page
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: navBarBottom(),
    );
  }

  BottomNavigationBar navBarBottom() {
    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return BottomNavigationBar(
      // reference, albeit this uses navigation rail:
      // https://codelabs.developers.google.com/codelabs/flutter-codelab-first#6
      currentIndex: _selectedIndex,
      onTap: onItemTapped,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
        ),
      ],
    );
  }
}
