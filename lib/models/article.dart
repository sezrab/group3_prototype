class ArticleData {
  final int id;
  final String title;
  final List<String> authors;
  final String abstract;
  final String url;
  final DateTime publishedAt;
  final List<String> tags;

  ArticleData({
    required this.id,
    required this.title,
    required this.authors,
    required this.abstract,
    required this.url,
    required this.tags,
    required this.publishedAt,
  });

  factory ArticleData.fromJson(Map<String, dynamic> json) {
    // return {
    //         'id': self._id,
    //         'title': self._title,
    //         'summary': self._abstract,
    //         'authors': self._authors,
    //         'tags': self._tags,
    //         'published': self._published.isoformat() if self._published else None,
    //         'url': self._url
    //     }
    return ArticleData(
      id: json['id'],
      title: json['title'] as String,
      authors: json['authors']!.cast<String>(),
      abstract: json['summary'] as String,
      url: json['url'] as String,
      tags: json['tags']!.cast<String>(),
      publishedAt: DateTime.parse(json['published']),
    );
  }
}
