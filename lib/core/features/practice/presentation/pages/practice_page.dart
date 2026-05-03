import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,

            leading: IconButton(
                icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textDark,
                size: 32,
                ),
                onPressed: () {
                context.pop();
                },
            ),

        title: Text(
            'Prática',
            style: AppTextStyles.title.copyWith(
            fontSize: 20,
            color: AppColors.title,
            ),
        ),

        centerTitle: true,
        ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              Text(
                'Selecione abaixo exercícios para revisão',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              Expanded(
                child: ListView.builder(
                  itemCount: 10, 
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),

                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Center(
                          child: Text(
                            'Exercício ${index + 1}',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}