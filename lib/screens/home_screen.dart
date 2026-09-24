import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/destinations_data.dart';
import '../models/destination.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_background.dart';
import '../widgets/category_chip.dart';
import '../widgets/destination_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/loading_shimmer.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Destination> _destinations = [];
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = const [
    {'label': 'All', 'icon': Icons.apps},
    {'label': 'Beach', 'icon': Icons.beach_access},
    {'label': 'Mountain', 'icon': Icons.landscape},
    {'label': 'City', 'icon': Icons.location_city},
    {'label': 'Cultural', 'icon': Icons.museum},
    {'label': 'Adventure', 'icon': Icons.hiking},
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() {
        _destinations = destinationsData;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load destinations. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<Destination> get _filtered => _selectedCategory == 'All'
      ? _destinations
      : _destinations.where((d) => d.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final width = MediaQuery.of(context).size.width;
    final cross = width > 900 ? 3 : (width > 600 ? 2 : 1);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.goldPrimary,
            backgroundColor: AppColors.darkCard,
            onRefresh: _load,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Evening 👋',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ShaderMask(
                                    shaderCallback: (b) =>
                                        AppTheme.goldGradient
                                            .createShader(b),
                                    child: Text(
                                      'Explore Paradise',
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                ScaleFadeRoute(
                                    page: const FavoritesScreen()),
                              ),
                              child: Stack(
                                children: [
                                  GlassCard(
                                    padding: const EdgeInsets.all(12),
                                    radius: 14,
                                    child: const Icon(
                                      Icons.favorite,
                                      color: AppColors.goldPrimary,
                                      size: 22,
                                    ),
                                  ),
                                  if (favorites.count > 0)
                                    Positioned(
                                      right: 4,
                                      top: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${favorites.count}',
                                          style: const TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Search bar
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            FadeSlideRoute(
                              page: SearchScreen(
                                  destinations: _destinations),
                            ),
                          ),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            radius: 16,
                            child: Row(
                              children: [
                                const Icon(Icons.search,
                                    color: AppColors.goldPrimary),
                                const SizedBox(width: 12),
                                Text(
                                  'Where do you want to go?',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.tune,
                                    color: AppColors.goldPrimary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _FeaturedBanner(
                      destination: _destinations.isNotEmpty
                          ? _destinations[7]
                          : null,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                // Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _categories.length,
                      itemBuilder: (_, i) {
                        final c = _categories[i];
                        return CategoryChip(
                          label: c['label'],
                          icon: c['icon'],
                          isSelected: _selectedCategory == c['label'],
                          onTap: () => setState(
                                  () => _selectedCategory = c['label']),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                // Section title
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 22,
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _selectedCategory == 'All'
                              ? 'Popular Destinations'
                              : '$_selectedCategory Escapes',
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.textLight,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${_filtered.length} places',
                          style: GoogleFonts.poppins(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                // Content
                if (_isLoading)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (_, __) => const LoadingShimmer(),
                      childCount: 4,
                    ),
                  )
                else if (_error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child:
                    _ErrorState(message: _error!, onRetry: _load),
                  )
                else if (_filtered.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cross,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.82,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, i) {
                            final dest = _filtered[i];
                            return DestinationCard(
                              destination: dest,
                              isFavorite: favorites.isFavorite(dest.id),
                              onFavoriteToggle: () =>
                                  favorites.toggleFavorite(dest),
                              onTap: () => Navigator.push(
                                context,
                                FadeSlideRoute(
                                  page: DetailScreen(destination: dest),
                                ),
                              ),
                            );
                          },
                          childCount: _filtered.length,
                        ),
                      ),
                    ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  final Destination? destination;
  const _FeaturedBanner({this.destination});

  @override
  Widget build(BuildContext context) {
    if (destination == null) return const SizedBox(height: 180);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        FadeSlideRoute(page: DetailScreen(destination: destination!)),
      ),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.goldPrimary.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.goldPrimary.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(destination!.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.darkSurface)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.85),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '✦ FEATURED',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination!.name,
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppColors.goldPrimary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          destination!.country,
                          style: GoogleFonts.poppins(
                            color: AppColors.silverLight,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.star,
                            color: AppColors.goldPrimary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${destination!.rating}',
                          style: GoogleFonts.poppins(
                            color: AppColors.silverLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.goldPrimary.withOpacity(0.5)),
              ),
              child: const Icon(Icons.cloud_off,
                  size: 48, color: AppColors.goldPrimary),
            ),
            const SizedBox(height: 20),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: AppColors.textMuted, fontSize: 14)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.goldPrimary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Text('Retry',
                  style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.travel_explore,
              size: 64, color: AppColors.silverDark),
          const SizedBox(height: 16),
          Text('No destinations found',
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.textLight, fontSize: 20)),
          const SizedBox(height: 6),
          Text('Try a different category',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}