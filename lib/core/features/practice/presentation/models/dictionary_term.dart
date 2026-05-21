class DictionaryTerm {
  final int id;
  final String title;
  final String definition;

  const DictionaryTerm({
    this.id = 0,
    required this.title,
    required this.definition,
  });

  factory DictionaryTerm.fromJson(Map<String, dynamic> json) {
    return DictionaryTerm(
      id: json['id'] ?? 0, 
      title: json['termo'] ?? '',
      definition: json['definicao'] ?? '',
    );
  }
}