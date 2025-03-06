class PostModel {
  final String id;
  final String mood;
  final String content;
  final int createdAt;
  final String creator;
  final String creatorName;

  PostModel({
    required this.id,
    required this.mood,
    required this.content,
    required this.creator,
    required this.createdAt,
    required this.creatorName,
  });

  PostModel.fromJson({
    required Map<String, dynamic> json,
    required String postId,
  })  : mood = json["mood"],
        content = json["content"],
        createdAt = json["createdAt"],
        creator = json["creator"],
        id = postId,
        creatorName = json["creatorName"];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mood": mood,
      "content": content,
      "creator": creator,
      "creatorName": creatorName,
      "createdAt": createdAt,
    };
  }
}
