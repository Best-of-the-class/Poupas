import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../theme/app_colors.dart';
import '../../../../widgets/lecture.dart';
import '../../../../widgets/custom_icon_button.dart';
import '../../../../widgets/icon_input.dart';
import '../../../../widgets/module.dart';

class AdminDictionary extends StatefulWidget {
  const AdminDictionary({super.key});

  @override
  State<AdminDictionary> createState() => _AdminDictionaryState();
}

class _AdminDictionaryState extends State<AdminDictionary> {
  final List<String> _terms = [
    'Juros Simples',
    'Juros Composto',
    'Capital Inicial',
    'Margem de Lucro',
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
                    onTap: () => context.pop(),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: AppColors.textDark,
                        ),
                        SizedBox(width: 8),
                        Text(
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
                      onTap: () {},
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
                padding: const EdgeInsets.symmetric(horizontal: 300),
                itemCount: _terms.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Lecture(
                    title: _terms[index],
                    iconOne: Icons.edit,
                    iconTwo: Icons.delete,
                    theme: _dictionaryTheme,
                    onIconOne: () {},
                    onIconTwo: () {},
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
