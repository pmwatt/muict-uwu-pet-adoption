import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({
    super.key,
    required this.textStyleH1,
    required this.textStyleH2,
  });

  final TextStyle textStyleH1;
  final TextStyle textStyleH2;

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(shrinkWrap: true, children: <Widget>[
        Container(
            child: CircleAvatar(
              backgroundImage: AssetImage('images/drunkcat.jpg'),
              radius: 100,
            ),
            padding: EdgeInsets.all(5)),
        Center(child: Text('Pet Guru')),
        Reply(word: 'Greeting! How can I help you today?'),
        ChatBox(word: 'How do I take care of pet rock?'),
        Reply(
            word:
                'Great question! Here are some simple steps you can follow:\n 1.Keep your pet rock clean\n 2.Keep your pet rock dry\n 3.Give your pet rock a comfortable home\n 4.Play with your pet rock\n 5.Protect your pet rock'),
        ChatBox(word: 'Thanks!')
      ]),
      bottomSheet: Container(
          padding: EdgeInsets.all(2),
          height: 50,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text('type something ', style: TextStyle(color: Colors.grey)),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(255, 100, 50, 50)),
              ),
              child: Text('Ask', style: TextStyle(color: Colors.white)),
              onPressed: null,
            )
          ])),
    );
  }
}

class ChatBox extends StatelessWidget {
  ChatBox({Key? key, required this.word}) : super(key: key);

  final String word;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Card(
            child: Container(padding: EdgeInsets.all(10), child: Text(word)),
            color: Colors.white,
          ),
        ]));
  }
}

class Reply extends StatelessWidget {
  Reply({Key? key, required this.word}) : super(key: key);

  final String word;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                word,
                style: TextStyle(color: Colors.white),
              ),
            ),
            color: Color.fromARGB(255, 172, 92, 92),
          )
        ]));
  }
}
