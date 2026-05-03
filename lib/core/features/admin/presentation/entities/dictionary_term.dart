class DictionaryTerm {
  final String title;
  final String definition;

  const DictionaryTerm({required this.title, required this.definition});

  DictionaryTerm copyWith({String? title, String? definition}) {
    return DictionaryTerm(
      title: title ?? this.title,
      definition: definition ?? this.definition,
    );
  }
}
