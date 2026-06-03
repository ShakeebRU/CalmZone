class ExercisePlan {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String difficulty;
  final String imageUrl;
  final String videoUrl;
  final String type;
  final String iconName;

  final List<String> instructions; // ✅ NEW

  ExercisePlan({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.imageUrl,
    required this.videoUrl,
    required this.type,
    required this.iconName,
    required this.instructions,
  });

  factory ExercisePlan.fromMap(Map<String, dynamic> map) {
    return ExercisePlan(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      duration: map['duration'] ?? '',
      difficulty: map['difficulty'] ?? 'Beginner',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      type: map['type'] ?? '',
      iconName: map['iconName'] ?? '',

      instructions: List<String>.from(map['instructions'] ?? []), // ✅
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'type': type,
      'iconName': iconName,

      'instructions': instructions, // ✅
    };
  }
}
