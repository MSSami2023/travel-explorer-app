import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/destinations_data.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/animated_background.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _sort = 'Popular';
  RangeValues _priceRange = const RangeValues(0, 3000);

  List<dynamic> get _sorted {
    final list = destinationsData
        .where((d) =>
    d.price >= _priceRange.start && d.price <= _priceRange.end)
        .toList();
    switch (_sort) {
      case 'Price ↑':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price ↓':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final width = MediaQuery.of(context).size.width;
    final cross = width > 900 ? 3 : (width > 600 ? 2 : 1);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppTheme.goldGradient.createShader(b),
                      child: Text(
                        'Explore',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      color: AppColors.darkCard,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: AppColors.goldPrimary.withOpacity(0.4),
                        ),
                      ),
                      onSelected: (v) => setState(() => _sort = v),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'Popular', child: Text('Popular')),
                        PopupMenuItem(value: 'Rating', child: Text('Top Rated')),
                        PopupMenuItem(value: 'Price ↑', child: Text('Price Low → High')),
                        PopupMenuItem(value: 'Price ↓', child: Text('Price High → Low')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.goldPrimary.withOpacity(0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sort,
                                color: AppColors.goldPrimary, size: 18),
                            const SizedBox(width: 6),
                            Text(_sort,
                                style: GoogleFonts.poppins(
                                    color: AppColors.textLight,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Price slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.silverDark.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attach_money,
                              color: AppColors.goldPrimary, size: 18),
                          Text(
                            'Price Range',
                            style: GoogleFonts.poppins(
                              color: AppColors.textLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}',
                            style: GoogleFonts.poppins(
                              color: AppColors.goldPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      RangeSlider(
                        values: _priceRange,
                        min: 0,
                        max: 3000,
                        divisions: 30,
                        activeColor: AppColors.goldPrimary,
                        inactiveColor: AppColors.silverDark,
                        onChanged: (v) => setState(() => _priceRange = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _sorted.isEmpty
                    ? Center(
                    child: Text('No results in this range',
                        style: GoogleFonts.poppins(
                            color: AppColors.textMuted)))
                    : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cross,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _sorted.length,
                  itemBuilder: (_, i) {
                    final dest = _sorted[i];
                    return DestinationCard(
                      destination: dest,
                      isFavorite: favorites.isFavorite(dest.id),
                      onFavoriteToggle: () =>
                          favorites.toggleFavorite(dest),
                      onTap: () => Navigator.push(
                        context,
                        FadeSlideRoute(
                            page: DetailScreen(destination: dest)),
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