import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/destination.dart';
import '../services/api_service.dart';
import '../widgets/destination_grid_card.dart';
import '../widgets/gradient_background.dart';
import '../widgets/shimmer_card.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Destination>> _destinationsFuture;
  List<Destination> _allDestinations = [];
  List<Destination> _filteredDestinations = [];
  String _selectedRegion = 'All';
  String _sortBy = 'Name';
  bool _hasAppliedInitialFilter = false;

  final List<String> _regions = [
    'All',
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];
  final List<String> _sortOptions = ['Name', 'Population', 'Region'];

  @override
  void initState() {
    super.initState();
    _destinationsFuture = _apiService.fetchDestinations();
  }

  // Ye function sirf data filter karta hai, setState nahi karta
  List<Destination> _getFilteredDestinations() {
    final filtered = _allDestinations.where((d) {
      return _selectedRegion == 'All' || d.region == _selectedRegion;
    }).toList();

    if (_sortBy == 'Name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortBy == 'Population') {
      filtered.sort((a, b) => b.population.compareTo(a.population));
    } else if (_sortBy == 'Region') {
      filtered.sort((a, b) => a.region.compareTo(b.region));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore 🔍',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Discover all destinations',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _showSortOptions,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: const Icon(
                          Icons.sort,
                          color: Color(0xFFFF6B6B),
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    final region = _regions[index];
                    final isSelected = _selectedRegion == region;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedRegion = region;
                          _filteredDestinations = _getFilteredDestinations();
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                            colors: [
                              Color(0xFFFF6B6B),
                              Color(0xFFFF8E53),
                            ],
                          )
                              : null,
                          color: isSelected
                              ? null
                              : Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            region,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<Destination>>(
                  future: _destinationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildLoading();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error loading data',
                          style: GoogleFonts.inter(color: Colors.white70),
                        ),
                      );
                    }

                    if (snapshot.hasData) {
                      // Pehli baar data set karo
                      if (!_hasAppliedInitialFilter) {
                        _allDestinations = snapshot.data!;
                        _filteredDestinations = _getFilteredDestinations();
                        _hasAppliedInitialFilter = true;
                      }

                      if (_filteredDestinations.isEmpty) {
                        return Center(
                          child: Text(
                            'No destinations found',
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final crossAxisCount = width < 600
                              ? 2
                              : width < 900
                              ? 3
                              : 4;

                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              10,
                              20,
                              100,
                            ),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: _filteredDestinations.length,
                            itemBuilder: (context, index) {
                              final destination =
                              _filteredDestinations[index];
                              return DestinationGridCard(
                                destination: destination,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(
                                        destination: destination,
                                      ),
                                    ),
                                  );
                                },
                              )
                                  .animate()
                                  .fadeIn(
                                delay: (index * 30).ms,
                                duration: 400.ms,
                              )
                                  .scale(
                                begin: const Offset(0.9, 0.9),
                                end: const Offset(1, 1),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width < 600
            ? 2
            : width < 900
            ? 3
            : 4;

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.78,
          ),
          itemCount: 6,
          itemBuilder: (_, __) => const ShimmerCard(),
        );
      },
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F38),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ..._sortOptions.map((option) {
              final isSelected = _sortBy == option;
              return ListTile(
                onTap: () {
                  setState(() {
                    _sortBy = option;
                    _filteredDestinations = _getFilteredDestinations();
                  });
                  Navigator.pop(context);
                },
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: const Color(0xFFFF6B6B),
                ),
                title: Text(
                  option,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}