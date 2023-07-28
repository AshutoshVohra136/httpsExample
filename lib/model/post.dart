class Post {
  dynamic userId;
  final String title;
  final String description;
  Post({this.userId, required this.description, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      userId: json['userId'], description: json['body'], title: json['title']);
}
