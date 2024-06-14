import 'package:flutter/material.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingProvider.notifier).loadNexPage();
    ref.read(popularMoviesProvider.notifier).loadNexPage();
    ref.read(upcomingMoviesProvider.notifier).loadNexPage();
    ref.read(topRatedMoviesProvider.notifier).loadNexPage();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();
    final nowPlayingMovies = ref.watch(nowPlayingProvider);
    final slideshowMovies = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            children: [
              MoviesSlideshow(movies: slideshowMovies),
              MovieHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En cines',
                  subTitle: 'Lunes 20',
                  loadNexPage: () =>
                      ref.read(nowPlayingProvider.notifier).loadNexPage()),
              MovieHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                  loadNexPage: () =>
                      ref.read(upcomingMoviesProvider.notifier).loadNexPage()),
              MovieHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  subTitle: '',
                  loadNexPage: () =>
                      ref.read(popularMoviesProvider.notifier).loadNexPage()),
              MovieHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor calificadas',
                  subTitle: 'Desde Siempre',
                  loadNexPage: () =>
                      ref.read(topRatedMoviesProvider.notifier).loadNexPage()),
              const SizedBox(height: 50)
            ],
          );
        }, childCount: 1))
      ],
    );
  }
}
