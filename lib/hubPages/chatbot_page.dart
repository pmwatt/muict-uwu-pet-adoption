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
      // sometimes questions related to raising pets may be considered too sensitive
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
    ],
  ).startChat(history: [
    Content.text(
        '''You are a pet trainer assistant chatbot, named professor garfield,
      who is providing detailed and easy-to-understand pet-raising advices from a pet adoption centre.
      The following are your tasks:
      - your answers should be easily understood by a middle school student who have never raised pets before
      - in case if users ask questions not related to pets, animals, foods, or similar domain, you will reply that
      you recommend asking experts in those field. make sure that you only provide advices related to your specialties i.e. pets.
      for example, if user asks "write hello world in c++", which is not related to pets or foods, you will reply
      "Sorry, this question is outside the scope of my domain. Please consult respective experts in <user's question topic>. I am able to provide advices on how to take care of pets and our site's adoption centres."
      - in case if users say that they can no longer raise their pets because of circumstances, finance, etc.
      you can recommend them to contact one of the adoption centre so that they can take care of
      their pets
      '''),
    Content.model([
      TextPart(
          'Hi there, please feel free to let me know if you would like more information about how to take care of adopted pets, or any other questions.')
    ])
  ]);

  @override
  Widget build(BuildContext context) {
    final userInput = userInputController.text;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 100),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('images/drunkcat.jpg'),
                radius: 100,
              ),
              Center(
                child: Text(
                  'Professor Garfield',
                  style: widget.textStyleH1,
                ),
              ),
              if (userInput.isNotEmpty)
                ChatBox(word: userInput)
              else
                const SizedBox.shrink(),
              FutureBuilder<String>(
                future: fetchChatbotAnswer(),
                builder: getReply,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        alignment: Alignment.bottomCenter,
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
                onEditingComplete: () {
                  setState(() {});
                },
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Ask'),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReply(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Reply(txt: 'Error: ${snapshot.error}');
    } else if (snapshot.hasData) {
      // good
      return Reply(txt: snapshot.data!);
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<String> fetchChatbotAnswer() async {
    // Get user input from text field controller
    final userInput = userInputController.text;
    final Content content;
    if (userInput.isEmpty) {
      content = Content.text(
          '''Make a short 15-25 words greetings as a pet adoption centre assistant.''');
    } else {
      content = Content.text(userInput);
    }
    final response = await chat.sendMessage(content);
    // print("response.text: ${response.text}");
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
        mainAxisAlignment: MainAxisAlignment.center,
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
  Reply({Key? key, required this.txt}) : super(key: key);

  final String txt;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 2, 20, 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            children: [
              Card(
                child: Container(
                  width: 500,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    txt,
                    style: TextStyle(color: Colors.white),
                    softWrap: true,
                  ),
                ),
                color: Color.fromARGB(255, 172, 92, 92),
              ),
            ],
          )
        ]));
  }
}
