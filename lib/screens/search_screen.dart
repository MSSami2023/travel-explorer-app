import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/destination_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final List<Destination> destinations;
  const SearchScreen({super.key, required this.destinations});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Destination> get _results {
    if (_query.trim().isEmpty) return [];
    final q = _query.toLowerCase();
    return widget.destinations.where((d) {
      return d.name.toLowerCase().contains(q) ||
          d.country.toLowerCase().contains(q) ||
          d.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final results = _results;
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 900 ? 3 : (width > 600 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                autofocus: true,
                style: GoogleFonts.poppins(color: AppColors.textLight),
                onChanged: (v) => setState(() => _query = v),
                validator: (v) {
                  if (v != null && v.trim().length == 1) {
                    return 'Type at least 2 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Search by name, country, or category...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: AppColors.silverMid),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: _query.trim().isEmpty
                ? _buildHint()
                : results.isEmpty
                ? _buildNoResults()
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: results.length,
              itemBuilder: (_, i) {
                final dest = results[i];
                return DestinationCard(
                  destination: dest,
                  isFavorite: favorites.isFavorite(dest.id),
                  onFavoriteToggle: () =>
                      favorites.toggleFavorite(dest),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(destination: dest),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHint() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 72, color: AppColors.silverDark),
          const SizedBox(height: 16),
          Text('Start typing to explore',
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.textLight, fontSize: 20)),
          const SizedBox(height: 6),
          Text('Find your dream destination',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 72, color: AppColors.silverDark),
          const SizedBox(height: 16),
          Text('No results found',
              style: GoogleFonts.playfairDisplay(
                  color: AppColors.textLight, fontSize: 20)),
          const SizedBox(height: 6),
          Text('Try a different keyword',
              style: GoogleFonts.poppins(
                  color: AppColors.textMuted, fontSize: 13)),
        ],
      ),
    );
  }
}