import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../network/adapters/routes_adapter.dart';
import '../../../../widgets/custom_positioned_image.dart';

class AdminSuccessPage extends StatelessWidget {
  const AdminSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: CustomPositionedImage(
        imageSize: 220,
        posX: (MediaQuery.of(context).size.width / 2) - (220 / 2),
        posY: 100,
        imagePath:
            'lib/core/features/forgot_password/presentation/assets/images/poup_check.png',
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                const Text(
                  'Aula criada com sucesso!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4A4A4A),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 280,
                    child: WideButton(
                      text: 'Voltar para Início',
                      onPress: () =>
                          context.goNamed(RoutesAdapter.adminActivities),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
