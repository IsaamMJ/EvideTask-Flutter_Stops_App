import 'package:flutter/material.dart';
import '../../domain/entities/stop.dart';
import '../../core/theme/app_colors.dart';

class StopListItem extends StatelessWidget {
  final Stop stop;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const StopListItem({
    Key? key,
    required this.stop,
    required this.onTap,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Stop type icon with theme-aware styling
              CircleAvatar(
                radius: 24,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Text(
                  stop.stopType.iconEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stop.shortDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.neutralGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ETA: ${stop.estimatedArrival}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.neutralGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite button with better accessibility
              IconButton(
                icon: Icon(
                  stop.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: stop.isFavorite
                      ? AppColors.successGreen
                      : AppColors.neutralGray,
                  size: 24,
                ),
                onPressed: onFavoriteToggle,
                tooltip: stop.isFavorite
                    ? 'Remove from favorites'
                    : 'Add to favorites',
              ),
            ],
          ),
        ),
      ),
    );
  }
}