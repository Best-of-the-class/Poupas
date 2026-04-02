import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

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
    );
  }
}