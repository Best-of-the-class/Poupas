import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'wide_button.dart';
import 'pop_up_success_admin.dart';

class ModalAdmin extends StatefulWidget {
  final String? initialTerm;
  final String? initialDefinition;

  const ModalAdmin({super.key, this.initialTerm, this.initialDefinition});

  @override
  State<ModalAdmin> createState() => _ModalAdminState();

  static void show(BuildContext context, {String? term, String? definition}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ModalAdmin',
      barrierColor: Colors.black54,
      pageBuilder: (context, anim1, anim2) =>
          ModalAdmin(initialTerm: term, initialDefinition: definition),
    );
  }
}

class _ModalAdminState extends State<ModalAdmin> {
  late bool isEditing;
  late TextEditingController _termController;
  late TextEditingController _definitionController;

  @override
  void initState() {
    super.initState();
    isEditing = widget.initialTerm != null;
    _termController = TextEditingController(text: widget.initialTerm ?? '');
    _definitionController = TextEditingController(
      text: widget.initialDefinition ?? '',
    );
  }

  @override
  void dispose() {
    _termController.dispose();
    _definitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing
                  ? 'Edição de Termo'
                  : 'Adicione termos para o dicionário',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.dictionaryIcon2,
              ),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              controller: _termController,
              hint: 'Adicione o nome do termo',
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _definitionController,
              hint: 'Adicione o significado do termo',
              isLarge: true,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: WideButton(
                    text: 'Cancelar',
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.dictionaryIcon1,
                    borderColor: AppColors.dictionaryIcon1,
                    onPress: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 150,
                  child: WideButton(
                    text: isEditing ? 'Editar' : 'Adicionar',
                    backgroundColor: AppColors.dictionaryIcon1,
                    onPress: () {
                      Navigator.of(context).pop();
                      Future.microtask(() {
                        if (context.mounted) {
                          PopUpSuccessAdmin.show(
                            context,
                            isEditing
                                ? 'Termo editado com sucesso!'
                                : 'Termo adicionado no dicionário com sucesso!',
                          );
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isLarge = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: isLarge ? 6 : 1,
      cursorColor: AppColors.dictionaryIcon2,
      style: const TextStyle(color: AppColors.textDark, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.dictionaryIcon1),
        filled: true,
        fillColor: AppColors.dictionaryBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isLarge ? 24 : 100),
          borderSide: const BorderSide(
            color: AppColors.dictionaryIcon1,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isLarge ? 24 : 100),
          borderSide: const BorderSide(
            color: AppColors.dictionaryIcon2,
            width: 2,
          ),
        ),
      ),
    );
  }
}
