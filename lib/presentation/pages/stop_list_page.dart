import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/stops/stops_bloc.dart';
import '../bloc/stops/stops_event.dart';
import '../bloc/stops/stops_state.dart';
import '../widgets/search_bar.dart';
import '../widgets/stop_list_item.dart';
import 'stop_detail_page.dart';

class StopsListPage extends StatelessWidget {
  const StopsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stops'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<StopsBloc, StopsState>(
        builder: (context, state) {
          if (state is StopsInitial) {
            context.read<StopsBloc>().add(LoadStops());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StopsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StopsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StopsBloc>().add(LoadStops());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is StopsLoaded) {
            return Column(
              children: [
                StopSearchBar(
                  initialValue: state.searchQuery,
                  onChanged: (query) {
                    if (query.isEmpty) {
                      context.read<StopsBloc>().add(ClearSearch());
                    } else {
                      context.read<StopsBloc>().add(SearchStops(query));
                    }
                  },
                  onClear: () {
                    context.read<StopsBloc>().add(ClearSearch());
                  },
                ),
                Expanded(
                  child: state.stops.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          state.isSearching
                              ? 'No stops found for "${state.searchQuery}"'
                              : 'No stops available',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : RefreshIndicator(
                    onRefresh: () async {
                      context.read<StopsBloc>().add(LoadStops());
                    },
                    child: ListView.builder(
                      itemCount: state.stops.length,
                      itemBuilder: (context, index) {
                        final stop = state.stops[index];
                        return StopListItem(
                          stop: stop,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StopDetailPage(stopId: stop.id),
                              ),
                            );
                          },
                          onFavoriteToggle: () {
                            context.read<StopsBloc>().add(ToggleFavoriteStop(stop.id));
                          },
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
}