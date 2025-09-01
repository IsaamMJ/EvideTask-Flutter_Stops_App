import 'package:flutter/material.dart';
import '../../domain/entities/stop.dart';

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(stop.stopType.iconEmoji),
        ),
        title: Text(
          stop.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stop.shortDescription),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'ETA: ${stop.estimatedArrival}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            stop.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: stop.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }
}