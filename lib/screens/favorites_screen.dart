import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final list = favorites.favorites;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 3 : (width > 600 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (list.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.goldPrimary),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.darkCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: AppColors.goldPrimary.withOpacity(0.4),
                      ),
                    ),
                    title: Text(
                      'Clear all favorites?',
                      style: GoogleFonts.playfairDisplay(
                        color: AppColors.goldPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    content: Text(
                      'This action cannot be undone.',
                      style: GoogleFonts.poppins(
                          color: AppColors.textMuted, fontSize: 13),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                color: AppColors.silverMid)),
                      ),
                      TextButton(
                        onPressed: () {
                          favorites.clearAll();
                          Navigator.pop(context);
                        },
                        child: Text('Clear',
                            style: GoogleFonts.poppins(
                                color: AppColors.goldPrimary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: list.isEmpty
          ? _buildEmpty()
          : GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final dest = list[i];
          return DestinationCard(
            destination: dest,
            isFavorite: true,
            onFavoriteToggle: () => favorites.toggleFavorite(dest),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(destination: dest),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
              Border.all(color: AppColors.goldPrimary.withOpacity(0.4)),
            ),
            child: const Icon(Icons.favorite_border,
                size: 56, color: AppColors.goldPrimary),
          ),
          const SizedBox(height: 20),
          Text(
            'No favorites yet',
            style: GoogleFonts.playfairDisplay(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon to save destinations',
            style: GoogleFonts.poppins(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}