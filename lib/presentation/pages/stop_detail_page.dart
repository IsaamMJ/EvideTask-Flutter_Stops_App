import 'package:evidetask/domain/entities/stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../core/theme/app_colors.dart';
import '../bloc/stop_detail/stop_detail_bloc.dart';
import '../bloc/stop_detail/stop_detail_event.dart';
import '../bloc/stop_detail/stop_detail_state.dart';

class StopDetailPage extends StatefulWidget {
  final int stopId;
  const StopDetailPage({Key? key, required this.stopId}) : super(key: key);

  @override
  State<StopDetailPage> createState() => _StopDetailPageState();
}

class _StopDetailPageState extends State<StopDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : AppColors.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('$label copied to clipboard');
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => sl<StopDetailBloc>()..add(LoadStopDetail(widget.stopId)),
      child: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : AppColors.background,
        appBar: AppBar(
          title: const Text('Stop Details',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<StopDetailBloc, StopDetailState>(
          listener: (context, state) {
            if (state is StopDetailLoaded) {
              _animationController.forward();
            }
          },
          builder: (context, state) {
            if (state is StopDetailLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryBlue),
                    const SizedBox(height: 16),
                    Text('Loading stop details...',
                        style: TextStyle(color: isDark ? Colors.grey[400] : AppColors.neutralGray)),
                  ],
                ),
              );
            }

            if (state is StopDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 64,
                        color: isDark ? Colors.grey[600] : Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('Connection Error', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[300] : Colors.black87)),
                    const SizedBox(height: 8),
                    Text(state.message, textAlign: TextAlign.center,
                        style: TextStyle(color: isDark ? Colors.grey[400] : AppColors.neutralGray)),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.read<StopDetailBloc>().add(LoadStopDetail(widget.stopId)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is StopDetailLoaded) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: _buildStopDetails(state.stop, isDark),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStopDetails(Stop stop, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Hero Header Card
          Hero(
            tag: 'stop_${stop.id}',
            child: Material(
              color: Colors.transparent,
              child: _buildHeaderCard(stop, isDark),
            ),
          ),
          const SizedBox(height: 16),

          // Description Card
          _buildDescriptionCard(stop, isDark),
          const SizedBox(height: 16),

          // Location Card with Actions
          _buildLocationCard(stop, isDark),
          const SizedBox(height: 16),

          // Quick Actions
          _buildQuickActions(stop),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(Stop stop, bool isDark) {
    return Card(
      color: isDark ? Colors.grey[800] : Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(stop.stopType.iconEmoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stop.name, style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87)),
                      const SizedBox(height: 4),
                      Text(stop.stopType.displayName, style: TextStyle(
                          fontSize: 14, color: isDark ? Colors.grey[400] : AppColors.neutralGray)),
                    ],
                  ),
                ),
                _buildFavoriteButton(stop),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(Stop stop) {
    return Container(
      decoration: BoxDecoration(
        color: stop.isFavorite ? AppColors.successGreen.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(
          stop.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: stop.isFavorite ? AppColors.successGreen : Colors.grey[400],
          size: 28,
        ),
        onPressed: () {
          context.read<StopDetailBloc>().add(ToggleFavoriteDetail(stop.id));
          _showSnackBar(stop.isFavorite
              ? 'Removed from favorites'
              : 'Added to favorites ❤️');
          HapticFeedback.mediumImpact();
        },
      ),
    );
  }

  Widget _buildDescriptionCard(Stop stop, bool isDark) {
    return Card(
      color: isDark ? Colors.grey[800] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text('About this Stop', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue)),
              ],
            ),
            const SizedBox(height: 12),
            Text(stop.description, style: TextStyle(
                fontSize: 15, color: isDark ? Colors.grey[200] : Colors.black87,
                height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(Stop stop, bool isDark) {
    return Card(
      color: isDark ? Colors.grey[800] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.place, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text('Location & Timing', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue)),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.my_location, 'Latitude', '${stop.lat}°', isDark,
                onTap: () => _copyToClipboard('${stop.lat}', 'Latitude')),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.my_location, 'Longitude', '${stop.lng}°', isDark,
                onTap: () => _copyToClipboard('${stop.lng}', 'Longitude')),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.schedule, 'Next Arrival', stop.estimatedArrival, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isDark ? Colors.grey[400] : AppColors.neutralGray),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 15,
                  color: isDark ? Colors.grey[200] : Colors.black87)),
            ),
            Text(value, style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue)),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.copy, size: 16, color: Colors.grey[500]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(Stop stop) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _copyToClipboard('${stop.lat},${stop.lng}', 'Coordinates'),
            icon: const Icon(Icons.share_location, size: 18),
            label: const Text('Share Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {/* Navigate action */},
            icon: const Icon(Icons.directions, size: 18),
            label: const Text('Navigate'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}