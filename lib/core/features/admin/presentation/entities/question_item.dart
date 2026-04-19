class QuestionItem {
  final String title;
  final String subtitle;
  final String questionText;
  final List<String> choices;
  final int correctIndex;
  final bool isSelected;

  QuestionItem({
    required this.title,
    required this.subtitle,
    this.questionText = '',
    required this.choices,
    this.correctIndex = 0,
    this.isSelected = false,
  });

  QuestionItem copyWith({
    String? title,
    String? subtitle,
    String? questionText,
    List<String>? choices,
    int? correctIndex,
    bool? isSelected,
  }) {
    return QuestionItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      questionText: questionText ?? this.questionText,
      choices: choices ?? this.choices,
      correctIndex: correctIndex ?? this.correctIndex,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
