class ArticleData {
  final String title;
  final String author;
  final String description;
  final String url;
  final DateTime publishedAt;
  final List<String> tags;

  ArticleData({
    required this.title,
    required this.author,
    required this.description,
    required this.url,
    required this.tags,
    required this.publishedAt,
  });
}
