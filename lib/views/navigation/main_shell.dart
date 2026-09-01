import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../home/home_view.dart';
import '../analytics/analytics_view.dart';
import '../ai_scanner/ai_scanner_view.dart';
import '../stream/stream_view.dart';
import '../wallet/wallet_view.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screen switcher
    final List<Widget> screens = [
      HomeView(
        onOpenAiScanner: () => setState(() => _currentIndex = 2),
        onOpenStreamView: () => setState(() => _currentIndex = 3),
      ),
      const AnalyticsView(),
      const AIScannerView(),
      const StreamView(),
      const WalletView(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480), // Mobile-first viewport constrain
          child: Stack(
            children: [
              IndexedStack(
                index: _currentIndex,
                children: screens,
              ),

              // Floating Bottom Navigation Bar
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF13131D).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.cardBorderGlowing, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.primaryPink.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(0, Icons.donut_large_rounded, 'Overview'),
                      _navItem(1, Icons.show_chart_rounded, 'Analytics'),
                      _navItem(2, Icons.auto_awesome, 'AI Underwriter', isHero: true),
                      _navItem(3, Icons.bolt_rounded, 'Stream'),
                      _navItem(4, Icons.account_balance_wallet_outlined, 'Wallet'),
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

  Widget _navItem(int index, IconData icon, String tooltip, {bool isHero = false}) {
    final bool isSelected = _currentIndex == index;

    if (isHero) {
      return GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.pinkGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPink.withValues(alpha: 0.5),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 22,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? AppColors.primaryPink : AppColors.textMuted,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 4 : 0,
            height: isSelected ? 4 : 0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryPink,
            ),
          ),
        ],
      ),
    );
  }
}
