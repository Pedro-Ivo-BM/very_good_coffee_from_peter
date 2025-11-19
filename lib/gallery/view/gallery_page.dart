import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_from_peter/gallery/bloc/gallery_bloc.dart';
import 'package:very_good_coffee_from_peter/gallery/widgets/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryBloc()..add(const GalleryRequested()),
      child: const GalleryView(),
    );
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          return switch (state.status) {
            GalleryStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            GalleryStatus.ready => GalleryGrid(colors: state.colors),
            GalleryStatus.initial => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}
