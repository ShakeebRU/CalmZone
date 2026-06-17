// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:camera/camera.dart';
// import '../constants/constants.dart';
// import '../providers/theme_provider.dart';

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController? _controller;
//   List<CameraDescription>? _cameras;
//   bool _isInitialized = false;
//   String _detectedEmotion = 'Neutral';
//   bool _isDetecting = false;
//   bool _streamStarted = false;
//   DateTime _lastDetection = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     try {
//       _cameras = await availableCameras();
//       if (_cameras != null && _cameras!.isNotEmpty) {
//         _controller = CameraController(
//           _cameras![0],
//           ResolutionPreset.medium,
//         );
//         await _controller!.initialize();
//         await _controller!.startImageStream((image) {
//           _processCameraImage();
//         });
//         if (mounted) {
//           setState(() {
//             _isInitialized = true;
//             _streamStarted = true;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error initializing camera: $e'),
//             backgroundColor: Constants.errorColor,
//           ),
//         );
//       }
//     }
//   }

//   void _processCameraImage() {
//     if (_isDetecting || !_streamStarted) return;
//     final now = DateTime.now();
//     // Simulate detection every ~1.5s
//     if (now.difference(_lastDetection).inMilliseconds < 1500) return;

//     _isDetecting = true;
//     _lastDetection = now;

//     Future.delayed(const Duration(milliseconds: 800), () {
//       final emotions = ['Happy', 'Sad', 'Angry', 'Neutral', 'Surprised', 'Fear'];
//       final randomEmotion = emotions[now.millisecond % emotions.length];
//       if (mounted) {
//         setState(() {
//           _detectedEmotion = randomEmotion;
//           _isDetecting = false;
//         });
//       } else {
//         _isDetecting = false;
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final isDark = themeProvider.isDarkMode;

//     return Scaffold(
//       backgroundColor: Constants.getBackgroundColor(isDark),
//       appBar: AppBar(
//         backgroundColor: Constants.getSurfaceColor(isDark),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Constants.getTextColor(isDark),
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Emotion Detection',
//           style: GoogleFonts.outfit(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Constants.getTextColor(isDark),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _isInitialized && _controller != null
//                 ? Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       CameraPreview(_controller!),
//                       // Overlay grid
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: Constants.accentColor.withOpacity(0.5),
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         width: 250,
//                         height: 250,
//                       ),
//                     ],
//                   )
//                 : Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         Constants.accentColor,
//                       ),
//                     ),
//                   ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(
//               color: Constants.getSurfaceColor(isDark),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Column(
//               children: [
//                 // Detected Emotion Display
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Constants.accentColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(
//                       color: Constants.accentColor.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Icon(
//                         _getEmotionIcon(_detectedEmotion),
//                         size: 48,
//                         color: Constants.accentColor,
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         'Detected Emotion',
//                         style: GoogleFonts.outfit(
//                           fontSize: 14,
//                           color: Constants.getTextSecondaryColor(isDark),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _detectedEmotion,
//                         style: GoogleFonts.outfit(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Constants.getTextColor(isDark),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // Live status
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 10,
//                       height: 10,
//                       decoration: BoxDecoration(
//                         color: _isDetecting ? Constants.accentColor : Constants.successColor,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       _isDetecting ? 'Analyzing in real time...' : 'Live detection active',
//                       style: GoogleFonts.outfit(
//                         fontSize: 14,
//                         color: Constants.getTextColor(isDark),
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getEmotionIcon(String emotion) {
//     switch (emotion.toLowerCase()) {
//       case 'happy':
//         return Icons.sentiment_very_satisfied;
//       case 'sad':
//         return Icons.sentiment_very_dissatisfied;
//       case 'angry':
//         return Icons.sentiment_very_dissatisfied;
//       case 'surprised':
//         return Icons.sentiment_satisfied_alt;
//       case 'fear':
//         return Icons.sentiment_dissatisfied;
//       default:
//         return Icons.sentiment_neutral;
//     }
//   }
// }

import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
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
  bool _isDetecting = false;

  int _cameraIndex = 0;

  late Interpreter _interpreter;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableTracking: true,
    ),
  );

  String _detectedEmotion = 'Detecting...';
  String _currentEmoji = '😐';
  List<Rect> _faceRects = [];

  final List<String> _labels = [
    'Angry',
    'Disgust',
    'Fear',
    'Happy',
    'Neutral',
    'Sad',
    'Surprise',
  ];

  @override
  void initState() {
    super.initState();
    _initAll();
  }

  Future<void> _initAll() async {
    _interpreter = await Interpreter.fromAsset('assets/emotion_model.tflite');
    await _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) return;

      _controller = CameraController(
        _cameras![_cameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      _controller!.startImageStream((image) async {
        if (!_isDetecting) {
          _isDetecting = true;
          await _processCameraImage(image);
          _isDetecting = false;
        }
      });

      if (mounted) {
        setState(() => _isInitialized = true);
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

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;

    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;

    if (mounted) setState(() => _isInitialized = false);

    await _initializeCamera();
  }

  Future<void> _processCameraImage(CameraImage cameraImage) async {
    try {
      final inputImage = _buildInputImage(cameraImage);
      if (inputImage == null) return;

      final faces = await _faceDetector.processImage(inputImage);

      final converted = _convertToImage(cameraImage);
      if (converted == null) return;

      if (faces.isEmpty) {
        if (mounted) {
          setState(() {
            _faceRects = [];
            _detectedEmotion = 'No Face';
            _currentEmoji = '😐';
          });
        }
        return;
      }

      // Pick largest face
      faces.sort((a, b) => b.boundingBox.width.compareTo(a.boundingBox.width));
      final face = faces.first;

      final cropped = img.copyCrop(
        converted,
        x: face.boundingBox.left.toInt().clamp(0, converted.width - 1),
        y: face.boundingBox.top.toInt().clamp(0, converted.height - 1),
        width: face.boundingBox.width.toInt().clamp(1, converted.width),
        height: face.boundingBox.height.toInt().clamp(1, converted.height),
      );

      final input = _preprocess(cropped);
      final output = List.filled(7, 0.0).reshape([1, 7]);

      _interpreter.run(input, output);

      int maxIndex = 0;
      double maxVal = output[0][0];
      for (int i = 1; i < 7; i++) {
        if (output[0][i] > maxVal) {
          maxVal = output[0][i];
          maxIndex = i;
        }
      }

      final emotion = _labels[maxIndex];

      if (mounted) {
        setState(() {
          _faceRects = [face.boundingBox];
          _detectedEmotion = emotion;
          _currentEmoji = _getEmoji(emotion);
        });
      }
    } catch (e) {
      debugPrint('Detection error: $e');
    }
  }

  InputImage? _buildInputImage(CameraImage image) {
    try {
      final buffer = WriteBuffer();
      for (final plane in image.planes) {
        buffer.putUint8List(plane.bytes);
      }
      return InputImage.fromBytes(
        bytes: buffer.done().buffer.asUint8List(),
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  img.Image? _convertToImage(CameraImage image) {
    try {
      final result = img.Image(width: image.width, height: image.height);
      final plane = image.planes[0];
      int index = 0;
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          final pixel = plane.bytes[index++];
          result.setPixelRgb(x, y, pixel, pixel, pixel);
        }
      }
      return result;
    } catch (_) {
      return null;
    }
  }

  List<List<List<List<double>>>> _preprocess(img.Image image) {
    final resized = img.copyResize(image, width: 48, height: 48);
    return [
      List.generate(
        48,
        (y) => List.generate(48, (x) {
          final p = resized.getPixel(x, y);
          return [p.r / 255.0];
        }),
      ),
    ];
  }

  String _getEmoji(String emotion) {
    switch (emotion) {
      case 'Happy':
        return '😄';
      case 'Sad':
        return '😢';
      case 'Angry':
        return '😡';
      case 'Surprise':
        return '😲';
      case 'Fear':
        return '😨';
      case 'Disgust':
        return '🤢';
      default:
        return '😐';
    }
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'sad':
        return Icons.sentiment_very_dissatisfied;
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'surprise':
        return Icons.sentiment_satisfied_alt;
      case 'fear':
        return Icons.sentiment_dissatisfied;
      case 'disgust':
        return Icons.sick;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _faceDetector.close();
    _interpreter.close();
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
          icon: Icon(Icons.arrow_back, color: Constants.getTextColor(isDark)),
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.cameraswitch,
              color: Constants.getTextColor(isDark),
            ),
            onPressed: _flipCamera,
            tooltip: 'Flip Camera',
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Camera + face overlay ──────────────────────────────
          Expanded(
            child: _isInitialized && _controller != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CameraPreview(_controller!),

                      // Face bounding boxes
                      ..._faceRects.map(
                        (rect) => Positioned(
                          left: rect.left,
                          top: rect.top,
                          child: Container(
                            width: rect.width,
                            height: rect.height,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.greenAccent,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      // Centre guide overlay (kept from original UI)
                      Center(
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Constants.accentColor.withOpacity(0.5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
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

          // ── Bottom panel ───────────────────────────────────────
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
                // Emotion card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Constants.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Constants.accentColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_currentEmoji, style: const TextStyle(fontSize: 40)),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detected Emotion',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: Constants.getTextSecondaryColor(isDark),
                            ),
                          ),
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
                      const SizedBox(width: 12),
                      Icon(
                        _getEmotionIcon(_detectedEmotion),
                        size: 36,
                        color: Constants.accentColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Live status indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _isDetecting
                            ? Constants.accentColor
                            : Constants.successColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isDetecting
                          ? 'Analyzing in real time...'
                          : 'Live detection active',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: Constants.getTextColor(isDark),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Align your face inside the frame for best results',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Constants.getTextSecondaryColor(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
