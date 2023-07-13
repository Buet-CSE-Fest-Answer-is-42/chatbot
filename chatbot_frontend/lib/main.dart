import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "I am listening";
  bool isListening = false;

  SpeechToText speech = SpeechToText();
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatbot"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Text(index.toString());
                }),
          ),
          Container(
            color: Colors.blue,
            child: Row(children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
              ),
              Flexible(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              AvatarGlow(
                  endRadius: 20.0,
                  animate: isListening,
                  curve: Curves.decelerate,
                  duration: const Duration(milliseconds: 1000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  showTwoGlows: true,
                  child: GestureDetector(
                    onTap: () async {
                      if (!isListening) {
                        var available = await speech.initialize();
                        if (available) {
                          isListening = true;
                          speech.listen(onResult: (val) {
                            controller.text = val.recognizedWords;
                            setState(() {});
                          });
                        }
                      } else {
                        setState(() {
                          isListening = false;
                          speech.stop();
                        });
                      }
                    },
                    child: Icon(isListening ? Icons.mic : Icons.mic_none),
                  )),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
