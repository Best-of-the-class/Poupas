import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/widgets/card_stats_home.dart';
import 'package:pomo/core/widgets/card_module.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/core/assets/images/background-arvore-trilha.png'),
          fit: BoxFit.cover, 
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
  children: [

    const CardStatsHome(
      sequenciaDias: 14,
      xp: 2584,
    ),

    const SizedBox(height: 16),

    Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardModule(level: 3),

            const SizedBox(height: 10),

            const Text(
              "Home",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE52727),
              ),
            ),

            const SizedBox(height: 10),

                    const Text(
                      "Ola isso ai 👋",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}