import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:pomo/core/theme/app_colors.dart';

class CustomEditor extends StatefulWidget {
  final Color? themeColor;
  final String placeholder;
  const CustomEditor({
    super.key,
    this.themeColor,
    this.placeholder = 'Digite aqui o conteúdo teórico',
  });

  @override
  State<CustomEditor> createState() => CustomEditorState();
}

class CustomEditorState extends State<CustomEditor> {
  final QuillController _controller = QuillController.basic();

  QuillController get controller => _controller;

  void setContent(String plainText) {
    final doc = Document()..insert(0, plainText);
    _controller.document = doc;
    _controller.moveCursorToEnd();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.themeColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            child: Container(
              color: primaryColor,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: primaryColor,
                  colorScheme: Theme.of(
                    context,
                  ).colorScheme.copyWith(surface: primaryColor),
                ),
                child: QuillSimpleToolbar(
                  controller: _controller,
                  config: QuillSimpleToolbarConfig(
                    multiRowsDisplay: false,
                    showSearchButton: false,
                    showFontFamily: false,
                    showFontSize: false,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: false,
                    showColorButton: false,
                    showBackgroundColorButton: false,
                    showListNumbers: false,
                    showListBullets: true,
                    showQuote: false,
                    showCodeBlock: false,
                    showIndent: false,
                    showLink: false,
                    headerStyleType: HeaderStyleType.original,
                    buttonOptions: const QuillSimpleToolbarButtonOptions(
                      base: QuillToolbarBaseButtonOptions(
                        iconTheme: QuillIconTheme(
                          iconButtonUnselectedData: IconButtonData(
                            color: AppColors.textLight,
                          ),
                          iconButtonSelectedData: IconButtonData(
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                color: AppColors.textLight,
                padding: const EdgeInsets.all(16),
                child: QuillEditor(
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
                  controller: _controller,
                  config: QuillEditorConfig(
                    placeholder: widget.placeholder,
                    autoFocus: false,
                    expands: true,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
