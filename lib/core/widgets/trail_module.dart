import 'package:flutter/material.dart';
import 'package:pomo/core/widgets/apple_node.dart';

class TrailModule extends StatelessWidget {
  final List<Map<String, dynamic>> lessons;
  final int progressoAtual;

  const TrailModule({
    super.key,
    required this.lessons,
    required this.progressoAtual,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(lessons.length, (index) {
        final lesson = lessons[index];

        final isLeft = index % 2 == 0;
        final offsetX = isLeft ? -60.0 : 60.0;
        final caterpillarOffsetX = isLeft ? -30.0 : 30.0;

        final isLastInModule =
            index == lessons.length - 1 ||
            lessons[index]['level'] != lessons[index + 1]['level'];

        final bool isLocked = lesson['ordem'] > progressoAtual;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Align(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(offsetX, 0),
                  child: AppleNode(
                    ordem: lesson['ordem'],
                    titulo: lesson['titulo'],
                    level: lesson['level'] ?? 1,
                    isLastInModule: isLastInModule,
                    isLocked: isLocked,
                    isProva: lesson['isProva'] ?? false,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            if (!isLastInModule)
              SizedBox(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: Offset(caterpillarOffsetX, 0),
                    child: Image.asset(
                      isLeft
                          ? 'lib/core/assets/icons/icon-lagarta-direita-trilha.png'
                          : 'lib/core/assets/icons/icon-lagarta-esquerda-trilha.png',
                      width: 52.55,
                      height: 52,
                      color: isLocked ? Colors.grey.withValues(alpha: 0.5) : null,
                      colorBlendMode: isLocked ? BlendMode.srcATop : null,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 0),
          ],
        );
      }),
    );
  }
}