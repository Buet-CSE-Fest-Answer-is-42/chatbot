class Book {
  final String title;
  final String id;
  final String description;
  final List<String> keywords;
  final bool isShared;
  final String file;
  final String owner;

  Book( {
    required this.title,
    required this.id,
    required this.description,
    required this.keywords,
    required this.isShared,
    required this.file,
    required this.owner,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      id: json['_id'],
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
      isShared: json['isShared'],
      file: json['file'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'keywords': keywords,
      'isShared': isShared,
      'file': file,
      'owner': owner,
    };
  }
}
