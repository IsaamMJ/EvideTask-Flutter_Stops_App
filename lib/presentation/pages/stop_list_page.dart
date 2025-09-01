import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stops/stops_bloc.dart';
import '../bloc/stops/stops_event.dart';
import '../bloc/stops/stops_state.dart';
import '../widgets/search_bar.dart';
import '../widgets/stop_list_item.dart';
import '../../core/theme/app_colors.dart';
import 'stop_detail_page.dart';

class StopsListPage extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  const StopsListPage({Key? key, this.onThemeToggle}) : super(key: key);

  @override
  State<StopsListPage> createState() => _StopsListPageState();
}

class _StopsListPageState extends State<StopsListPage> {
  Timer? _searchTimer;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 0 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  void _debouncedSearch(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 400), () {
      if (query.isEmpty) {
        context.read<StopsBloc>().add(ClearSearch());
      } else {
        context.read<StopsBloc>().add(SearchStops(query));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('StopSpot', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primaryBlue,
        centerTitle: true,
        elevation: _isScrolled ? 4 : 0,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: widget.onThemeToggle,
            tooltip: '${isDark ? 'Light' : 'Dark'} Mode',
          ),
        ],
      ),
      body: BlocBuilder<StopsBloc, StopsState>(
        builder: (context, state) {
          if (state is StopsInitial) {
            context.read<StopsBloc>().add(LoadStops());
            return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
          }

          if (state is StopsLoading) {
            return Center(child: CircularProgressIndicator(color: AppColors.primaryBlue));
          }

          if (state is StopsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Oops! ${state.message}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: AppColors.neutralGray)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<StopsBloc>().add(LoadStops()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is StopsLoaded) {
            return Column(
              children: [
                Semantics(
                  label: 'Search bus stops',
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StopSearchBar(
                      initialValue: state.searchQuery,
                      onChanged: _debouncedSearch,
                      onClear: () => context.read<StopsBloc>().add(ClearSearch()),
                    ),
                  ),
                ),
                Expanded(
                  child: state.stops.isEmpty
                      ? _buildEmptyState(state)
                      : RefreshIndicator(
                    color: AppColors.primaryBlue,
                    onRefresh: () async => context.read<StopsBloc>().add(LoadStops()),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: state.stops.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final stop = state.stops[index];
                        return Semantics(
                          label: 'Bus stop ${stop.name}',
                          child: StopListItem(
                            stop: stop,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StopDetailPage(stopId: stop.id),
                              ),
                            ),
                            onFavoriteToggle: () {
                              context.read<StopsBloc>().add(ToggleFavoriteStop(stop.id));
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(StopsLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            state.isSearching ? Icons.search_off : Icons.directions_bus,
            size: 64,
            color: AppColors.neutralGray,
          ),
          const SizedBox(height: 16),
          Text(
            state.isSearching
                ? 'No stops found for "${state.searchQuery}"'
                : 'No bus stops available',
            style: TextStyle(fontSize: 16, color: AppColors.neutralGray),
          ),
          if (state.isSearching) ...[
            const SizedBox(height: 8),
            Text(
              'Try searching for "Marine Drive" or "Fort Kochi"',
              style: TextStyle(fontSize: 14, color: AppColors.neutralGray.withOpacity(0.7)),
            ),
          ],
        ],
      ),
    );
  }
}