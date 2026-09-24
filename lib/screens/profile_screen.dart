import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_background.dart';
import '../widgets/glass_card.dart';
import 'favorites_screen.dart';
import '../utils/page_transitions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = context.watch<FavoritesProvider>();
    final bookings = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.goldGradient,
                        boxShadow: [AppTheme.goldGlow],
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.darkCard,
                        child: Text('T',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 40,
                                color: AppColors.goldPrimary,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text('Traveler',
                        style: GoogleFonts.playfairDisplay(
                            color: AppColors.textLight,
                            fontSize: 22,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('traveler@explorer.com',
                        style: GoogleFonts.poppins(
                            color: AppColors.textMuted, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Stats
              Row(
                children: [
                  _stat(Icons.favorite, '${fav.count}', 'Favorites',
                          () => Navigator.push(context,
                          ScaleFadeRoute(page: const FavoritesScreen()))),
                  const SizedBox(width: 12),
                  _stat(Icons.card_travel, '${bookings.count}', 'Bookings',
                          () {}),
                  const SizedBox(width: 12),
                  _stat(Icons.attach_money,
                      '\$${bookings.totalSpent.toInt()}', 'Spent', () {}),
                ],
              ),
              const SizedBox(height: 30),
              Text('My Bookings',
                  style: GoogleFonts.playfairDisplay(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              if (bookings.bookings.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Icon(Icons.card_travel,
                          size: 40, color: AppColors.silverDark),
                      const SizedBox(height: 10),
                      Text('No bookings yet',
                          style: GoogleFonts.poppins(
                              color: AppColors.textMuted, fontSize: 13)),
                    ],
                  ),
                )
              else
                ...bookings.bookings.reversed.map((b) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(b.destination.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.darkSurface)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(b.destination.name,
                                  style: GoogleFonts.playfairDisplay(
                                      color: AppColors.textLight,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              Text(
                                  '${DateFormat('dd MMM yyyy').format(b.date)} • ${b.guests} guests',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.textMuted,
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: AppTheme.goldGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(b.status,
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                )),
              const SizedBox(height: 30),
              Text('Settings',
                  style: GoogleFonts.playfairDisplay(
                      color: AppColors.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              _settingTile(Icons.notifications_outlined, 'Notifications',
                      () {}),
              _settingTile(Icons.language, 'Language', () {}),
              _settingTile(Icons.shield_outlined, 'Privacy', () {}),
              _settingTile(Icons.help_outline, 'Help & Support', () {}),
              _settingTile(Icons.info_outline, 'About', () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(IconData i, String v, String l, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(i, color: AppColors.goldPrimary, size: 22),
              const SizedBox(height: 6),
              Text(v,
                  style: GoogleFonts.playfairDisplay(
                      color: AppColors.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              Text(l,
                  style: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingTile(IconData i, String t, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.darkElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(i, color: AppColors.goldPrimary, size: 18),
          ),
          title: Text(t,
              style: GoogleFonts.poppins(
                  color: AppColors.textLight, fontSize: 14)),
          trailing: const Icon(Icons.chevron_right,
              color: AppColors.textMuted, size: 20),
          onTap: onTap,
        ),
      ),
    );
  }
}