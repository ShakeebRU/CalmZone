// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final File videoFile;
//   const VideoPlayerScreen({super.key, required this.videoFile});

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _showControls = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.file(widget.videoFile)
//       ..initialize().then((_) {
//         setState(() => _isInitialized = true);
//       });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$minutes:$seconds';
//   }

//   Widget _buildControls() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         VideoProgressIndicator(
//           _controller,
//           allowScrubbing: true,
//           colors: VideoProgressColors(
//             playedColor: Colors.blue,
//             bufferedColor: Colors.grey,
//             backgroundColor: Colors.black26,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
//           child: Row(
//             children: [
//               Text(
//                 _formatDuration(_controller.value.position),
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//               const Spacer(),
//               Text(
//                 _formatDuration(_controller.value.duration),
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.replay_10, color: Colors.white),
//               onPressed: () {
//                 final pos =
//                     _controller.value.position - const Duration(seconds: 10);
//                 _controller.seekTo(pos < Duration.zero ? Duration.zero : pos);
//               },
//             ),
//             IconButton(
//               icon: Icon(
//                 _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 color: Colors.white,
//                 size: 32,
//               ),
//               onPressed: () {
//                 setState(() {
//                   _controller.value.isPlaying
//                       ? _controller.pause()
//                       : _controller.play();
//                 });
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.forward_10, color: Colors.white),
//               onPressed: () {
//                 final pos =
//                     _controller.value.position + const Duration(seconds: 10);
//                 _controller.seekTo(
//                   pos > _controller.value.duration
//                       ? _controller.value.duration
//                       : pos,
//                 );
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         ),
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         title: const Text(
//           "Video Player",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: _isInitialized
//             ? GestureDetector(
//                 onTap: () => setState(() => _showControls = !_showControls),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     AspectRatio(
//                       aspectRatio: _controller.value.aspectRatio,
//                       child: VideoPlayer(_controller),
//                     ),
//                     if (_showControls) _buildControls(),
//                   ],
//                 ),
//               )
//             : const CircularProgressIndicator(),
//       ),
//     );
//   }
// }
