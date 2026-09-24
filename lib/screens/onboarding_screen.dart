import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/gradient_button.dart';
import 'main_nav_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, dynamic>> _slides = const [
    {
      'icon': Icons.travel_explore,
      'title': 'Discover\nThe World',
      'desc':
      'Explore handpicked luxury destinations from every corner of the globe.',
    },
    {
      'icon': Icons.favorite,
      'title': 'Save Your\nDreams',
      'desc':
      'Bookmark favorite destinations and build your personal travel wishlist.',
    },
    {
      'icon': Icons.flight_takeoff,
      'title': 'Book\nSeamlessly',
      'desc':
      'Reserve your next adventure with our premium booking experience.',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      color: AppColors.goldPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _current = i),
                  itemBuilder: (_, i) {
                    final s = _slides[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.goldPrimary.withOpacity(0.25),
                                  Colors.transparent,
                                ],
                              ),
                              border: Border.all(
                                color:
                                AppColors.goldPrimary.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.goldGradient,
                                  boxShadow: [AppTheme.goldGlow],
                                ),
                                child: Icon(
                                  s['icon'],
                                  size: 64,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            s['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              color: AppColors.textLight,
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            s['desc'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.textMuted,
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (i) {
                  final active = i == _current;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: active ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: active ? AppTheme.goldGradient : null,
                      color: active ? null : AppColors.silverDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(24),
                child: GradientButton(
                  label: _current == _slides.length - 1
                      ? 'Get Started'
                      : 'Next',
                  icon: _current == _slides.length - 1
                      ? Icons.arrow_forward
                      : Icons.navigate_next,
                  onTap: () {
                    if (_current == _slides.length - 1) {
                      _skip();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainNavScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}