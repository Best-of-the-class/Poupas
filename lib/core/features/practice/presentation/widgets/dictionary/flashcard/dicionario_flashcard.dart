import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import '../../../mocks/dictionary_terms_mock.dart';
import 'flashcard_action_button.dart';
import 'flashcard_background.dart';
import 'flashcard_widget.dart';

class DicionarioFlashcard extends StatefulWidget {
  const DicionarioFlashcard({super.key});

  @override
  State<DicionarioFlashcard> createState() => _DicionarioFlashcardState();
}

class _DicionarioFlashcardState extends State<DicionarioFlashcard>
    with TickerProviderStateMixin {
  final List<Color> cardColors = [
    AppColors.questaoBg,
    AppColors.success,
    AppColors.definicaoBg,
  ];

  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;

  late final AnimationController _deckController;
  late final Animation<Offset> _nextAnimation;
  late final Animation<Offset> _previousAnimation;

  bool isReturning = false;
  bool isFront = true;
  int currentIndex = 0;

  final List<int> cardOrder = [0, 1, 2];

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(_flipController);

    _deckController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _nextAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.2, 0.2),
    ).animate(
      CurvedAnimation(
        parent: _deckController,
        curve: Curves.easeInOut,
      ),
    );

    _previousAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _deckController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void flipCard() {
    if (isFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }

    setState(() {
      isFront = !isFront;
    });
  }

  Future<void> nextCard() async {
    setState(() {
      isReturning = false;
    });

    _deckController.reset();

    await _deckController.forward();

    _flipController.reset();

    setState(() {
      isFront = true;
      currentIndex = (currentIndex + 1) % dictionaryTermsMock.length;

      final last = cardOrder.removeLast();
      cardOrder.insert(0, last);
    });

    _deckController.reset();
  }

  Future<void> previousCard() async {
    setState(() {
      isReturning = true;
      isFront = true;

      currentIndex =
          currentIndex == 0 ? dictionaryTermsMock.length - 1 : currentIndex - 1;

      final first = cardOrder.removeAt(0);
      cardOrder.add(first);
    });

    _flipController.reset();
    _deckController.reset();

    await _deckController.forward();

    if (mounted) {
      setState(() {
        isReturning = false;
      });
    }

    _deckController.reset();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _deckController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = dictionaryTermsMock[currentIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 320,
          height: 430,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 18,
                left: 10,
                child: Transform.rotate(
                  angle: -0.12,
                  child: FlashcardBackground(
                    color: cardColors[cardOrder[0]],
                    width: 255,
                    height: 375,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 20,
                child: Transform.rotate(
                  angle: -0.06,
                  child: FlashcardBackground(
                    color: cardColors[cardOrder[1]],
                    width: 258,
                    height: 378,
                  ),
                ),
              ),
              GestureDetector(
                onTap: flipCard,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _flipAnimation,
                    _deckController,
                  ]),
                  builder: (context, child) {
                    final angle = _flipAnimation.value;

                    return SlideTransition(
                      position:
                          isReturning ? _previousAnimation : _nextAnimation,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.rotationZ(isFront ? -0.06 : 0),
                        transformAlignment: Alignment.center,
                        child: Transform.rotate(
                          angle: _deckController.value * -0.15,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: angle <= pi / 2
                                ? FlashcardWidget.front(
                                    termo: currentCard.title,
                                    color: cardColors[cardOrder[2]],
                                  )
                                : Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..rotateY(pi),
                                    child: FlashcardWidget.back(
                                      termo: currentCard.title,
                                      significado: currentCard.content,
                                      color: cardColors[cardOrder[2]],
                                    ),
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
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlashcardActionButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: previousCard,
            ),
            const SizedBox(width: 18),
            FlashcardActionButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: nextCard,
            ),
          ],
        ),
      ],
    );
  }
}