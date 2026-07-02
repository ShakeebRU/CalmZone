import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../constants/constants.dart';
import '../providers/theme_provider.dart';
import '../services/test_service.dart';
import 'first_test_screen.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Hello! I\'m your mental health assistant. How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  int NUM_CLASSES = 110;
  late Interpreter interpreter;

  Future<void> loadModel() async {
    print("Loading model...");
    try {
      interpreter = await Interpreter.fromAsset(
        'assets/chat/chatbot_model.tflite',
      );

      print("Input shape: ${interpreter.getInputTensor(0).shape}");
      print("Output shape: ${interpreter.getOutputTensor(0).shape}");
      print("Model loaded successfully");
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Map<String, int> tokenizer = {};
  List<dynamic> labels = [];

  Future<void> loadLabels() async {
    final jsonString = await rootBundle.loadString(
      'assets/chat/label_encoder.json',
    );

    labels = json.decode(jsonString);
  }

  Map intents = {};

  Future<void> loadIntents() async {
    final jsonString = await rootBundle.loadString('assets/chat/intents.json');

    intents = json.decode(jsonString);
  }

  Future<void> loadTokenizer() async {
    final jsonString = await rootBundle.loadString(
      'assets/chat/tokenizer.json',
    );

    final jsonData = json.decode(jsonString);

    tokenizer = Map<String, int>.from(jsonData["word_index"]);
  }

  int MAX_LENGTH = 40;
  List<int> textToSequence(String text) {
    text = text.toLowerCase();

    List<String> words = text.split(RegExp(r"\s+"));

    List<int> sequence = [];

    for (String word in words) {
      sequence.add(tokenizer[word] ?? 0);
    }

    while (sequence.length < MAX_LENGTH) {
      sequence.add(0);
    }

    if (sequence.length > MAX_LENGTH) {
      sequence = sequence.sublist(0, MAX_LENGTH);
    }

    return sequence;
  }

  Future<String> sendMessage(String message) async {
    // 1. Clean the text
    message = message.toLowerCase();

    // 2. Convert to sequence using the tokenizer vocabulary
    List<int> sequence = textToSequence(message);

    // 3. Pad to length 20
    while (sequence.length < 20) {
      sequence.add(0);
    }
    if (sequence.length > 20) {
      sequence = sequence.sublist(0, 20);
    }

    // 4. Prepare input
    var input = [sequence];

    // 5. Prepare output (must match model)
    var output = List.generate(1, (_) => List.filled(NUM_CLASSES, 0.0));

    // 6. Run inference
    interpreter.run(input, output);

    // 7. Find predicted class
    int predictedIndex = output[0].indexOf(
      output[0].reduce((a, b) => a > b ? a : b),
    );

    // 8. Convert index -> tag
    String tag = labels[predictedIndex];

    // 9. Get a response for that tag
    return getResponse(tag);
  }

  String getResponse(String tag) {
    final intent = intents["intents"].firstWhere(
      (item) => item["tag"] == tag,
      orElse: () => null,
    );

    if (intent == null) {
      return "Sorry, I didn't understand.";
    }

    List responses = intent["responses"];

    return responses[Random().nextInt(responses.length)];
  }

  Future<void> initialize() async {
    await loadModel();

    await loadTokenizer();

    await loadLabels();

    await loadIntents();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleLoad();
  }

  Future<void> handleLoad() async {
    await _checkMentalTest();

    await loadResult();

    await initialize();
  }

  Future<void> _checkMentalTest() async {
    final shouldTake = await TestStorage.shouldTakeTest();

    if (!shouldTake) return;

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalmZoneTestScreen()),
    );
  }

  double mentalPercentage = 0;
  String severity = "";
  Future<void> loadResult() async {
    mentalPercentage = await TestStorage.getPercentage();
    severity = await TestStorage.getSeverity();

    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    String userMessage = _messageController.text;

    String botReply = await sendMessage(userMessage);
    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(text: botReply, isUser: false, timestamp: DateTime.now()),
      );
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.getBackgroundColor(isDark),
        appBar: AppBar(
          backgroundColor: Constants.getSurfaceColor(isDark),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Constants.getTextColor(isDark)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                "Level\n$severity",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Constants.getTextColor(isDark),
                ),
              ),
            ),
          ],
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Constants.accentColor, Constants.secondaryColor2],
                  ),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Assistant',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.getTextColor(isDark),
                    ),
                  ),
                  Text(
                    'Online',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Constants.successColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index], isDark);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constants.getSurfaceColor(isDark),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.outfit(
                        color: Constants.getTextColor(isDark),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: GoogleFonts.outfit(
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                        filled: true,
                        fillColor: Constants.getInputBackgroundColor(isDark),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Constants.getBorderColor(isDark),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Constants.accentColor,
                          Constants.secondaryColor2,
                        ],
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? Constants.accentColor
              : Constants.getSurfaceColor(isDark),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 0),
            bottomRight: Radius.circular(message.isUser ? 0 : 16),
          ),
        ),
        child: Text(
          message.text,
          style: GoogleFonts.outfit(
            color: message.isUser
                ? Colors.white
                : Constants.getTextColor(isDark),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
