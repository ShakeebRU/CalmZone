import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../constants/constants.dart';
import '../providers/theme_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  String _detectedEmotion = 'Neutral';
  bool _isDetecting = false;
  bool _streamStarted = false;
  DateTime _lastDetection = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.medium,
        );
        await _controller!.initialize();
        await _controller!.startImageStream((image) {
          _processCameraImage();
        });
        if (mounted) {
          setState(() {
            _isInitialized = true;
            _streamStarted = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing camera: $e'),
            backgroundColor: Constants.errorColor,
          ),
        );
      }
    }
  }

  void _processCameraImage() {
    if (_isDetecting || !_streamStarted) return;
    final now = DateTime.now();
    // Simulate detection every ~1.5s
    if (now.difference(_lastDetection).inMilliseconds < 1500) return;

    _isDetecting = true;
    _lastDetection = now;

    Future.delayed(const Duration(milliseconds: 800), () {
      final emotions = ['Happy', 'Sad', 'Angry', 'Neutral', 'Surprised', 'Fear'];
      final randomEmotion = emotions[now.millisecond % emotions.length];
      if (mounted) {
        setState(() {
          _detectedEmotion = randomEmotion;
          _isDetecting = false;
        });
      } else {
        _isDetecting = false;
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Constants.getBackgroundColor(isDark),
      appBar: AppBar(
        backgroundColor: Constants.getSurfaceColor(isDark),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Constants.getTextColor(isDark),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Emotion Detection',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Constants.getTextColor(isDark),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isInitialized && _controller != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_controller!),
                      // Overlay grid
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constants.accentColor.withOpacity(0.5),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: 250,
                        height: 250,
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Constants.accentColor,
                      ),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
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
            child: Column(
              children: [
                // Detected Emotion Display
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Constants.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Constants.accentColor.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getEmotionIcon(_detectedEmotion),
                        size: 48,
                        color: Constants.accentColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Detected Emotion',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: Constants.getTextSecondaryColor(isDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _detectedEmotion,
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Constants.getTextColor(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Live status
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _isDetecting ? Constants.accentColor : Constants.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isDetecting ? 'Analyzing in real time...' : 'Live detection active',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Constants.getTextColor(isDark),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'surprised':
        return Icons.sentiment_satisfied_alt;
      case 'fear':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }
}

