import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_coffee_from_peter/app_router/routes.dart';
import 'package:very_good_coffee_from_peter/start/bloc/start_cubit.dart';
import 'package:very_good_coffee_from_peter/start/widgets/widgets.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StartCubit()..shuffleAccent(),
      child: const StartView(),
    );
  }
}

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: BlocBuilder<StartCubit, StartState>(
            builder: (context, state) {
              return StartHero(
                accentColor: state.accentColor,
                onViewGallery: () {
                  context.read<StartCubit>().shuffleAccent();
                  const GalleryRouteData().go(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
