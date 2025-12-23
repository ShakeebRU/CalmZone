// import 'dart:async'; // Add this for Timer
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class CustomVideoPlayer extends StatefulWidget {
//   final String url;
//   final String playPauseButtonAsset; // Your PNG path
//   const CustomVideoPlayer({
//     super.key,
//     required this.url,
//     required this.playPauseButtonAsset,
//   });

//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }

// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   VideoPlayerController? _videoController;
//   YoutubePlayerController? _youtubeController;
//   bool isYoutube = false;
//   bool isPlaying = false;
//   bool isFullscreen = false;
//   bool showControls = true;
//   Timer? _hideTimer;

//   @override
//   void initState() {
//     super.initState();
//     isYoutube = _isYoutubeUrl(widget.url);

//     if (isYoutube) {
//       _youtubeController = YoutubePlayerController(
//         initialVideoId: YoutubePlayer.convertUrlToId(widget.url)!,
//         flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
//       );
//     } else {
//       _videoController = VideoPlayerController.network(widget.url)
//         ..initialize().then((_) {
//           setState(() {});
//         });
//     }
//   }

//   bool _isYoutubeUrl(String url) {
//     return url.contains('youtube.com') || url.contains('youtu.be');
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     _youtubeController?.dispose();
//     _hideTimer?.cancel();
//     super.dispose();
//   }

//   String _formatDuration(Duration position) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(position.inMinutes.remainder(60));
//     final seconds = twoDigits(position.inSeconds.remainder(60));
//     return "${position.inHours > 0 ? '${twoDigits(position.inHours)}:' : ''}$minutes:$seconds";
//   }

//   void _toggleFullscreen() {
//     setState(() {
//       isFullscreen = !isFullscreen;
//     });
//     if (isFullscreen) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//     } else {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     }
//   }

//   void _togglePlayPause() {
//     setState(() {
//       if (_videoController!.value.isPlaying) {
//         _videoController!.pause();
//         isPlaying = false;
//       } else {
//         _videoController!.play();
//         isPlaying = true;
//       }
//     });
//     _restartHideTimer();
//   }

//   void _onTapVideo() {
//     setState(() {
//       showControls = !showControls;
//     });
//     if (showControls) {
//       _restartHideTimer();
//     }
//   }

//   void _restartHideTimer() {
//     _hideTimer?.cancel();
//     _hideTimer = Timer(const Duration(seconds: 3), () {
//       setState(() {
//         showControls = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isYoutube) {
//       if (_youtubeController == null || _youtubeController!.value.hasError) {
//         return const Center(
//           child: Icon(Icons.error, color: Colors.red, size: 50),
//         );
//       }

//       return YoutubePlayer(
//         controller: _youtubeController!,
//         showVideoProgressIndicator: true,
//         progressIndicatorColor: const Color(0xFF8F82EE),
//         progressColors: const ProgressBarColors(
//           backgroundColor: Colors.white,
//           playedColor: Color(0xFF8F82EE),
//         ),
//       );
//     } else {
//       if (_videoController == null) {
//         return const Center(
//           child: Icon(Icons.error, color: Colors.red, size: 50),
//         );
//       }

//       if (_videoController!.value.hasError) {
//         return const Center(
//           child: Icon(Icons.error, color: Colors.red, size: 50),
//         );
//       }

//       if (_videoController!.value.isInitialized) {
//         return AspectRatio(
//           aspectRatio: _videoController!.value.aspectRatio,
//           child: GestureDetector(
//             onTap: _onTapVideo,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 VideoPlayer(_videoController!),
//                 if (showControls) ...[
//                   _buildCenterPlayPauseButton(),
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: _buildBottomControls(),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         );
//       } else {
//         return const Center(child: CircularProgressIndicator());
//       }
//     }
//   }

//   Widget _buildCenterPlayPauseButton() {
//     return GestureDetector(
//       onTap: _togglePlayPause,
//       child: _videoController!.value.isPlaying
//           ? const Icon(Icons.pause_circle_filled, size: 64, color: Colors.white)
//           : Image.asset(
//               widget.playPauseButtonAsset,
//               height: 64,
//               width: 64,
//               color: Colors.white,
//             ),
//     );
//   }

//   Widget _buildBottomControls() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         VideoProgressIndicator(
//           _videoController!,
//           allowScrubbing: true,
//           colors: VideoProgressColors(
//             playedColor: const Color(0xFF8F82EE),
//             bufferedColor: Colors.grey,
//             backgroundColor: Colors.black26,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//           child: Row(
//             children: [
//               Text(
//                 _formatDuration(_videoController!.value.position),
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const Spacer(),
//               Text(
//                 _formatDuration(_videoController!.value.duration),
//                 style: const TextStyle(color: Colors.white),
//               ),
//               const SizedBox(width: 12),
//               IconButton(
//                 icon: Icon(
//                   isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
//                   color: Colors.white,
//                 ),
//                 onPressed: _toggleFullscreen,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
