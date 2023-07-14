import 'package:chatbot_frontend/config/routes.dart';
import 'package:chatbot_frontend/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot_frontend/helper/image_source_picker.dart';
import 'package:chatbot_frontend/helper/loading_widget.dart';
import 'package:chatbot_frontend/helper/text_extractor.dart';
import 'package:chatbot_frontend/providers/session_provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../custom_widgets/chat_box.dart';
import '../modals/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.isStory});

  final bool isStory;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isListening = false;
  bool isWaiting = false;
  bool isSpeaking = false;
  bool isExpanded = false;
  bool isGenerating = false;

  final FocusNode _focusNode = FocusNode();
  FlutterTts textToSpeech = FlutterTts();

  final TextEditingController controller = TextEditingController();

  speak(String text) async {
    await textToSpeech.setLanguage("en-Us");
    await textToSpeech.setPitch(1);
    await textToSpeech.speak(text);
  }

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();

    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    isListening = true;
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    isListening = false;
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      controller.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = (widget.isStory)
        ? context.watch<SessionProvider>().storyMessages.reversed.toList()
        : context.watch<SessionProvider>().messages.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.isStory ? Colors.purple : Colors.blue,
        title: Text(widget.isStory ? "StoryBot" : "Chatbot"),
        actions: [
          const Icon(
            Icons.record_voice_over,
          ),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
                value: isSpeaking,
                trackColor: Colors.blueGrey,
                onChanged: (value) {
                  isSpeaking = value;
                  setState(() {});
                }),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.isStory && messages.isEmpty)
            Flexible(child: Center(child: Text("Story Telling"))),
          if (messages.isNotEmpty || !widget.isStory)
            Flexible(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    padding: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    itemBuilder: (context, index) {
                      return ChatBox(
                        role: messages[index].role,
                        message: messages[index].content,
                      );
                    }),
              ),
            ),
          if (messages.isNotEmpty && messages.first.role == Role.assistant)
            GestureDetector(
              onTap: () async {
                if (!isGenerating) {
                  isGenerating = true;
                  setState(() {});
                  await context
                      .read<SessionProvider>()
                      .generatePDF(messages.first.content)
                      .then((value) {
                    isGenerating = false;
                    setState(() {});
                    if (value) {
                      Navigator.pushReplacementNamed(context, rProfile);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                        "Something went wrong! Please try again",
                      )));
                    }
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  (isGenerating) ? "Generating PDF" : "Generate PDF",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (isWaiting)
            Column(mainAxisSize: MainAxisSize.min, children: [
              const CircularProgressIndicator(),
              const Text("Waiting for Response..."),
              const SizedBox(
                height: 20,
              ),
            ]),
          if (!isWaiting)
            Container(
              height: 50,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: (widget.isStory) ? Colors.purple : Colors.blue,
              ),
              child: Row(children: [
                if (!isExpanded)
                  IconButton(
                    onPressed: () async {
                      await TextExtractor.fromFile().then((value) {
                        if (value != null) {
                          sendData(
                            context,
                            message: value,
                            isStory: widget.isStory,
                          );
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.file_copy,
                      color: Colors.white,
                    ),
                  ),
                if (!isExpanded)
                  IconButton(
                    onPressed: () async {
                      await showModalBottomSheet(
                              context: context,
                              builder: (context) => const ImageSourcePicker())
                          .then((value) async {
                        if (value != null) {
                          Loading.show(context);
                          setState(() {});
                          await TextExtractor.fromImage(value).then((value) {
                            Loading.dismiss(context);
                            setState(() {});
                            if (value != null) {
                              sendData(
                                context,
                                message: value,
                                isStory: widget.isStory,
                              );
                            }
                          });
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.white,
                    ),
                  ),
                if (isExpanded)
                  IconButton(
                    onPressed: () {
                      _focusNode.unfocus();
                      isExpanded = false;
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                Flexible(
                  child: Focus(
                    focusNode: _focusNode,
                    onFocusChange: (value) {
                      isExpanded = value;
                      setState(() {});
                    },
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: controller,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          isDense: true,
                          suffixIcon: AvatarGlow(
                            endRadius: 20.0,
                            animate: isListening,
                            curve: Curves.decelerate,
                            duration: const Duration(milliseconds: 1000),
                            repeatPauseDuration:
                                const Duration(milliseconds: 100),
                            repeat: true,
                            showTwoGlows: true,
                            glowColor: Colors.blueAccent,
                            child: GestureDetector(
                              onTap: _speechToText.isNotListening
                                  ? _startListening
                                  : _stopListening,
                              child: Icon(
                                isListening ? Icons.mic : Icons.mic_none,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          hintText: "Type a message...",
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Colors.blueGrey, width: 2),
                          )),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await sendData(
                      context,
                      message: controller.text,
                      isStory: widget.isStory,
                    ).then((value) {
                      if (isSpeaking) {
                        speak(messages.first.content);
                      }
                    });
                    controller.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ]),
            )
        ],
      ),
    );
  }

  sendData(BuildContext context,
      {required String message, required bool isStory}) async {
    final provider = context.read<SessionProvider>();
    isWaiting = true;
    setState(() {});
    if (isStory) {
      await provider.getStory(message);
    } else {
      await provider.getReply(message);
    }

    setState(() {
      isWaiting = false;
    });
  }
}
