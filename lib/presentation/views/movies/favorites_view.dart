import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/screens/movies/movie_masonry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    ref.read(favoriteMoviesProvider.notifier).loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    isLoading = false;
    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Movie> movies =
        ref.watch(favoriteMoviesProvider).values.toList();

    if (movies.isEmpty) {
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border_sharp,
                size: 60,
                color: colors.primary,
              ),
              Text(
                'Ohh no!!',
                style: TextStyle(fontSize: 20, color: colors.primary),
              ),
              const Text(
                'No tienes películas favoritas',
                style: TextStyle(
                    fontSize: 15, color: Color.fromARGB(58, 252, 251, 251)),
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton(
                  onPressed: () => context.go('/home/0'),
                  child: const Text('Empieza a buscar'))
            ]),
      );
    }
    return Scaffold(
        body: MovieMasonry(loadNextPage: loadNextPage, movies: movies));
  }
}
