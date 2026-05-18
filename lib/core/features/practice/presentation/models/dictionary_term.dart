class DictionaryTerm {
  final String title;
  final String content;

  const DictionaryTerm({
    required this.title,
    required this.content,
  });

  factory DictionaryTerm.fromJson(Map<String, dynamic> json) {
    return DictionaryTerm(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}