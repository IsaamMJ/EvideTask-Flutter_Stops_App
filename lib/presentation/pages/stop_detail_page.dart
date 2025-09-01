import 'package:evidetask/domain/entities/stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../bloc/stop_detail/stop_detail_bloc.dart';
import '../bloc/stop_detail/stop_detail_event.dart';
import '../bloc/stop_detail/stop_detail_state.dart';

class StopDetailPage extends StatelessWidget {
  final int stopId;

  const StopDetailPage({Key? key, required this.stopId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StopDetailBloc>()..add(LoadStopDetail(stopId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stop Details'),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<StopDetailBloc, StopDetailState>(
          builder: (context, state) {
            if (state is StopDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StopDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StopDetailBloc>().add(LoadStopDetail(stopId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is StopDetailLoaded) {
              final stop = state.stop;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  child: Text(
                                    stop.stopType.iconEmoji,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stop.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        stop.stopType.displayName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    stop.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: stop.isFavorite ? Colors.red : Colors.grey,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    context.read<StopDetailBloc>().add(ToggleFavoriteDetail(stop.id));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              stop.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Location & ETA Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Location & Timing',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(Icons.location_on, 'Latitude', '${stop.lat}°'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.location_on, 'Longitude', '${stop.lng}°'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.access_time, 'Estimated Arrival', stop.estimatedArrival),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}