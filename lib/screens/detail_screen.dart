import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import 'booking_screen.dart';

class DetailScreen extends StatefulWidget {
  final Destination destination;
  const DetailScreen({super.key, required this.destination});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFav = favorites.isFavorite(widget.destination.id);
    final d = widget.destination;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ═══════ HERO IMAGE WITH APPBAR ═══════
              SliverAppBar(
                expandedHeight: 420,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.darkBg,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _glassIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _glassIconButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? AppColors.goldPrimary
                          : AppColors.silverLight,
                      onTap: () {
                        favorites.toggleFavorite(d);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.darkCard,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: AppColors.goldPrimary
                                    .withOpacity(0.5),
                              ),
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  isFav
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: AppColors.goldPrimary,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isFav
                                      ? 'Removed from favorites'
                                      : 'Added to favorites',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textLight,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hero image
                      Hero(
                        tag: 'dest-${d.id}',
                        child: CachedNetworkImage(
                          imageUrl: d.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            color: AppColors.darkSurface,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.goldPrimary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.darkSurface,
                            child: const Icon(
                              Icons.broken_image,
                              color: AppColors.silverMid,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration:
                        BoxDecoration(gradient: AppTheme.overlayGradient),
                      ),
                      // Bottom info
                      Positioned(
                        bottom: 30,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _pill(
                                  label: d.category.toUpperCase(),
                                  gradient: AppTheme.goldGradient,
                                  textColor: Colors.black,
                                ),
                                const SizedBox(width: 10),
                                _pill(
                                  label:
                                  '⭐ ${d.rating}',
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.4),
                                    ],
                                  ),
                                  textColor: AppColors.goldPrimary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              d.name,
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.goldPrimary,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  d.country,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.silverLight,
                                    fontSize: 15,
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

              // ═══════ CONTENT BODY ═══════
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -20, 0),
                  decoration: const BoxDecoration(
                    color: AppColors.darkBg,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick info tiles
                      Row(
                        children: [
                          _infoTile(
                            icon: Icons.star,
                            label: 'Rating',
                            value: '${d.rating}',
                          ),
                          const SizedBox(width: 12),
                          _infoTile(
                            icon: Icons.calendar_today,
                            label: 'Best Time',
                            value: d.bestTime.split(' - ').first,
                          ),
                          const SizedBox(width: 12),
                          _infoTile(
                            icon: Icons.attach_money,
                            label: 'From',
                            value: '\$${d.price.toStringAsFixed(0)}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // About section
                      _sectionTitle('About'),
                      const SizedBox(height: 12),
                      Text(
                        d.description,
                        style: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: 14,
                          height: 1.75,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Best time section
                      _sectionTitle('Best Time to Visit'),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: AppTheme.goldGradient,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldPrimary
                                        .withOpacity(0.4),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.wb_sunny,
                                color: Colors.black,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recommended Season',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    d.bestTime,
                                    style: GoogleFonts.playfairDisplay(
                                      color: AppColors.textLight,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Highlights
                      _sectionTitle('Highlights'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: d.highlights
                            .map((h) => _highlightChip(h))
                            .toList(),
                      ),
                      const SizedBox(height: 28),

                      // Gallery preview
                      _sectionTitle('Gallery'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (_, i) {
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: AppColors.goldPrimary
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: CachedNetworkImage(
                                  imageUrl: d.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: AppColors.darkSurface,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ═══════ FLOATING BOTTOM BAR ═══════
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkCard.withOpacity(0.95),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.goldPrimary.withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: AppColors.goldPrimary.withOpacity(0.15),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${d.price.toStringAsFixed(0)}',
                            style: GoogleFonts.playfairDisplay(
                              color: AppColors.goldPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            ' /person',
                            style: GoogleFonts.poppins(
                              color: AppColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      label: 'Book Now',
                      icon: Icons.flight_takeoff,
                      onTap: () => Navigator.push(
                        context,
                        FadeSlideRoute(
                          page: BookingScreen(destination: d),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════ HELPER WIDGETS ═══════

  Widget _glassIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.goldPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.goldPrimary.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _pill({
    required String label,
    required Gradient gradient,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        radius: 16,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.goldPrimary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.goldPrimary, size: 16),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.goldPrimary.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldPrimary.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.black,
              size: 10,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.textLight,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}