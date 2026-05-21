import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import 'wide_button.dart';
import 'pop_up_success_admin.dart';
import '../features/admin/presentation/bloc/dictionary_validator_bloc.dart';
import '../features/admin/presentation/bloc/dictionary_bloc.dart';

class ModalAdmin extends StatefulWidget {
  final String? initialTerm;
  final String? initialDefinition;
  final int? editingIndex;

  const ModalAdmin({
    super.key,
    this.initialTerm,
    this.initialDefinition,
    this.editingIndex,
  });

  @override
  State<ModalAdmin> createState() => _ModalAdminState();

  static void show(
    BuildContext context, {
    String? term,
    String? definition,
    int? editingIndex,
  }) {
    context.read<DictionaryValidatorBloc>().add(ResetTermValidation());
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'ModalAdmin',
      barrierColor: Colors.black54,
      pageBuilder: (dialogContext, anim1, anim2) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<DictionaryValidatorBloc>()),
          BlocProvider.value(value: context.read<DictionaryBloc>()),
        ],
        child: ModalAdmin(
          initialTerm: term,
          initialDefinition: definition,
          editingIndex: editingIndex,
        ),
      ),
    );
  }
}

class _ModalAdminState extends State<ModalAdmin> {
  late bool isEditing;
  late TextEditingController _termController;
  late TextEditingController _definitionController;
  String? _errorMessage;

  static const int maxTermLength = DictionaryValidatorBloc.maxTermLength;

  @override
  void initState() {
    super.initState();
    isEditing = widget.editingIndex != null;
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

  void _submit(BuildContext context) {
    context.read<DictionaryValidatorBloc>().add(
      ValidateTerm(
        term: _termController.text,
        definition: _definitionController.text,
        originalTerm: widget.initialTerm,
        originalDefinition: widget.initialDefinition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DictionaryValidatorBloc, DictionaryValidatorState>(
      listener: (context, state) {
        if (state is TermFailureEffect) {
          setState(() => _errorMessage = state.message);
        } else if (state is TermSuccess) {
          if (isEditing) {
            context.read<DictionaryBloc>().add(
              EditTerm(
                index: widget.editingIndex!,
                term: state.term,
                definition: state.definition,
              ),
            );
          } else {
            context.read<DictionaryBloc>().add(
              AddTerm(term: state.term, definition: state.definition),
            );
          }
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
        }
      },
      child: Dialog(
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
                maxLength: maxTermLength,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _definitionController,
                hint: 'Adicione o significado do termo',
                isLarge: true,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
                      onPress: () => _submit(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool isLarge = false,
    int? maxLength,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: isLarge ? 6 : 1,
      maxLength: maxLength,
      maxLengthEnforcement: maxLength != null
          ? MaxLengthEnforcement.enforced
          : MaxLengthEnforcement.none,
      cursorColor: AppColors.dictionaryIcon2,
      style: const TextStyle(color: AppColors.textDark, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.dictionaryIcon1),
        filled: true,
        fillColor: AppColors.dictionaryBg,
        counterStyle: const TextStyle(color: AppColors.dictionaryIcon1),
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
