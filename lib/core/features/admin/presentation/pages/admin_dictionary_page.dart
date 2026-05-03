import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/lecture.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../../widgets/icon_input.dart';
import '../../../../widgets/module.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/pop_up_success_admin.dart';
import '../../../../widgets/modal_admin.dart';
import '../../../../widgets/pop_up_admin.dart';

class AdminDictionary extends StatefulWidget {
  const AdminDictionary({super.key});

  @override
  State<AdminDictionary> createState() => _AdminDictionaryState();
}

class _AdminDictionaryState extends State<AdminDictionary> {
  final List<Map<String, String>> _terms = [
    {
      'title': 'Juros Simples',
      'definition':
          'Método de cálculo financeiro onde a taxa de juros incide apenas sobre o valor inicial.',
    },
    {
      'title': 'Juros Composto',
      'definition':
          'O interesse de cada período é somado ao capital para o cálculo de novos juros.',
    },
    {
      'title': 'Capital Inicial',
      'definition':
          'O valor principal investido ou emprestado antes da aplicação de juros.',
    },
    {
      'title': 'Margem de Lucro',
      'definition':
          'A diferença entre o valor da venda e os custos de produção ou aquisição.',
    },
  ];

  static const _dictionaryTheme = Module(
    primaryColor: AppColors.dictionaryPrimary,
    cardBackgroundColor: AppColors.dictionaryBg,
    iconOneBackgroundColor: AppColors.dictionaryIcon1,
    iconTwoBackgroundColor: AppColors.dictionaryIcon2,
    titlePrefix: 'Dicionário',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 40, 24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: AppColors.textDark,
                        ),
                        SizedBox(width: 8),
                        const Text(
                          'Voltar',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Dicionário de Termos',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.title,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: CustomIconButton(
                      title: 'Adicionar termo',
                      icon: Icons.add,
                      iconPosition: IconButtonPosition.right,
                      theme: _dictionaryTheme,
                      onTap: () => ModalAdmin.show(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 300),
              child: IconInput(
                hint: 'Pesquise um termo criado',
                icon: Icons.search,
                onChanged: (val) {},
              ),
            ),
            const SizedBox(height: 48),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 300,
                  vertical: 20,
                ),
                itemCount: _terms.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final String term = _terms[index]['title'] ?? '';
                  final String definition = _terms[index]['definition'] ?? '';

                  return Lecture(
                    title: term,
                    iconOne: Icons.edit,
                    iconTwo: Icons.delete,
                    theme: _dictionaryTheme,
                    onIconOne: () => ModalAdmin.show(
                      context,
                      term: term,
                      definition: definition,
                    ),
                    onIconTwo: () {
                      PopUpAdmin.show(
                        context,
                        title: 'Confirmar exclusão do termo?',
                        actions: [
                          WideButton(
                            text: 'Cancelar',
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.dictionaryIcon1,
                            borderColor: AppColors.dictionaryIcon1,
                            onPress: () => Navigator.of(context).pop(),
                          ),
                          WideButton(
                            text: 'Confirmar',
                            backgroundColor: AppColors.dictionaryIcon1,
                            onPress: () {
                              Navigator.of(context).pop();
                              Future.microtask(() {
                                if (context.mounted) {
                                  PopUpSuccessAdmin.show(
                                    context,
                                    'Termo excluído com sucesso!',
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
