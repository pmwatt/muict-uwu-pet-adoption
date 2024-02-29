import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

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
  final userInputController = TextEditingController();

  static final chat = GenerativeModel(
    model: 'gemini-pro',
    apiKey: dotenv.env['GOOGLE_API_KEY']!,
    safetySettings: [
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
    ],
  ).startChat(history: [
    Content.text(
        'You will act as a pet trainer assistant, named professor garfield, who are supporting users in raising their pets from the pet adoption centre. Please make sure to answer using friendly words.'),
    Content.model([
      TextPart(
          'Hi there, please feel free to let me know if you would like more information about how to take care of adopted pets, or any other questions.')
    ])
  ]);

  @override
  Widget build(BuildContext context) {
    // store user input

    final userInput = userInputController.text;
    String? response;

    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('images/drunkcat.jpg'),
            radius: 100,
          ),
          Center(child: Text('Professor Garfield')),
          if (userInput.isNotEmpty) ChatBox(word: userInput),
          // if (response != null) Reply(word: response!),
          FutureBuilder<String>(
            future: generateReply(), // Assign the future here
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Reply(word: snapshot.data!); // Access the response
              } else if (snapshot.hasError) {
                return Reply(word: 'Error: ${snapshot.error}'); // Handle error
              } else {
                return Center(
                    child: CircularProgressIndicator()); // Loading indicator
              }
            },
          ),
        ],
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(2),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: userInputController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                ),
                onEditingComplete: () async {
                  response = await generateReply();
                  setState(() {});
                },
              ),
            ),
            TextButton(
              onPressed: () async {
                setState(() {}); // Update UI after getting response
              },
              child: Text('Ask'),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> generateReply() async {
    // Get user input from text field controller
    final userInput = userInputController.text;
    final Content content;
    if (userInput.isEmpty) {
      content = Content.text("Make a short 20-30 words joke.");
    } else {
      content = Content.text(userInput);
    }
    final response = await chat.sendMessage(content);
    print("response.text: ${response.text}");
    return response.text!;
  }
}

class ChatBox extends StatelessWidget {
  ChatBox({Key? key, required this.word}) : super(key: key);

  final String word;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(word),
                ],
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
    );
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
                softWrap: true,
              ),
            ),
            color: Color.fromARGB(255, 172, 92, 92),
          )
        ]));
  }
}
