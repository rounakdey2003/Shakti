import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;
  String _reservedWords = "help";

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _confidenceLevel = 0;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;

      if (_wordsSpoken.contains("help")) {
        // Show a notification on the screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.pink ,content: Text('SOS',style: TextStyle(fontSize: 40),)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: double.infinity,
    width: double.infinity,
    color: Color.fromRGBO(32, 25, 55, 1.0),
    child: Container(
    height: 865,
    width: 450,
    decoration: BoxDecoration(
    image: DecorationImage(
    fit: BoxFit.fill,
    image: AssetImage('assets/image/rosePetal.png'))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Words Spoken:',
              ),
              Text(
                '$_wordsSpoken',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'Confidence Level:',
              ),
              Text(
                '$_confidenceLevel',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechEnabled ? _startListening : null,
        tooltip: 'Start Listening',
        child: const Icon(Icons.mic),
      ),
    );
  }
}
