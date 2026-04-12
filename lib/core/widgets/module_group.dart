import 'package:flutter/material.dart';
import 'module.dart';
import 'module_title.dart';
import 'lecture.dart';
import 'custom_icon_button.dart';

class ModuleGroup extends StatelessWidget {
  final ModuleDifficulty difficulty;
  final List<String> lessonTitles;
  final String actionButtonTitle;
  final IconData? actionButtonIcon;
  final IconButtonPosition actionButtonIconPosition;
  final VoidCallback onActionButtonTap;

  const ModuleGroup({
    super.key,
    required this.difficulty,
    required this.lessonTitles,
    required this.actionButtonTitle,
    this.actionButtonIcon,
    this.actionButtonIconPosition = IconButtonPosition.left,
    required this.onActionButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Module.fromDifficulty(difficulty);
    const borderRadius = BorderRadius.vertical(bottom: Radius.circular(30));

    return Container(
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Column(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              color: theme.primaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ModuleTitle(title: theme.titlePrefix, theme: theme),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: lessonTitles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Lecture(
                      title: lessonTitles[index],
                      iconOne: Icons.edit,
                      iconTwo: Icons.delete,
                      theme: theme,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
              child: SizedBox(
                height: 60,
                child: CustomIconButton(
                  title: actionButtonTitle,
                  icon: actionButtonIcon,
                  iconPosition: actionButtonIconPosition,
                  onTap: onActionButtonTap,
                  theme: theme,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
