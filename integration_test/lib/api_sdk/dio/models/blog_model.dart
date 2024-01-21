class BlogsModel {
  BlogsModel({
    required this.date,
    required this.author,
    required this.blog_pic,
    required this.author_id,
    required this.title,
    required this.content,
  });
  late final String date;
  late final String author;
  late final List<String> blog_pic;
  late final String author_id;
  late final String title;
  late final String content;

  BlogsModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    author = json['author'];
    blog_pic = List.castFrom<dynamic, String>(json['blog_pic']);
    author_id = json['author_id'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['date'] = date;
    data['author'] = author;
    data['blog_pic'] = blog_pic;
    data['author_id'] = author_id;
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}
